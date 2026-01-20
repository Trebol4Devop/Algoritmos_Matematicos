import 'dart:math';
import 'MethodClass.Dart';
import 'MethodUtils.Dart';
import 'MathParser.Dart';
import 'EulerClass.Dart';

class RungeKuttaFourthOrderClass extends MethodClass {
  String function;
  double lowerLimit;
  double upperLimit;
  int n;
  double alpha;
  int dn;
  List<List<double>> resultTable;
  MathParser parser;

  RungeKuttaFourthOrderClass({
    this.function = "",
    this.lowerLimit = 0.0,
    this.upperLimit = 0.0,
    this.n = 0,
    this.alpha = 0.0,
    this.dn = 0,
    List<List<double>>? resultTable,
    int id = 14,
    String title = "Runge-Kutta Cuarto Orden",
    String subtitle = "Resolución de ecuaciones diferenciales ordinarias",
    String index = "RK4",
  }) : parser = MathParser(), resultTable = resultTable ?? [] {
    this.id = id;
    this.title = title;
    this.subtitle = subtitle;
    this.index = index;
  }

  @override
  void initialize() {
    super.initialize();
    resultTable = [];
  }
  String? validarParametros() {
    if (function.isEmpty) {
      return "Error: debe proporcionar la función f(t, y)";
    }
    
    if (lowerLimit >= upperLimit) {
      return "Error: el límite inferior debe ser menor que el límite superior";
    }
    
    if (n <= 0) {
      return "Error: el número de subintervalos debe ser mayor que 0";
    }
    
    if (dn < 0) {
      return "Error: el número de decimales debe ser no negativo";
    }
    try {
      if (!parser.validarFuncionEuler(function)) {
        return "Error: la función f(t, y) no es válida";
      }
    } catch (e) {
      return "Error al validar la función: ${e.toString()}";
    }
    try {
      double test = parser.evaluarFuncionTY(function, lowerLimit, alpha);
      if (test.isNaN || test.isInfinite) {
        return "Error: la función produce valores no válidos en el punto inicial";
      }
    } catch (e) {
      return "Error: no se puede evaluar la función en el punto inicial: ${e.toString()}";
    }
    
    return null;
  }
  void rungeKuttaFourthOrderMethod() {
    initialize();
    
    try {
      String? error = validarParametros();
      if (error != null) {
        message = error;
        return;
      }
      
      double a = lowerLimit;
      double b = upperLimit;
      double h = (b - a) / n;
      double t = a;
      double y = alpha;
      resultTable = [];
      List<double> filaInicial = [
        0.0,
        MethodUtils.redondear(t, dn),
        MethodUtils.redondear(y, dn)
      ];
      resultTable.add(filaInicial);
      for (int i = 1; i <= n; i++) {
        double k1 = h * parser.evaluarFuncionTY(function, t, y);
        double k2 = h * parser.evaluarFuncionTY(function, t + h/2, y + k1/2);
        double k3 = h * parser.evaluarFuncionTY(function, t + h/2, y + k2/2);
        double k4 = h * parser.evaluarFuncionTY(function, t + h, y + k3);
        y = y + (k1 + 2*k2 + 2*k3 + k4)/6;
        t = a + i * h;
        List<double> filaResultado = [
          i.toDouble(),
          MethodUtils.redondear(t, dn),
          MethodUtils.redondear(y, dn),
          MethodUtils.redondear(k1, dn),
          MethodUtils.redondear(k2, dn),
          MethodUtils.redondear(k3, dn),
          MethodUtils.redondear(k4, dn)
        ];
        
        resultTable.add(filaResultado);
      }
      success = true;
      iterations = n;
      result = y;
      message = "Solución aproximada obtenida con éxito\n"
                "y(${MethodUtils.redondear(t, dn)}) = ${MethodUtils.redondear(y, dn)}\n"
                "Número de iteraciones: $n\n"
                "Tamaño de paso h = ${MethodUtils.redondear(h, dn)}";
      
    } catch (e) {
      message = "Error durante la ejecución del método de Runge-Kutta: ${e.toString()}";
      success = false;
    }
  }
  List<List<String>> obtenerTablaResultados() {
    List<List<String>> tabla = [];
    
    if (resultTable.isEmpty) return tabla;
    List<String> encabezados = ["i", "ti", "y(ti)", "k1", "k2", "k3", "k4"];
    tabla.add(encabezados);
    for (int i = 0; i < resultTable.length; i++) {
      List<String> fila = [];
      for (int j = 0; j < resultTable[i].length; j++) {
        fila.add(MethodUtils.redondear(resultTable[i][j], dn).toString());
      }
      tabla.add(fila);
    }
    
    return tabla;
  }
  List<List<String>> obtenerTablaResultadosSimplificada() {
    List<List<String>> tabla = [];
    
    if (resultTable.isEmpty) return tabla;
    List<String> encabezados = ["i", "ti", "y(ti)"];
    tabla.add(encabezados);
    for (int i = 0; i < resultTable.length; i++) {
      List<String> fila = [
        MethodUtils.redondear(resultTable[i][0], dn).toString(),
        MethodUtils.redondear(resultTable[i][1], dn).toString(),
        MethodUtils.redondear(resultTable[i][2], dn).toString()
      ];
      tabla.add(fila);
    }
    
    return tabla;
  }
  String obtenerSolucion() {
    if (resultTable.isEmpty) return "No hay solución calculada";
    
    List<double> ultimaFila = resultTable.last;
    double tFinal = ultimaFila[1];
    double yFinal = ultimaFila[2];
    
    return "y(${MethodUtils.redondear(tFinal, dn)}) = ${MethodUtils.redondear(yFinal, dn)}";
  }
  double calcularError(String solucionExacta) {
    if (resultTable.isEmpty) return double.nan;
    
    try {
      List<double> ultimaFila = resultTable.last;
      double tFinal = ultimaFila[1];
      double yAproximado = ultimaFila[2];
      double yExacto = parser.evaluar(solucionExacta, "t", tFinal);
      
      return (yAproximado - yExacto).abs();
    } catch (e) {
      return double.nan;
    }
  }
  double calcularErrorRelativo(String solucionExacta) {
    if (resultTable.isEmpty) return double.nan;
    
    try {
      List<double> ultimaFila = resultTable.last;
      double tFinal = ultimaFila[1];
      double yAproximado = ultimaFila[2];
      double yExacto = parser.evaluar(solucionExacta, "t", tFinal);
      
      if (yExacto == 0) return double.infinity;
      return ((yAproximado - yExacto).abs() / yExacto.abs()) * 100;
    } catch (e) {
      return double.nan;
    }
  }
  List<Map<String, double>> obtenerPuntosSolucion() {
    List<Map<String, double>> puntos = [];
    
    for (int i = 0; i < resultTable.length; i++) {
      puntos.add({
        'x': resultTable[i][1],
        'y': resultTable[i][2],
        'iteracion': resultTable[i][0]
      });
    }
    
    return puntos;
  }
  List<Map<String, double>> obtenerPuntosSolucionExacta(String solucionExacta, {int numPuntos = 100}) {
    List<Map<String, double>> puntos = [];
    
    double paso = (upperLimit - lowerLimit) / numPuntos;
    
    for (int i = 0; i <= numPuntos; i++) {
      double t = lowerLimit + i * paso;
      try {
        double y = parser.evaluar(solucionExacta, "t", t);
        if (!y.isNaN && !y.isInfinite) {
          puntos.add({
            'x': t,
            'y': y,
            'tipo': 1.0
          });
        }
      } catch (e) {
      }
    }
    
    return puntos;
  }
  List<Map<String, double>> obtenerCampoDirecciones({int numPuntos = 20}) {
    List<Map<String, double>> campo = [];
    double minY = alpha;
    double maxY = alpha;
    for (var fila in resultTable) {
      minY = min(minY, fila[2]);
      maxY = max(maxY, fila[2]);
    }
    minY -= 1.0;
    maxY += 1.0;
    
    double pasoT = (upperLimit - lowerLimit) / numPuntos;
    double pasoY = (maxY - minY) / numPuntos;
    
    for (int i = 0; i <= numPuntos; i++) {
      double t = lowerLimit + i * pasoT;
      for (int j = 0; j <= numPuntos; j++) {
        double y = minY + j * pasoY;
        try {
          double pendiente = parser.evaluarFuncionTY(function, t, y);
          if (!pendiente.isNaN && !pendiente.isInfinite) {
            campo.add({
              'x': t,
              'y': y,
              'pendiente': pendiente,
              'dx': 0.1,
              'dy': 0.1 * pendiente
            });
          }
        } catch (e) {
        }
      }
    }
    
    return campo;
  }
  Map<String, double> obtenerConstantesRK(int iteracion) {
    if (resultTable.isEmpty || iteracion < 0 || iteracion >= resultTable.length) {
      return {};
    }
    
    List<double> fila = resultTable[iteracion];
    return {
      'k1': fila.length > 3 ? fila[3] : 0.0,
      'k2': fila.length > 4 ? fila[4] : 0.0,
      'k3': fila.length > 5 ? fila[5] : 0.0,
      'k4': fila.length > 6 ? fila[6] : 0.0,
    };
  }

