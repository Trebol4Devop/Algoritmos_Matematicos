import 'MathParser.Dart';
import 'MethodUtils.Dart';

// Clase para el método de disparo lineal
class LinealShotClass {
  String p_x;
  String q_x;
  String r_x;
  int n;
  int dn;
  double alpha;
  double beta;
  double lowerLimit;
  double upperLimit;
  List<List<double>> resultTable;

  LinealShotClass({
    this.p_x = "",
    this.q_x = "",
    this.r_x = "",
    this.n = 0,
    this.dn = 4,
    this.alpha = 0.0,
    this.beta = 0.0,
    this.lowerLimit = 0.0,
    this.upperLimit = 0.0,
    List<List<double>>? resultTable,
  }) : resultTable = resultTable ?? [];

  void linealShotMethod() {
    try {
      String? error = _validarParametros();
      if (error != null) {
        throw Exception(error);
      }

      List<List<double>> U = List.generate(2, (_) => List.filled(n, 0.0));
      List<List<double>> V = List.generate(2, (_) => List.filled(n, 0.0));
      
      double h = (upperLimit - lowerLimit) / n;
      MathParser parser = MathParser();

      double U1 = alpha;
      double U2 = 0.0;
      double V1 = 0.0;
      double V2 = 1.0;

      for (int i = 1; i <= n; i++) {
        double x_i = lowerLimit + (i - 1) * h;
        double T = x_i + 0.5 * h;

        double k11 = h * U2;
        double k12 = h * (
          parser.evaluar(p_x, 'x', x_i) * U2 +
          parser.evaluar(q_x, 'x', x_i) * U1 +
          parser.evaluar(r_x, 'x', x_i)
        );

        double k21 = h * (U2 + 0.5 * k12);
        double k22 = h * (
          parser.evaluar(p_x, 'x', T) * (U2 + 0.5 * k12) +
          parser.evaluar(q_x, 'x', T) * (U1 + 0.5 * k11) +
          parser.evaluar(r_x, 'x', T)
        );

        double k31 = h * (U2 + 0.5 * k22);
        double k32 = h * (
          parser.evaluar(p_x, 'x', T) * (U2 + 0.5 * k22) +
          parser.evaluar(q_x, 'x', T) * (U1 + 0.5 * k21) +
          parser.evaluar(r_x, 'x', T)
        );

        T = x_i + h;
        double k41 = h * (U2 + k32);
        double k42 = h * (
          parser.evaluar(p_x, 'x', T) * (U2 + k32) +
          parser.evaluar(q_x, 'x', T) * (U1 + k31) +
          parser.evaluar(r_x, 'x', T)
        );

        U1 += (k11 + 2.0 * (k21 + k31) + k41) / 6.0;
        U2 += (k12 + 2.0 * (k22 + k32) + k42) / 6.0;

        k11 = h * V2;
        k12 = h * (
          parser.evaluar(p_x, 'x', x_i) * V2 +
          parser.evaluar(q_x, 'x', x_i) * V1
        );

        T = x_i + 0.5 * h;
        k21 = h * (V2 + 0.5 * k12);
        k22 = h * (
          parser.evaluar(p_x, 'x', T) * (V2 + 0.5 * k12) +
          parser.evaluar(q_x, 'x', T) * (V1 + 0.5 * k11)
        );

        k31 = h * (V2 + 0.5 * k22);
        k32 = h * (
          parser.evaluar(p_x, 'x', T) * (V2 + 0.5 * k22) +
          parser.evaluar(q_x, 'x', T) * (V1 + 0.5 * k21)
        );

        T = x_i + h;
        k41 = h * (V2 + k32);
        k42 = h * (
          parser.evaluar(p_x, 'x', T) * (V2 + k32) +
          parser.evaluar(q_x, 'x', T) * (V1 + k31)
        );

        V1 += (k11 + 2.0 * (k21 + k31) + k41) / 6.0;
        V2 += (k12 + 2.0 * (k22 + k32) + k42) / 6.0;

        U[0][i - 1] = U1;
        U[1][i - 1] = U2;
        V[0][i - 1] = V1;
        V[1][i - 1] = V2;
      }

      double Z = (beta - U[0][n - 1]) / V[0][n - 1];

      resultTable = List.generate(n + 1, (index) => List.filled(4, 0.0));

      resultTable[0][0] = 0.0;
      resultTable[0][1] = lowerLimit;
      resultTable[0][2] = alpha;
      resultTable[0][3] = Z;

      for (int i = 1; i <= n; i++) {
        double x = lowerLimit + i * h;
        double W1 = U[0][i - 1] + Z * V[0][i - 1];
        double W2 = U[1][i - 1] + Z * V[1][i - 1];

        resultTable[i][0] = i.toDouble();
        resultTable[i][1] = x;
        resultTable[i][2] = MethodUtils.redondear(W1, dn);
        resultTable[i][3] = MethodUtils.redondear(W2, dn);
      }

    } catch (e) {
      throw Exception('Error en el método de disparo lineal: $e');
    }
  }

  String? _validarParametros() {
    if (p_x.isEmpty || q_x.isEmpty || r_x.isEmpty) {
      return "Error: Las funciones p(x), q(x) y r(x) son requeridas";
    }

    if (n <= 0) {
      return "Error: n debe ser mayor que 0";
    }

    if (lowerLimit >= upperLimit) {
      return "Error: El límite inferior debe ser menor que el superior";
    }

    if (dn < 0) {
      return "Error: El número de decimales debe ser no negativo";
    }

    try {
      double testPoint = (lowerLimit + upperLimit) / 2;
      
      if (!MethodUtils.validarFuncionEnPunto(p_x, 'x', testPoint)) {
        return "Error: La función p(x) no es válida en el intervalo";
      }
      
      if (!MethodUtils.validarFuncionEnPunto(q_x, 'x', testPoint)) {
        return "Error: La función q(x) no es válida en el intervalo";
      }
      
      if (!MethodUtils.validarFuncionEnPunto(r_x, 'x', testPoint)) {
        return "Error: La función r(x) no es válida en el intervalo";
      }
      
    } catch (e) {
      return "Error al validar las funciones: $e";
    }

    return null;
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
      'p(x)': p_x,
      'q(x)': q_x,
      'r(x)': r_x,
      'Límite inferior (a)': lowerLimit,
      'Límite superior (b)': upperLimit,
      'N': n,
      'Alpha (A)': alpha,
      'Beta (β)': beta,
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
Propósito: Resolver problemas de valor límite (frontera) para ecuaciones diferenciales lineales, transformándolos en problemas de valor inicial mediante ajustes iterativos de condiciones iniciales.

Fundamento: Convierte la ecuación diferencial lineal en dos problemas de valor inicial: uno homogéneo y uno no homogéneo, cuya combinación lineal satisface las condiciones de frontera.

Características:

    Requiere resolver dos problemas de valor inicial por iteración.

    Utiliza métodos numéricos para integrar.

    Ajusta condiciones iniciales mediante interpolación lineal.

    Específico para ecuaciones diferenciales lineales.

Ventajas:

    Aprovecha algoritmos eficientes para problemas de valor inicial.

    Convergencia en una iteración para ecuaciones lineales.

    Implementación sencilla comparada con métodos de diferencias finitas.

    Precisión controlada por el método de integración subyacente.
''';
  }
}