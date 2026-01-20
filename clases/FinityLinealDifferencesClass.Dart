import 'dart:math';
import 'MathParser.Dart';
import 'MethodClass.Dart';
import 'MethodUtils.Dart';

/// Implementación del método de diferencias finitas para ecuaciones diferenciales lineales
class FinityLinealDifferencesClass extends MethodClass {
  String p_x;
  String q_x;
  String r_x;
  int n;
  double alpha;
  double beta;
  double lowerLimit;
  double upperLimit;
  int dn;
  List<List<dynamic>> resultTable;
  
  FinityLinealDifferencesClass({
    this.p_x = "",
    this.q_x = "",
    this.r_x = "",
    this.n = 0,
    this.alpha = 0.0,
    this.beta = 0.0,
    this.lowerLimit = 0.0,
    this.upperLimit = 0.0,
    this.dn = 6,
    List<List<dynamic>>? resultTable,
    int id = 1,
    String title = "Método de Diferencias Finitas Lineales",
    String subtitle = "Resuelve EDOs lineales con condiciones de frontera",
    String index = "FINITE_DIFF",
  }) : resultTable = resultTable ?? [] {
    this.id = id;
    this.title = title;
    this.subtitle = subtitle;
    this.index = index;
  }

  @override
  void initialize() {
    super.initialize();
    resultTable.clear();
  }

  void finityLinealDifferencesMethod() {
    initialize();
    resultTable.clear();

    try {
      if (p_x.isEmpty || q_x.isEmpty || r_x.isEmpty) {
        message = "Error: debe proporcionar las funciones p(x), q(x) y r(x)";
        return;
      }

      if (lowerLimit >= upperLimit) {
        message = "Error: el límite inferior debe ser menor que el superior";
        return;
      }

      if (n <= 0) {
        message = "Error: el número de particiones debe ser mayor que 0";
        return;
      }

      List<double> puntosPrueba = [lowerLimit, (lowerLimit + upperLimit) / 2, upperLimit];
      if (!MethodUtils.validarFuncionX(p_x, puntosPrueba) ||
          !MethodUtils.validarFuncionX(q_x, puntosPrueba) ||
          !MethodUtils.validarFuncionX(r_x, puntosPrueba)) {
        message = "Error: alguna función produce valores no válidos en el dominio";
        return;
      }

      double h = (upperLimit - lowerLimit) / (n + 1);
      
      List<double> A = List.filled(n, 0.0);
      List<double> B = List.filled(n, 0.0);
      List<double> C = List.filled(n, 0.0);
      List<double> D = List.filled(n, 0.0);
      List<double> L = List.filled(n, 0.0);
      List<double> U = List.filled(n, 0.0);
      List<double> Z = List.filled(n, 0.0);
      List<double> W = List.filled(n, 0.0);

      double x = lowerLimit + h;
      A[0] = 2.0 + h * h * _evaluarFuncion(q_x, x);
      B[0] = -1.0 + 0.5 * h * _evaluarFuncion(p_x, x);
      D[0] = -h * h * _evaluarFuncion(r_x, x) + (1.0 + 0.5 * h * _evaluarFuncion(p_x, x)) * alpha;

      for (int j = 2; j <= n - 1; j++) {
        x = lowerLimit + j * h;
        A[j - 1] = 2.0 + h * h * _evaluarFuncion(q_x, x);
        B[j - 1] = -1.0 + 0.5 * h * _evaluarFuncion(p_x, x);
        C[j - 1] = -1.0 - 0.5 * h * _evaluarFuncion(p_x, x);
        D[j - 1] = -h * h * _evaluarFuncion(r_x, x);
      }

      x = upperLimit - h;
      A[n - 1] = 2.0 + h * h * _evaluarFuncion(q_x, x);
      C[n - 1] = -1.0 - 0.5 * h * _evaluarFuncion(p_x, x);
      D[n - 1] = -h * h * _evaluarFuncion(r_x, x) + (1.0 - 0.5 * h * _evaluarFuncion(p_x, x)) * beta;

      L[0] = A[0];
      U[0] = B[0] / A[0];
      Z[0] = D[0] / L[0];

      for (int i = 2; i <= n - 1; i++) {
        L[i - 1] = A[i - 1] - C[i - 1] * U[i - 2];
        U[i - 1] = B[i - 1] / L[i - 1];
        Z[i - 1] = (D[i - 1] - C[i - 1] * Z[i - 2]) / L[i - 1];
      }

      L[n - 1] = A[n - 1] - C[n - 1] * U[n - 2];
      Z[n - 1] = (D[n - 1] - C[n - 1] * Z[n - 2]) / L[n - 1];
      W[n - 1] = Z[n - 1];

      for (int j = 1; j <= n - 1; j++) {
        int k = n - j;
        W[k - 1] = Z[k - 1] - U[k - 1] * W[k];
      }

      resultTable.add([
        "0",
        MethodUtils.redondear(lowerLimit, dn),
        MethodUtils.redondear(alpha, dn)
      ]);

      for (int i = 1; i <= n; i++) {
        x = lowerLimit + i * h;
        resultTable.add([
          i.toString(),
          MethodUtils.redondear(x, dn),
          MethodUtils.redondear(W[i - 1], dn)
        ]);
      }

      resultTable.add([
        (n + 1).toString(),
        MethodUtils.redondear(upperLimit, dn),
        MethodUtils.redondear(beta, dn)
      ]);

      success = true;
      iterations = n;
      result = MethodUtils.redondear(W[n ~/ 2], dn);
      message = "Solución completada exitosamente con $n puntos interiores\n"
                "Paso h = ${MethodUtils.redondear(h, dn)}\n"
                "Ecuación: y'' = p(x)y' + q(x)y + r(x)";

    } catch (e) {
      message = "Error durante la ejecución: ${e.toString()}";
      success = false;
    }
  }

