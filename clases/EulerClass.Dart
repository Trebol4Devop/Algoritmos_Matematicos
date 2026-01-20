import 'dart:math';
import 'MethodClass.Dart';
import 'MethodUtils.Dart';
import 'MathParser.Dart';

/// Implementación del método de Euler para resolver ecuaciones diferenciales ordinarias
class EulerClass extends MethodClass {
  String function;
  double lowerLimit;
  double upperLimit;
  int n;
  double alpha;
  int dn;
  List<List<double>> resultTable;
  MathParser parser;

  EulerClass({
    this.function = "",
    this.lowerLimit = 0.0,
    this.upperLimit = 0.0,
    this.n = 0,
    this.alpha = 0.0,
    this.dn = 0,
    List<List<double>>? resultTable,
    int id = 13,
    String title = "Método de Euler",
    String subtitle = "Resolución de ecuaciones diferenciales ordinarias",
    String index = "EULER",
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

  void eulerMethod() {
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
        double fty = parser.evaluarFuncionTY(function, t, y);
        
        y = y + h * fty;
        t = a + i * h;
        
        List<double> filaResultado = [
          i.toDouble(),
          MethodUtils.redondear(t, dn),
          MethodUtils.redondear(y, dn)
        ];
        
        resultTable.add(filaResultado);
      }
      
      success = true;
      iterations = n;
      result = y;
      message = "y(${MethodUtils.redondear(t, dn)}) = ${MethodUtils.redondear(y, dn)}\n"
                "Tamaño de paso h = ${MethodUtils.redondear(h, dn)}";
      
    } catch (e) {
      message = "Error durante la ejecución del método de Euler: ${e.toString()}";
      success = false;
    }
  }

  List<List<String>> obtenerTablaResultados() {
    List<List<String>> tabla = [];
    
    if (resultTable.isEmpty) return tabla;

    List<String> encabezados = ["i", "ti", "y(ti)"];
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

      analisis['error_truncamiento_local'] = 'O(h2)';
      analisis['error_global'] = 'O(h)';
      
      if (h > 0.1) {
        analisis['advertencia'] = 'El tamaño de paso h podría ser muy grande para buena precisión';
        analisis['recomendacion'] = 'Considere aumentar el número de subintervalos N';
      } else {
        analisis['advertencia'] = 'Ninguna';
        analisis['recomendacion'] = 'El tamaño de paso parece adecuado';
      }

      analisis['funcion'] = function;
      analisis['tipo_ecuacion'] = 'Primer orden: y\' = f(t, y)';
      
    } catch (e) {
      analisis['error'] = 'Error en análisis del método: ${e.toString()}';
    }
    
    return analisis;
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
    }
    
    return summary;
  }

  String getMethodDescription() {
    return '''
Propósito: Resolver ecuaciones diferenciales ordinarias con mayor precisión que el método de Euler.

Fundamento: Utiliza un promedio ponderado de cuatro pendientes calculadas en diferentes puntos del intervalo, logrando una aproximación de cuarto orden.

Características:

    Precisión: Error de truncamiento local O(h^5), global O(h^4)

    No requiere cálculo de derivadas superiores

    Balance ideal entre precisión y costo computacional

    Método más utilizado en aplicaciones prácticas

Ventaja: Proporciona alta precisión con pasos moderados, siendo eficiente para la mayoría de problemas de EDOs.
''';
  }
}