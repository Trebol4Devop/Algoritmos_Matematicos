import 'MathParser.dart';
import 'MethodUtils.dart';

// Clase para resolver la ecuación de Poisson usando el método de diferencias finitas
class FiniteDifferenceEquationPoissonClass {
  String function1;
  String function2;
  double a;
  double b;
  double c;
  double d;
  int n;
  int m;
  int dn;
  double tol;
  int maxIterations;
  int iterations;
  List<List<double>> resultTable;

  FiniteDifferenceEquationPoissonClass({
    this.function1 = "",
    this.function2 = "",
    this.a = 0.0,
    this.b = 0.0,
    this.c = 0.0,
    this.d = 0.0,
    this.n = 0,
    this.m = 0,
    this.dn = 6,
    this.tol = 1e-6,
    this.maxIterations = 100,
    this.iterations = 0,
    List<List<double>>? resultTable,
  }) : resultTable = resultTable ?? [];

  void finiteDifferenceEquationPoissonMethod() {
    try {
      String? error = _validarParametros();
      if (error != null) throw Exception(error);

      MathParser parser = MathParser();

      double H = (b - a) / n;
      double K = (d - c) / m;

      double lambda = (H * H) / (K * K);
      double denominator = 2.0 * (1.0 + lambda);

      List<List<double>> W = List.generate(
        n + 1,
        (_) => List.filled(m + 1, 0.0),
      );
      List<double> X = List.filled(n + 1, 0.0);
      List<double> Y = List.filled(m + 1, 0.0);

      List<List<double>> F_values = List.generate(
        n + 1,
        (_) => List.filled(m + 1, 0.0),
      );

      for (int i = 0; i <= n; i++) X[i] = a + i * H;
      for (int j = 0; j <= m; j++) Y[j] = c + j * K;

      for (int i = 1; i < n; i++) {
        for (int j = 1; j < m; j++) {
          F_values[i][j] = _evaluarFuncion(parser, function1, X[i], Y[j]);
        }
      }

      for (int i = 0; i <= n; i++) {
        W[i][0] = _evaluarFuncion(parser, function2, X[i], Y[0]);
        W[i][m] = _evaluarFuncion(parser, function2, X[i], Y[m]);
      }
      for (int j = 0; j <= m; j++) {
        W[0][j] = _evaluarFuncion(parser, function2, X[0], Y[j]);
        W[n][j] = _evaluarFuncion(parser, function2, X[n], Y[j]);
      }

      double avgBoundary = (W[0][0] + W[n][m]) / 2.0;
      for (int i = 1; i < n; i++) {
        for (int j = 1; j < m; j++) {
          W[i][j] = avgBoundary;
        }
      }

      int L = 1;
      bool converged = false;

      while (L <= maxIterations && !converged) {
        double maxError = 0.0;

        for (int i = 1; i < n; i++) {
          for (int j = 1; j < m; j++) {
            double termX = W[i - 1][j] + W[i + 1][j];
            double termY = lambda * (W[i][j - 1] + W[i][j + 1]);
            double source = -(H * H) * F_values[i][j];

            double Z = (termX + termY + source) / denominator;

            double currentDiff = (W[i][j] - Z).abs();
            if (currentDiff > maxError) {
              maxError = currentDiff;
            }

            W[i][j] = Z;
          }
        }

        if (maxError <= tol) {
          converged = true;
          iterations = L;
        }
        L++;
      }

      if (!converged) {
        iterations = maxIterations;
      }

      _buildResultTable(W, X, Y);
    } catch (e) {
      throw Exception('Error en el método: $e');
    }
  }

  void _buildResultTable(List<List<double>> W, List<double> X, List<double> Y) {
    int count = 0;
    int totalPoints = (n - 1) * (m - 1);
    resultTable = List.generate(totalPoints, (_) => List.filled(5, 0.0));

    for (int I = 1; I <= n - 1; I++) {
      for (int J = 1; J <= m - 1; J++) {
        resultTable[count][0] = I.toDouble();
        resultTable[count][1] = J.toDouble();
        resultTable[count][2] = X[I];
        resultTable[count][3] = Y[J];
        resultTable[count][4] = MethodUtils.redondear(W[I][J], dn);
        count++;
      }
    }
  }