  double _evaluarFuncion(String funcion, double x) {
    return MethodUtils.evaluarFuncionX(funcion, x);
  }

  Map<String, dynamic> analizarEcuacion() {
    Map<String, dynamic> analisis = {};
    
    try {
      double h = (upperLimit - lowerLimit) / (n + 1);
      
      analisis['paso_h'] = MethodUtils.redondear(h, dn);
      analisis['rango_x'] = '[${MethodUtils.redondear(lowerLimit, dn)}, ${MethodUtils.redondear(upperLimit, dn)}]';
      analisis['puntos_interiores'] = n;
      analisis['condiciones_frontera'] = 'y($lowerLimit) = $alpha, y($upperLimit) = $beta';

      double x_medio = (lowerLimit + upperLimit) / 2;
      
      analisis['p(x_medio)'] = MethodUtils.redondear(_evaluarFuncion(p_x, x_medio), dn);
      analisis['q(x_medio)'] = MethodUtils.redondear(_evaluarFuncion(q_x, x_medio), dn);
      analisis['r(x_medio)'] = MethodUtils.redondear(_evaluarFuncion(r_x, x_medio), dn);

      analisis['tamaño_sistema'] = '${n}x$n (tridiagonal)';
      analisis['ecuacion'] = 'y\'\' = ${_formatearEcuacion(p_x)}y\' + ${_formatearEcuacion(q_x)}y + ${_formatearEcuacion(r_x)}';
      
    } catch (e) {
      analisis['error'] = e.toString();
    }
    
    return analisis;
  }

  String _formatearEcuacion(String expr) {
    if (expr == "0") return "0";
    return expr.isEmpty ? "?" : expr;
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json.addAll({
      'p_x': p_x,
      'q_x': q_x,
      'r_x': r_x,
      'n': n,
      'alpha': alpha,
      'beta': beta,
      'lowerLimit': lowerLimit,
      'upperLimit': upperLimit,
      'dn': dn,
      'resultTable': resultTable,
    });
    return json;
  }

  @override
  String getResultSummary() {
    if (resultTable.isEmpty) return super.getResultSummary();
    
    return '${super.getResultSummary()}\n'
           'Ecuación: y\'\' = ${_formatearEcuacion(p_x)}y\' + ${_formatearEcuacion(q_x)}y + ${_formatearEcuacion(r_x)}\n'
           'Condiciones: y($lowerLimit) = $alpha, y($upperLimit) = $beta\n'
           'Particiones: $n puntos interiores';
  }

  List<Map<String, double>> obtenerPuntosGrafica() {
    List<Map<String, double>> puntos = [];
    
    for (List<dynamic> fila in resultTable) {
      double x = (fila[1] as double);
      double y = (fila[2] as double);
      
      puntos.add({'x': x, 'y': y});
    }
    
    return puntos;
  }

  List<Map<String, dynamic>> calcularErrorEstimado() {
    List<Map<String, dynamic>> errores = [];
    
    if (resultTable.length < 3) return errores;

    for (int i = 1; i < resultTable.length - 1; i++) {
      double x = (resultTable[i][1] as double);
      double y = (resultTable[i][2] as double);

      double error = 0.0;
      if (i > 1 && i < resultTable.length - 2) {
        double y_prev = (resultTable[i-1][2] as double);
        double y_next = (resultTable[i+1][2] as double);
        error = (y_next - 2*y + y_prev).abs();
      }
      
      errores.add({
        'x': MethodUtils.redondear(x, dn),
        'y': MethodUtils.redondear(y, dn),
        'error_estimado': MethodUtils.redondear(error, dn)
      });
    }
    
    return errores;
  }

  String getMethodDescription() {
    return '''
Propósito: Resolver problemas de valor en la frontera para ecuaciones diferenciales lineales discretizando el dominio y aproximando las derivadas mediante operadores en diferencias.

Fundamento: Sustituye las derivadas de la ecuación diferencial por cocientes de diferencias finitas en una malla nodal, transformando el problema continuo en un sistema de ecuaciones algebraicas lineales.

Características:

  Discretiza el dominio en una malla de puntos equiespaciados.

  Aproxima derivadas usando expansiones en serie de Taylor.

  Genera un sistema matricial tridiagonal o banda.

  Es un método directo (no iterativo) para ecuaciones lineales.

Ventajas:

  Implementación sencilla y sistemática.

   Solución directa y estable para problemas lineales.

  No requiere valores iniciales ni iteraciones.

  Fácil extensión a problemas de dimensiones superiores.
''';
  }
}