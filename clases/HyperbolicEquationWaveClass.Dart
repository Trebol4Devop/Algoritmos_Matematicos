import 'dart:math';
import 'MathParser.Dart';
import 'MethodClass.Dart';
import 'MethodUtils.Dart';

/// Implementación del método de diferencias finitas para la ecuación de onda hiperbólica
class HyperbolicEquationWaveClass extends MethodClass {
  String function1;
  String function2;
  double upperLimitx;
  double maxTime;
  int n;
  int m;
  int dn;
  double alpha;
  List<List<dynamic>> resultTable;
  
  HyperbolicEquationWaveClass({
    this.function1 = "",
    this.function2 = "",
    this.upperLimitx = 0.0,
    this.maxTime = 0.0,
    this.n = 0,
    this.m = 0,
    this.dn = 6,
    this.alpha = 0.0,
    List<List<dynamic>>? resultTable,
    int id = 1,
    String title = "Método de Diferencias Finitas para la Ecuación de Onda",
    String subtitle = "Resuelve ecuaciones hiperbólicas usando método explícito",
    String index = "WAVE_EQ",
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

  void hyperbolicEquationWaveMethod() {
    initialize();
    resultTable.clear();

    try {
      if (function1.isEmpty || function2.isEmpty) {
        message = "Error: debe proporcionar ambas funciones f(x) y g(x)";
        return;
      }

      if (upperLimitx <= 0) {
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
      List<double> puntosPrueba = [0.0, upperLimitx/2, upperLimitx];
      if (!MethodUtils.validarFuncionX(function1, puntosPrueba) ||
          !MethodUtils.validarFuncionX(function2, puntosPrueba)) {
        message = "Error: alguna función produce valores no válidos en el dominio";
        return;
      }
      double h = upperLimitx / m;
      double k = maxTime / n;
      double v = alpha * k / h;
      if (v > 1.0) {
        message = "Advertencia: v = $v > 1. El método puede ser inestable.\n"
                  "Considere reducir el paso temporal k o aumentar el paso espacial h.";
      }
      List<List<double>> w = List.generate(m + 1, (_) => List.filled(n + 1, 0.0));

      for (int j = 1; j <= n; j++) {
        w[0][j] = 0.0;
        w[m][j] = 0.0;
      }
      w[0][0] = _evaluarFuncionX(function1, 0.0);
      w[m][0] = _evaluarFuncionX(function1, upperLimitx);

      for (int i = 1; i <= m - 1; i++) {
        double x = i * h;
        w[i][0] = _evaluarFuncionX(function1, x);
      }
      for (int i = 1; i <= m - 1; i++) {
        double x = i * h;
        w[i][1] = (1.0 - v * v) * _evaluarFuncionX(function1, x) +
                  (v * v / 2.0) * (_evaluarFuncionX(function1, (i + 1) * h) + 
                                   _evaluarFuncionX(function1, (i - 1) * h)) +
                  k * _evaluarFuncionX(function2, x);
      }
      for (int j = 2; j <= n; j++) {
        for (int i = 1; i <= m - 1; i++) {
          w[i][j] = 2.0 * (1.0 - v * v) * w[i][j - 1] +
                     v * v * (w[i + 1][j - 1] + w[i - 1][j - 1]) -
                     w[i][j - 2];
        }
      }
      for (int i = 0; i <= m; i++) {
        double x = i * h;
        resultTable.add([
          (i + 1).toString(),
          MethodUtils.redondear(x, dn),
          MethodUtils.redondear(w[i][n], dn)
        ]);
      }

      success = true;
      iterations = n;
      result = MethodUtils.redondear(w[m ~/ 2][n], dn);
      message = "Solución completada exitosamente\n"
                "Tiempo final: t = ${MethodUtils.redondear(maxTime, dn)}\n"
                "Paso espacial h = ${MethodUtils.redondear(h, dn)}\n"
                "Paso temporal k = ${MethodUtils.redondear(k, dn)}\n"
                "Parámetro v = ${MethodUtils.redondear(v, dn)}\n"
                "${v > 1.0 ? 'ADVERTENCIA: v > 1 - El método puede ser inestable' : 'Condición CFL: v ≤ 1 - Método estable'}";

    } catch (e) {
      message = "Error durante la ejecución: ${e.toString()}";
      success = false;
    }
  }
  double _evaluarFuncionX(String funcion, double x) {
    return MethodUtils.evaluarFuncionX(funcion, x);
  }
  Map<String, dynamic> analizarEcuacionOnda() {
    Map<String, dynamic> analisis = {};
    
    try {
      double h = upperLimitx / m;
      double k = maxTime / n;
      double v = alpha * k / h;
      
      analisis['paso_espacial_h'] = MethodUtils.redondear(h, dn);
      analisis['paso_temporal_k'] = MethodUtils.redondear(k, dn);
      analisis['parametro_v'] = MethodUtils.redondear(v, dn);
      analisis['rango_espacial'] = '[0, ${MethodUtils.redondear(upperLimitx, dn)}]';
      analisis['tiempo_final'] = MethodUtils.redondear(maxTime, dn);
      analisis['divisiones_espaciales'] = m;
      analisis['divisiones_temporales'] = n;
      analisis['coeficiente_alpha'] = alpha;
      analisis['condicion_CFL'] = v <= 1.0 ? 'Satisfecha (estable)' : 'No satisfecha (potencialmente inestable)';
      analisis['condicion_frontera_1'] = 'u(0,t) = 0';
      analisis['condicion_frontera_2'] = 'u($upperLimitx,t) = 0';
      analisis['condicion_inicial_desplazamiento'] = 'u(x,0) = $function1';
      analisis['condicion_inicial_velocidad'] = 'du/dt(x,0) = $function2';
      analisis['metodo'] = 'Diferencias Finitas Explícitas';
      analisis['estabilidad'] = v <= 1.0 ? 'Estable' : 'Potencialmente inestable';
      analisis['precision'] = 'O(k2 + h2)';
      double x1 = upperLimitx / 4;
      double x2 = upperLimitx / 2;
      double x3 = 3 * upperLimitx / 4;
      
      analisis['f(x1)'] = MethodUtils.redondear(_evaluarFuncionX(function1, x1), dn);
      analisis['f(x2)'] = MethodUtils.redondear(_evaluarFuncionX(function1, x2), dn);
      analisis['f(x3)'] = MethodUtils.redondear(_evaluarFuncionX(function1, x3), dn);
      analisis['g(x1)'] = MethodUtils.redondear(_evaluarFuncionX(function2, x1), dn);
      analisis['g(x2)'] = MethodUtils.redondear(_evaluarFuncionX(function2, x2), dn);
      analisis['g(x3)'] = MethodUtils.redondear(_evaluarFuncionX(function2, x3), dn);
      analisis['puntos_espaciales'] = m + 1;
      analisis['puntos_temporales'] = n + 1;
      analisis['tamaño_sistema'] = '${m + 1} puntos espaciales × ${n + 1} puntos temporales';
      
    } catch (e) {
      analisis['error'] = e.toString();
    }
    
    return analisis;
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json.addAll({
      'function1': function1,
      'function2': function2,
      'upperLimitx': upperLimitx,
      'maxTime': maxTime,
      'n': n,
      'm': m,
      'dn': dn,
      'alpha': alpha,
      'resultTable': resultTable,
    });
    return json;
  }

  @override
  String getResultSummary() {
    if (resultTable.isEmpty) return super.getResultSummary();
    
    double h = upperLimitx / m;
    double k = maxTime / n;
    double v = alpha * k / h;
    
    return '${super.getResultSummary()}\n'
           'Ecuación: d2u/dt2 = A2 d2u/dx2\n'
           'Condición inicial desplazamiento: u(x,0) = $function1\n'
           'Condición inicial velocidad: du/dt(x,0) = $function2\n'
           'Condiciones frontera: u(0,t) = 0, u($upperLimitx,t) = 0\n'
           'Parámetros: A = $alpha, l = $upperLimitx, T = $maxTime\n'
           'Mallado: $m divisiones espaciales, $n divisiones temporales\n'
           'Parámetro v = ${MethodUtils.redondear(v, dn)} ${v > 1.0 ? '(ADVERTENCIA: > 1)' : '(estable)'}';
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
      double h = upperLimitx / m;
      double k = maxTime / n;
      double v = alpha * k / h;
      List<List<double>> w = List.generate(m + 1, (_) => List.filled(n + 1, 0.0));

      for (int j = 1; j <= n; j++) {
        w[0][j] = 0.0;
        w[m][j] = 0.0;
      }

      w[0][0] = _evaluarFuncionX(function1, 0.0);
      w[m][0] = _evaluarFuncionX(function1, upperLimitx);

      for (int i = 1; i <= m - 1; i++) {
        double x = i * h;
        w[i][0] = _evaluarFuncionX(function1, x);
      }

      for (int i = 1; i <= m - 1; i++) {
        double x = i * h;
        w[i][1] = (1.0 - v * v) * _evaluarFuncionX(function1, x) +
                  (v * v / 2.0) * (_evaluarFuncionX(function1, (i + 1) * h) + 
                                   _evaluarFuncionX(function1, (i - 1) * h)) +
                  k * _evaluarFuncionX(function2, x);
      }
      int paso = max(1, n ~/ numTiempos);
      
      for (int j = 2; j <= n; j++) {
        for (int i = 1; i <= m - 1; i++) {
          w[i][j] = 2.0 * (1.0 - v * v) * w[i][j - 1] +
                     v * v * (w[i + 1][j - 1] + w[i - 1][j - 1]) -
                     w[i][j - 2];
        }
        if (j % paso == 0 || j == n) {
          double tiempo = j * k;
          List<double> solucion = [];
          for (int i = 0; i <= m; i++) {
            solucion.add(w[i][j]);
          }
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
  Map<String, dynamic> verificarEstabilidadCFL() {
    Map<String, dynamic> estabilidad = {};
    
    try {
      double h = upperLimitx / m;
      double k = maxTime / n;
      double v = alpha * k / h;
      
      estabilidad['parametro_v'] = MethodUtils.redondear(v, dn);
      estabilidad['condicion_CFL'] = 'v ≤ 1';
      estabilidad['cumple_CFL'] = v <= 1.0;
      
      if (v <= 1.0) {
        estabilidad['estabilidad'] = 'Estable';
        estabilidad['recomendacion'] = 'El método es estable según la condición CFL';
      } else {
        estabilidad['estabilidad'] = 'Potencialmente inestable';
        estabilidad['recomendacion'] = 'Reduzca el paso temporal k o aumente el paso espacial h';
        estabilidad['k_maximo_recomendado'] = MethodUtils.redondear(h / alpha, dn);
        estabilidad['h_minimo_recomendado'] = MethodUtils.redondear(alpha * k, dn);
      }
      
    } catch (e) {
      estabilidad['error'] = e.toString();
    }
    
    return estabilidad;
  }
  double calcularEnergia() {
    try {
      double h = upperLimitx / m;
      double energia = 0.0;
      for (int i = 0; i <= m; i++) {
        double peso = (i == 0 || i == m) ? 0.5 : 1.0;
        double u = (resultTable[i][2] as double);
        energia += peso * u * u;
      }
      
      energia *= h;
      return MethodUtils.redondear(energia, dn);
    } catch (e) {
      return 0.0;
    }
  }

  String getMethodDescription() {
    return '''
Propósito: Resolver ecuaciones de onda y fenómenos de propagación hiperbólicos que presentan dependencia temporal y espacial, conservando características ondulatorias como frentes y dominios de dependencia.

Fundamento: Discretiza el dominio espacial-temporal con mallas, aplicando diferencias finitas centradas para aproximar las derivadas segundas en espacio y tiempo.

Características:

  Usa discretización con diferencias centradas de segundo orden en espacio y tiempo.

  Esquema explícito que requiere cumplir condición de estabilidad.

  Conserva energía y dominios de dependencia característicos de ecuaciones hiperbólicas.

  Necesita condiciones iniciales de desplazamiento y velocidad, además de condiciones de frontera.

Ventajas:

    Simplicidad computacional en esquemas explícitos.

    Captura precisa la propagación de frentes de onda sin disipación artificial.

    Fácil implementación para problemas en 1D, 2D y 3D.

    Refleja correctamente la velocidad finita de propagación.
''';
  }
}