  Map<String, dynamic> analizarMetodo() {
    Map<String, dynamic> analisis = {};
    
    try {
      double h = (upperLimit - lowerLimit) / n;
      
      analisis['tamaño_paso'] = MethodUtils.redondear(h, dn);
      analisis['numero_pasos'] = n;
      analisis['punto_inicial'] = '(${MethodUtils.redondear(lowerLimit, dn)}, ${MethodUtils.redondear(alpha, dn)})';
      analisis['punto_final'] = resultTable.isNotEmpty ? 
          '(${MethodUtils.redondear(resultTable.last[1], dn)}, ${MethodUtils.redondear(resultTable.last[2], dn)})' : 
          'No calculado';

      analisis['error_truncamiento_local'] = 'O(h5)';
      analisis['error_global'] = 'O(h4)';
      analisis['orden_metodo'] = 4;
      if (h > 0.5) {
        analisis['advertencia'] = 'El tamaño de paso h podría ser muy grande para buena precisión';
        analisis['recomendacion'] = 'Considere aumentar el número de subintervalos N';
      } else {
        analisis['advertencia'] = 'Ninguna';
        analisis['recomendacion'] = 'El tamaño de paso parece adecuado';
      }
      analisis['funcion'] = function;
      analisis['tipo_ecuacion'] = 'Primer orden: y\' = f(t, y)';
      analisis['ventajas'] = [
        'Mayor precisión que métodos de orden inferior',
        'Estabilidad numérica mejorada',
        'Ampliamente utilizado en aplicaciones prácticas'
      ];
      
      analisis['aplicaciones'] = [
        'Problemas de mecánica celeste',
        'Simulaciones de dinámica de fluidos',
        'Circuitos eléctricos',
        'Sistemas biológicos'
      ];
      
    } catch (e) {
      analisis['error'] = 'Error en análisis del método: ${e.toString()}';
    }
    
    return analisis;
  }

