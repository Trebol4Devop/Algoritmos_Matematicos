import 'dart:math';
import 'MathParser.Dart';
import 'MethodClass.Dart';
import 'MethodUtils.Dart';

/// Implementación del método de diferencias regresivas para la ecuación del calor
class RegressiveDifferencesEquationHeatClass extends MethodClass {
  String function;
  double upperLimit;
  double maxTime;
  int n;
  int m;
  double alpha;
  int dn;
  List<List<dynamic>> resultTable;
  
  RegressiveDifferencesEquationHeatClass({
    this.function = "",
    this.upperLimit = 0.0,
    this.maxTime = 0.0,
    this.n = 0,
    this.m = 0,
    this.alpha = 0.0,
    this.dn = 6,
    List<List<dynamic>>? resultTable,
    int id = 1,
    String title = "Método de Diferencias Regresivas para la Ecuación del Calor",
    String subtitle = "Resuelve ecuaciones parabólicas usando método implícito",
    String index = "HEAT_EQ",
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

  void regressiveDifferencesEquationHeatMethod() {
    initialize();
    resultTable.clear();

    try {
      if (function.isEmpty) {
        message = "Error: debe proporcionar la función inicial f(x)";
        return;
      }

      if (upperLimit <= 0) {
        message = "Error: el límite superior debe ser mayor que 0";
        return;
      }

      if (maxTime <= 0) {
        message = "Error: el tiempo máximo debe ser mayor que 0";
        return;
      }

      if (m <= 0) {
        message = "Error: el número de divisiones espaciales debe ser mayor que 0";
        return;
      }

      if (n <= 0) {
        message = "Error: el número de divisiones temporales debe ser mayor que 0";
        return;
      }

      if (alpha <= 0) {
        message = "Error: el coeficiente alpha debe ser mayor que 0";
        return;
      }
      List<double> puntosPrueba = [0.0, upperLimit/2, upperLimit];
      if (!MethodUtils.validarFuncionX(function, puntosPrueba)) {
        message = "Error: la función produce valores no válidos en el dominio";
        return;
      }
      List<double> w = List.filled(m - 1, 0.0);
      List<double> l = List.filled(m - 1, 0.0);
      List<double> u = List.filled(m - 1, 0.0);
      List<double> z = List.filled(m - 1, 0.0);
      double h = upperLimit / m;
      double k = maxTime / n;
      double lambda = alpha * alpha * k / (h * h);
      resultTable.add([
        "0",
        MethodUtils.redondear(0.0, dn),
        MethodUtils.redondear(0.0, dn)
      ]);
      for (int j = 1; j <= m - 1; j++) {
        double x = j * h;
        w[j - 1] = _evaluarFuncionX(function, x);
      }
      l[0] = 1.0 + 2.0 * lambda;
      u[0] = -lambda / l[0];
      for (int i = 2; i <= m - 2; i++) {
        l[i - 1] = 1.0 + 2.0 * lambda + lambda * u[i - 2];
        u[i - 1] = -lambda / l[i - 1];
      }
      l[m - 2] = 1.0 + 2.0 * lambda + lambda * u[m - 3];
      for (int j = 1; j <= n; j++) {
        z[0] = w[0] / l[0];
        
        for (int i = 2; i <= m - 1; i++) {
          z[i - 1] = (w[i - 1] + lambda * z[i - 2]) / l[i - 1];
        }

        w[m - 2] = z[m - 2];
        for (int i = 1; i <= m - 2; i++) {
          int index = m - 2 - i;
          w[index] = z[index] - u[index] * w[index + 1];
        }
      }
      for (int i = 1; i <= m - 1; i++) {
        double x = i * h;
        resultTable.add([
          i.toString(),
          MethodUtils.redondear(x, dn),
          MethodUtils.redondear(w[i - 1], dn)
        ]);
      }
      resultTable.add([
        m.toString(),
        MethodUtils.redondear(upperLimit, dn),
        MethodUtils.redondear(0.0, dn)
      ]);

      success = true;
      iterations = n;
      result = MethodUtils.redondear(w[(m - 1) ~/ 2], dn);
      message = "Solución completada exitosamente\n"
                "Tiempo final: t = ${MethodUtils.redondear(maxTime, dn)}\n"
                "Paso espacial h = ${MethodUtils.redondear(h, dn)}\n"
                "Paso temporal k = ${MethodUtils.redondear(k, dn)}\n"
                "Parámetro v = ${MethodUtils.redondear(lambda, dn)}";

    } catch (e) {
      message = "Error durante la ejecución: ${e.toString()}";
      success = false;
    }
  }
  double _evaluarFuncionX(String funcion, double x) {
    return MethodUtils.evaluarFuncionX(funcion, x);
  }
  Map<String, dynamic> analizarEcuacionCalor() {
    Map<String, dynamic> analisis = {};
    
    try {
      double h = upperLimit / m;
      double k = maxTime / n;
      double lambda = alpha * alpha * k / (h * h);
      
      analisis['paso_espacial_h'] = MethodUtils.redondear(h, dn);
      analisis['paso_temporal_k'] = MethodUtils.redondear(k, dn);
      analisis['parametro_lambda'] = MethodUtils.redondear(lambda, dn);
      analisis['rango_espacial'] = '[0, ${MethodUtils.redondear(upperLimit, dn)}]';
      analisis['tiempo_final'] = MethodUtils.redondear(maxTime, dn);
      analisis['divisiones_espaciales'] = m;
      analisis['divisiones_temporales'] = n;
      analisis['coeficiente_alpha'] = alpha;
      analisis['condicion_frontera_1'] = 'u(0,t) = 0';
      analisis['condicion_frontera_2'] = 'u($upperLimit,t) = 0';
      analisis['condicion_inicial'] = 'u(x,0) = $function';
      analisis['metodo'] = 'Diferencias Regresivas (Implícito)';
      analisis['estabilidad'] = 'Incondicionalmente estable';
      analisis['precision'] = 'O(k + h2)';
      double x1 = upperLimit / 4;
      double x2 = upperLimit / 2;
      double x3 = 3 * upperLimit / 4;
      
      analisis['f(x1)'] = MethodUtils.redondear(_evaluarFuncionX(function, x1), dn);
      analisis['f(x2)'] = MethodUtils.redondear(_evaluarFuncionX(function, x2), dn);
      analisis['f(x3)'] = MethodUtils.redondear(_evaluarFuncionX(function, x3), dn);
      analisis['tamaño_sistema'] = '${m-1}x${m-1} (tridiagonal)';
      analisis['iteraciones_temporales'] = n;
      
    } catch (e) {
      analisis['error'] = e.toString();
    }
    
    return analisis;
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json.addAll({
      'function': function,
      'upperLimit': upperLimit,
      'maxTime': maxTime,
      'n': n,
      'm': m,
      'alpha': alpha,
      'dn': dn,
      'resultTable': resultTable,
    });
    return json;
  }

  @override
  String getResultSummary() {
    if (resultTable.isEmpty) return super.getResultSummary();
    
    return '${super.getResultSummary()}\n'
           'Ecuación: du/dt = A2 d2u/dx2\n'
           'Condición inicial: u(x,0) = $function\n'
           'Condiciones frontera: u(0,t) = 0, u($upperLimit,t) = 0\n'
           'Parámetros: A = $alpha, l = $upperLimit, T = $maxTime\n'
           'Mallado: $m divisiones espaciales, $n divisiones temporales';
  }

  List<Map<String, double>> obtenerPuntosGrafica() {
    List<Map<String, double>> puntos = [];
    
    for (List<dynamic> fila in resultTable) {
      double x = (fila[1] as double);
      double u = (fila[2] as double);
      
      puntos.add({'x': x, 'u': u});
    }
    
    return puntos;
  }

  List<Map<String, dynamic>> calcularEvolucionTemporal({int numTiempos = 5}) {
    List<Map<String, dynamic>> evolucion = [];
    
    try {
      double h = upperLimit / m;
      double k = maxTime / n;
      double lambda = alpha * alpha * k / (h * h);
      List<double> w = List.filled(m - 1, 0.0);
      List<double> l = List.filled(m - 1, 0.0);
      List<double> u = List.filled(m - 1, 0.0);
      List<double> z = List.filled(m - 1, 0.0);

      for (int j = 1; j <= m - 1; j++) {
        double x = j * h;
        w[j - 1] = _evaluarFuncionX(function, x);
      }
      l[0] = 1.0 + 2.0 * lambda;
      u[0] = -lambda / l[0];
      
      for (int i = 2; i <= m - 2; i++) {
        l[i - 1] = 1.0 + 2.0 * lambda + lambda * u[i - 2];
        u[i - 1] = -lambda / l[i - 1];
      }
      
      l[m - 2] = 1.0 + 2.0 * lambda + lambda * u[m - 3];
      int paso = max(1, n ~/ numTiempos);
      
      for (int j = 1; j <= n; j++) {
        z[0] = w[0] / l[0];
        
        for (int i = 2; i <= m - 1; i++) {
          z[i - 1] = (w[i - 1] + lambda * z[i - 2]) / l[i - 1];
        }
        
        w[m - 2] = z[m - 2];
        
        for (int i = 1; i <= m - 2; i++) {
          int index = m - 2 - i;
          w[index] = z[index] - u[index] * w[index + 1];
        }
        if (j % paso == 0 || j == n) {
          double tiempo = j * k;
          List<double> solucion = List.from(w);
          evolucion.add({
            'tiempo': MethodUtils.redondear(tiempo, dn),
            'solucion': solucion.map((val) => MethodUtils.redondear(val, dn)).toList()
          });
        }
      }
      
    } catch (e) {
    }
    
    return evolucion;
  }
  Map<String, dynamic> verificarEstabilidad() {
    Map<String, dynamic> estabilidad = {};
    
    try {
      double h = upperLimit / m;
      double k = maxTime / n;
      double lambda = alpha * alpha * k / (h * h);
      
      estabilidad['lambda'] = MethodUtils.redondear(lambda, dn);
      estabilidad['estabilidad'] = 'Incondicionalmente estable';
      estabilidad['razon'] = 'El método de diferencias regresivas es estable para cualquier valor de v';
      if (lambda > 10) {
        estabilidad['recomendacion'] = 'v > 10: considerar reducir el paso temporal para mejor precisión';
      } else if (lambda < 0.1) {
        estabilidad['recomendacion'] = 'v < 0.1: considerar aumentar el paso temporal para eficiencia';
      } else {
        estabilidad['recomendacion'] = 'v en rango óptimo para precisión y eficiencia';
      }
      
    } catch (e) {
      estabilidad['error'] = e.toString();
    }
    
    return estabilidad;
  }

    String getMethodDescription() {
    return '''
Propósito: Resolver ecuaciones diferenciales parciales parabólicas que modelan fenómenos de evolución temporal como la difusión de calor, utilizando discretización en espacio y tiempo.

Fundamento: Discretiza el dominio espacial-temporal mediante mallas, aproximando derivadas espaciales con diferencias finitas y derivadas temporales con esquemas de integración (Euler, Crank-Nicolson).

Características:

  Separa discretización espacial (diferencias finitas) y temporal (métodos de paso).

  Esquemas explícitos (condicionalmente estables) o implícitos (incondicionalmente estables).

  Genera sistemas algebraicos que acoplan valores nodales en cada paso de tiempo.

  Requiere condiciones iniciales y de frontera bien definidas.

Ventajas:

  Eficiente para problemas de evolución temporal.

  Esquemas implícitos evitan restricciones severas de paso temporal.

  Captura adecuadamente el comportamiento difusivo/amortiguado.

  Fácil extensión a problemas multidimensionales.
''';
  }
}