  double _evaluarFuncion(MathParser parser, String func, double x, double y) {
    try {
      return parser.evaluar2Variables(func, x, y);
    } catch (e) {
      return parser.evaluarExpresion(func, {'x': x, 'y': y});
    }
  }

  String? _validarParametros() {
    if (function1.isEmpty || function2.isEmpty) {
      return "Error: Ambas funciones son requeridas";
    }

    if (n <= 0 || m <= 0) {
      return "Error: n y m deben ser mayores que 0";
    }

    if (a >= b || c >= d) {
      return "Error: El dominio debe ser válido (a < b, c < d)";
    }

    if (tol <= 0) {
      return "Error: La tolerancia debe ser mayor que 0";
    }

    if (maxIterations <= 0) {
      return "Error: El número máximo de iteraciones debe ser mayor que 0";
    }

    if (dn < 0) {
      return "Error: El número de decimales debe ser no negativo";
    }

    try {
      double testX = (a + b) / 2;
      double testY = (c + d) / 2;

      if (!_validarFuncionEnPunto(function1, testX, testY)) {
        return "Error: La función f(x,y) no es válida en el dominio";
      }

      if (!_validarFuncionEnPunto(function2, testX, testY)) {
        return "Error: La función de frontera g(x,y) no es válida en el dominio";
      }
    } catch (e) {
      return "Error al validar las funciones: $e";
    }

    return null;
  }

  bool _validarFuncionEnPunto(String funcion, double x, double y) {
    try {
      MathParser parser = MathParser();
      double resultado = _evaluarFuncion(parser, funcion, x, y);
      return !resultado.isNaN && !resultado.isInfinite;
    } catch (e) {
      return false;
    }
  }

  List<List<String>> getResultTableFormatted() {
    List<List<String>> formattedTable = [];

    formattedTable.add(['i', 'j', 'x_i', 'y_j', 'u(x_i, y_j)']);

    for (int i = 0; i < resultTable.length; i++) {
      List<String> row = [
        resultTable[i][0].toInt().toString(),
        resultTable[i][1].toInt().toString(),
        MethodUtils.redondear(resultTable[i][2], dn).toString(),
        MethodUtils.redondear(resultTable[i][3], dn).toString(),
        MethodUtils.redondear(resultTable[i][4], dn).toString(),
      ];
      formattedTable.add(row);
    }

    return formattedTable;
  }

  Map<String, dynamic> getParametersSummary() {
    return {
      'f(x,y)': function1,
      'g(x,y)': function2,
      'Límite inferior a': a,
      'Límite superior b': b,
      'Límite inferior c': c,
      'Límite superior d': d,
      'N': n,
      'M': m,
      'Tolerancia': tol,
      'Iteraciones máximas': maxIterations,
      'Iteraciones realizadas': iterations,
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
Propósito: Resolver ecuaciones diferenciales parciales elípticas (como la ecuación de Poisson) en dominios con condiciones de frontera, modelando estados estacionarios de sistemas físicos.

Fundamento: Discretiza el dominio mediante una malla y aproxima el operador Laplaciano usando diferencias finitas, transformando la EDP en un sistema algebraico lineal.

Características:

  Genera un sistema matricial grande, rígido y disperso Au=b.

  Las condiciones de frontera se incorporan directamente en el sistema.

  Requiere métodos iterativos o directos para resolver el sistema.

Ventajas:

    Robustez y aplicabilidad a geometrías complejas.

    Fácil implementación de condiciones de frontera mixtas.

    Estabilidad inherente por ser problemas elípticos.

    Base para métodos más avanzados (elementos finitos).
''';
  }
}