  Map<String, dynamic> compararConEuler(EulerClass euler) {
    Map<String, dynamic> comparacion = {};
    
    try {
      if (!success || !euler.success) {
        comparacion['error'] = 'Ambos métodos deben ejecutarse exitosamente para comparar';
        return comparacion;
      }
      
      double solucionRK = result;
      double solucionEuler = euler.result;
      
      comparacion['solucion_rk4'] = MethodUtils.redondear(solucionRK, dn);
      comparacion['solucion_euler'] = MethodUtils.redondear(solucionEuler, dn);
      comparacion['diferencia'] = MethodUtils.redondear((solucionRK - solucionEuler).abs(), dn);

      if (solucionEuler != 0) {
        double mejoraRelativa = ((solucionRK - solucionEuler).abs() / solucionEuler.abs()) * 100;
        comparacion['mejora_relativa'] = '${MethodUtils.redondear(mejoraRelativa, 2)}%';
      }
      
      comparacion['iteraciones'] = iterations;
      comparacion['tamaño_paso'] = MethodUtils.redondear((upperLimit - lowerLimit) / n, dn);
      
    } catch (e) {
      comparacion['error'] = 'Error en comparación: ${e.toString()}';
    }
    
    return comparacion;
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json.addAll({
      'function': function,
      'lowerLimit': lowerLimit,
      'upperLimit': upperLimit,
      'n': n,
      'alpha': alpha,
      'dn': dn,
      'resultTable': resultTable,
    });
    return json;
  }

  @override
  String getResultSummary() {
    String summary = '${super.getResultSummary()}\n'
                    'Función: y\' = $function\n'
                    'Intervalo: [${MethodUtils.redondear(lowerLimit, dn)}, ${MethodUtils.redondear(upperLimit, dn)}]\n'
                    'Subintervalos: $n\n'
                    'Condición inicial: y(${MethodUtils.redondear(lowerLimit, dn)}) = ${MethodUtils.redondear(alpha, dn)}';
    
    if (success && resultTable.isNotEmpty) {
      List<double> ultimaFila = resultTable.last;
      summary += '\nSolución aproximada: y(${MethodUtils.redondear(ultimaFila[1], dn)}) = ${MethodUtils.redondear(ultimaFila[2], dn)}';
      
      var constantes = obtenerConstantesRK(resultTable.length - 1);
      if (constantes.isNotEmpty) {
        summary += '\nConstantes RK finales: ';
        summary += 'k1=${MethodUtils.redondear(constantes['k1']!, dn)}, ';
        summary += 'k2=${MethodUtils.redondear(constantes['k2']!, dn)}, ';
        summary += 'k3=${MethodUtils.redondear(constantes['k3']!, dn)}, ';
        summary += 'k4=${MethodUtils.redondear(constantes['k4']!, dn)}';
      }
    }
    
    return summary;
  }
  
  String getMethodDescription() {
    return '''
Propósito: Resolver numéricamente ecuaciones diferenciales ordinarias con alta precisión, aproximando soluciones en puntos discretos sin requerir derivadas de orden superior.

Fundamento: Combina múltiples evaluaciones de la función en subintervalos dentro de cada paso, promediando pendientes de forma ponderada para minimizar el error de truncamiento.

Características:

  Utiliza cuatro evaluaciones de la función por paso.

  No necesita derivadas explícitas de la función.

  Autónomo (no requiere información de pasos anteriores).

  Error local del orden de h^5 global de h^4.

Ventajas:

    Mayor precisión que métodos de orden inferior.

    Estabilidad moderada en problemas no rígidos.

    Equilibrio entre eficiencia computacional y exactitud.

    Ampliamente implementado en software científico.
''';
  }
}