import 'MathParser.Dart';
import 'MethodUtils.Dart';
import 'ComplexOperationClass.Dart';

// Clase para el método de disparo no lineal en ecuaciones diferenciales con condiciones de frontera no lineales
class NoLinealShotClass {
  String function;
  String df1dy;
  String df2dy;
  double alpha;
  double beta;
  double lowerLimit;
  double upperLimit;
  int n;
  int m;
  int dn;
  double tol;
  List<List<double>> resultTable;

  NoLinealShotClass({
    this.function = "",
    this.df1dy = "",
    this.df2dy = "",
    this.alpha = 0.0,
    this.beta = 0.0,
    this.lowerLimit = 0.0,
    this.upperLimit = 0.0,
    this.n = 0,
    this.m = 10,
    this.dn = 6,
    this.tol = 1e-6,
    List<List<double>>? resultTable,
  }) : resultTable = resultTable ?? [];

  void noLinealShotMethod() {
    try {
      String? error = _validarParametros();
      if (error != null) {
        throw Exception(error);
      }

      MathParser parser = MathParser();
      double h = (upperLimit - lowerLimit) / n;

      double tk = (beta - alpha) / (upperLimit - lowerLimit);
      double tk1 = 0.0;
      
      int iterations = 0;
      bool converged = false;
      for (int k = 0; k < m; k++) {
        iterations = k;
        List<List<double>> solution = _solveIVP(parser, tk);
        double phi_tk = solution[0][n] - beta;
        if (phi_tk.abs() < tol) {
          converged = true;
          break;
        }

        double h_prime = 0.001;
        List<List<double>> solution_prime = _solveIVP(parser, tk + h_prime);
        double phi_tk_prime = (solution_prime[0][n] - beta - phi_tk) / h_prime;

        if (phi_tk_prime.abs() > 1e-10) {
          tk1 = tk - phi_tk / phi_tk_prime;
        } else {
          throw Exception("Derivada cercana a cero en iteración $k");
        }
        tk = tk1;
      }

      if (!converged) {
        throw Exception("El método no convergió después de $m iteraciones");
      }
      List<List<double>> finalSolution = _solveIVP(parser, tk);

      _buildResultTable(finalSolution, h);

    } catch (e) {
      throw Exception('Error en el método de disparo no lineal: $e');
    }
  }
  List<List<double>> _solveIVP(MathParser parser, double initialSlope) {
    List<double> y = List.filled(n + 1, 0.0);
    List<double> yPrime = List.filled(n + 1, 0.0);
    
    double h = (upperLimit - lowerLimit) / n;

    y[0] = alpha;
    yPrime[0] = initialSlope;
    for (int i = 0; i < n; i++) {
      double x_i = lowerLimit + i * h;
      
      double k1_y = h * yPrime[i];
      double k1_yp = h * _evaluateFunction(parser, function, x_i, y[i], yPrime[i]);
      
      double k2_y = h * (yPrime[i] + 0.5 * k1_yp);
      double k2_yp = h * _evaluateFunction(parser, function, x_i + 0.5 * h, 
                                         y[i] + 0.5 * k1_y, yPrime[i] + 0.5 * k1_yp);

      double k3_y = h * (yPrime[i] + 0.5 * k2_yp);
      double k3_yp = h * _evaluateFunction(parser, function, x_i + 0.5 * h,
                                         y[i] + 0.5 * k2_y, yPrime[i] + 0.5 * k2_yp);

      double k4_y = h * (yPrime[i] + k3_yp);
      double k4_yp = h * _evaluateFunction(parser, function, x_i + h,
                                         y[i] + k3_y, yPrime[i] + k3_yp);

      y[i + 1] = y[i] + (k1_y + 2 * k2_y + 2 * k3_y + k4_y) / 6;
      yPrime[i + 1] = yPrime[i] + (k1_yp + 2 * k2_yp + 2 * k3_yp + k4_yp) / 6;
    }
    
    return [y, yPrime];
  }
  double _evaluateFunction(MathParser parser, String func, double x, double y, double yPrime) {
    try {
      return parser.evaluarExpresion(func, {'x': x, 'y': y, 'z': yPrime});
    } catch (e) {
      return parser.evaluarExpresion(func, {'x': x, 'y': y, 'dy': yPrime});
    }
  }
  void _buildResultTable(List<List<double>> solution, double h) {
    resultTable = List.generate(n + 1, (index) => List.filled(4, 0.0));
    
    for (int i = 0; i <= n; i++) {
      double x = lowerLimit + i * h;
      resultTable[i][0] = i.toDouble();
      resultTable[i][1] = x;
      resultTable[i][2] = MethodUtils.redondear(solution[0][i], dn);
      resultTable[i][3] = MethodUtils.redondear(solution[1][i], dn);
    }
  }
  String? _validarParametros() {
    if (function.isEmpty) {
      return "Error: La función diferencial es requerida";
    }

    if (n <= 0) {
      return "Error: n debe ser mayor que 0";
    }

    if (m <= 0) {
      return "Error: m debe ser mayor que 0";
    }

    if (lowerLimit >= upperLimit) {
      return "Error: El límite inferior debe ser menor que el superior";
    }

    if (tol <= 0) {
      return "Error: La tolerancia debe ser mayor que 0";
    }

    if (dn < 0) {
      return "Error: El número de decimales debe ser no negativo";
    }
    try {
      double testX = (lowerLimit + upperLimit) / 2;
      double testY = (alpha + beta) / 2;
      double testYPrime = 0.0;
      
      if (!_validarFuncionEnPunto(function, testX, testY, testYPrime)) {
        return "Error: La función diferencial no es válida en el intervalo";
      }
      
    } catch (e) {
      return "Error al validar la función: $e";
    }

    return null;
  }
  bool _validarFuncionEnPunto(String funcion, double x, double y, double yPrime) {
    try {
      MathParser parser = MathParser();
      double resultado = _evaluateFunction(parser, funcion, x, y, yPrime);
      return !resultado.isNaN && !resultado.isInfinite;
    } catch (e) {
      return false;
    }
  }

  List<List<String>> getResultTableFormatted() {
    List<List<String>> formattedTable = [];

    formattedTable.add(['i', 'x_i', 'y(x_i)', 'y\'(x_i)']);

    for (int i = 0; i < resultTable.length; i++) {
      List<String> row = [
        resultTable[i][0].toInt().toString(),
        MethodUtils.redondear(resultTable[i][1], dn).toString(),
        MethodUtils.redondear(resultTable[i][2], dn).toString(),
        MethodUtils.redondear(resultTable[i][3], dn).toString(),
      ];
      formattedTable.add(row);
    }
    
    return formattedTable;
  }
  Map<String, dynamic> getParametersSummary() {
    return {
      'Función': function,
      'df1/dy': df1dy,
      'df2/dy': df2dy,
      'Alpha (A)': alpha,
      'Beta (β)': beta,
      'Límite inferior (a)': lowerLimit,
      'Límite superior (b)': upperLimit,
      'N': n,
      'M (iteraciones máx)': m,
      'Tolerancia': tol,
      'Decimales': dn,
    };
  }
  Map<String, dynamic> toJson() {
    return {
      'parameters': getParametersSummary(),
      'results': resultTable,
      'formatted_results': getResultTableFormatted(),
    };
  }

  String getMethodDescription() {
    return '''
Propósito: Resolver problemas de valor en la frontera para ecuaciones diferenciales no lineales mediante la conversión a problemas de valor inicial.

Fundamento: Transforma el problema no lineal en una sucesión de problemas de valor inicial, ajustando iterativamente las condiciones iniciales usando métodos de búsqueda de raíces.

Características:

    Requiere resolver múltiples problemas de valor inicial por iteración.

    Utiliza un método numérico para cada integración.

    Ajusta condiciones iniciales mediante métodos iterativos no lineales.

    La convergencia no está garantizada.

Ventajas:

    Alta precisión si converge.

    Reutiliza algoritmos para problemas de valor inicial.

    No requiere discretización espacial como métodos de diferencias finitas.

    Flexible para diferentes tipos de condiciones de frontera.

''';
  }
}