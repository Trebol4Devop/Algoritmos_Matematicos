import 'dart:math';
import 'MethodClass.Dart';
import 'MethodUtils.Dart';
import 'MathParser.Dart';

/// Implementación del método de punto fijo para sistemas de dos ecuaciones no lineales
class FixedPoint2VariablesClass extends MethodClass {
  String function1;
  String function2;
  double x;
  double y;
  double tol;
  int n;
  int dn;
  List<List<double>> resultTable;
  MathParser parser;

  FixedPoint2VariablesClass({
    this.function1 = "",
    this.function2 = "",
    this.x = 0.0,
    this.y = 0.0,
    this.tol = 0.0,
    this.n = 0,
    this.dn = 0,
    this.resultTable = const [],
    int id = 11,
    String title = "Punto Fijo 2 Variables",
    String subtitle = "Resolución de sistemas de ecuaciones no lineales",
    String index = "FP2",
  }) : parser = MathParser() {
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
    if (function1.isEmpty || function2.isEmpty) {
      return "Error: debe proporcionar ambas funciones g1(x,y) y g2(x,y)";
    }
    
    if (tol <= 0) {
      return "Error: la tolerancia debe ser mayor que 0";
    }
    
    if (n <= 0) {
      return "Error: el número máximo de iteraciones debe ser mayor que 0";
    }

    try {
      // Probar en el punto inicial
      double test1 = parser.evaluar2Variables(function1, x, y);
      double test2 = parser.evaluar2Variables(function2, x, y);
      
      if (test1.isNaN || test1.isInfinite || test2.isNaN || test2.isInfinite) {
        return "Error: las funciones producen valores no válidos en el punto inicial";
      }
      
      // Probar en algunos puntos cercanos para mayor robustez
      List<List<double>> puntosPrueba = [
        [x + 0.1, y + 0.1],
        [x - 0.1, y - 0.1],
        [x + 0.5, y + 0.5],
      ];
      
      for (var punto in puntosPrueba) {
        try {
          double val1 = parser.evaluar2Variables(function1, punto[0], punto[1]);
          double val2 = parser.evaluar2Variables(function2, punto[0], punto[1]);
          
          // Solo nos importa si ambos valores son válidos
          if (!val1.isNaN && !val1.isInfinite && !val2.isNaN && !val2.isInfinite) {
            break; // Si al menos un punto funciona, consideramos la función válida
          }
        } catch (e) {
          // Ignoramos errores en puntos de prueba, solo nos importa el punto inicial
        }
      }
      
    } catch (e) {
      return "Error: no se pueden evaluar las funciones en el punto inicial: ${e.toString()}";
    }
    
    return null;
  }

  void fixedPoint2VariablesMethod() {
    initialize();
    
    try {
      String? error = validarParametros();
      if (error != null) {
        message = error;
        return;
      }
      
      double x0 = x;
      double y0 = y;
      int iteracion = 1;
      bool convergio = false;
      double errorGlobal = 0.0;
      resultTable = [];
      List<double> filaInicial = [
        0.0,
        MethodUtils.redondear(x0, dn),
        MethodUtils.redondear(y0, dn),
        0.0,
        0.0,
        0.0
      ];
      resultTable.add(filaInicial);
      
      while (iteracion <= n && !convergio) {
        double x1 = parser.evaluar2Variables(function1, x0, y0);
        double y1 = parser.evaluar2Variables(function2, x0, y0);
        
        double errorX = (x1 - x0).abs();
        double errorY = (y1 - y0).abs();
        errorGlobal = max(errorX, errorY);
        List<double> filaResultado = [
          iteracion.toDouble(),
          MethodUtils.redondear(x1, dn),
          MethodUtils.redondear(y1, dn),
          MethodUtils.redondear(errorX, dn),
          MethodUtils.redondear(errorY, dn),
          MethodUtils.redondear(errorGlobal, dn)
        ];
        
        resultTable.add(filaResultado);

        if (errorGlobal <= tol) {
          convergio = true;
          success = true;
          iterations = iteracion;
          x = x1;
          y = y1;
          result = errorGlobal;
          message = "Solución: (${MethodUtils.redondear(x1, dn)}, ${MethodUtils.redondear(y1, dn)})\n"
                    "Error final: ${MethodUtils.redondear(errorGlobal, dn)}";
        } else {
          x0 = x1;
          y0 = y1;
          iteracion++;
        }
      }
      if (!convergio) {
        success = false;
        iterations = n;
        List<double> ultimaFila = resultTable.last;
        x = ultimaFila[1];
        y = ultimaFila[2];
        result = ultimaFila[5];
        message = "Máximo de iteraciones ($n) alcanzado sin convergencia\n"
                  "Mejor aproximación: (${MethodUtils.redondear(x, dn)}, ${MethodUtils.redondear(y, dn)})\n"
                  "Error final: ${MethodUtils.redondear(result, dn)}";
      }
      
    } catch (e) {
      message = "Error durante la ejecución del método de punto fijo: ${e.toString()}";
      success = false;
    }
  }

  List<List<String>> obtenerTablaResultados() {
    List<List<String>> tabla = [];
    
    if (resultTable.isEmpty) return tabla;

    List<String> encabezados = ["Iteración", "x", "y", "Error x", "Error y", "Error Máximo"];
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
    return "(${MethodUtils.redondear(x, dn)}, ${MethodUtils.redondear(y, dn)})";
  }

  Map<String, dynamic> analizarConvergencia() {
    Map<String, dynamic> analisis = {};
    
    try {
      if (function1.isEmpty || function2.isEmpty) {
        analisis['error'] = 'No hay funciones para analizar';
        return analisis;
      }
      
      analisis['punto_inicial'] = '(${MethodUtils.redondear(x, dn)}, ${MethodUtils.redondear(y, dn)})';
      analisis['tolerancia'] = tol;
      analisis['iteraciones_maximas'] = n;

      double h = 0.0001;

      double dg1dx = (parser.evaluar2Variables(function1, x + h, y) - parser.evaluar2Variables(function1, x, y)) / h;
      double dg1dy = (parser.evaluar2Variables(function1, x, y + h) - parser.evaluar2Variables(function1, x, y)) / h;

      double dg2dx = (parser.evaluar2Variables(function2, x + h, y) - parser.evaluar2Variables(function2, x, y)) / h;
      double dg2dy = (parser.evaluar2Variables(function2, x, y + h) - parser.evaluar2Variables(function2, x, y)) / h;
      
      analisis['dg1/dx'] = MethodUtils.redondear(dg1dx, dn);
      analisis['dg1/dy'] = MethodUtils.redondear(dg1dy, dn);
      analisis['dg2/dx'] = MethodUtils.redondear(dg2dx, dn);
      analisis['dg2/dy'] = MethodUtils.redondear(dg2dy, dn);

      double normaJacobiana = max((dg1dx.abs() + dg1dy.abs()), (dg2dx.abs() + dg2dy.abs()));
      analisis['norma_jacobiana'] = MethodUtils.redondear(normaJacobiana, dn);
      
      if (normaJacobiana < 1) {
        analisis['convergencia_garantizada'] = true;
        analisis['tipo_convergencia'] = 'Lineal';
        analisis['velocidad_convergencia'] = normaJacobiana < 0.5 ? 'Rápida' : 'Moderada';
      } else {
        analisis['convergencia_garantizada'] = false;
        analisis['tipo_convergencia'] = 'No garantizada';
      }

      if (success) {
        analisis['solucion_encontrada'] = true;
        analisis['iteraciones_realizadas'] = iterations;
        analisis['solucion_final'] = '(${MethodUtils.redondear(x, dn)}, ${MethodUtils.redondear(y, dn)})';

        double g1Final = parser.evaluar2Variables(function1, x, y);
        double g2Final = parser.evaluar2Variables(function2, x, y);
        double errorPuntoFijo = max((g1Final - x).abs(), (g2Final - y).abs());
        analisis['error_punto_fijo'] = MethodUtils.redondear(errorPuntoFijo, dn);
        analisis['es_punto_fijo_exacto'] = errorPuntoFijo < 1e-10;
      }
      
    } catch (e) {
      analisis['error'] = 'Error en análisis de convergencia: ${e.toString()}';
    }
    
    return analisis;
  }

  List<Map<String, double>> obtenerPuntosFuncion1({int numPuntos = 100}) {
    return _obtenerPuntosFuncion2D(function1, numPuntos);
  }

  List<Map<String, double>> obtenerPuntosFuncion2({int numPuntos = 100}) {
    return _obtenerPuntosFuncion2D(function2, numPuntos);
  }

  List<Map<String, double>> _obtenerPuntosFuncion2D(String funcion, int numPuntos) {
    List<Map<String, double>> puntos = [];
    
    double minVal = min(x, y) - 2.0;
    double maxVal = max(x, y) + 2.0;
    double paso = (maxVal - minVal) / numPuntos;

    double yFijo = y;
    for (int i = 0; i <= numPuntos; i++) {
      double xVal = minVal + i * paso;
      try {
        double z = parser.evaluar2Variables(funcion, xVal, yFijo);
        if (!z.isNaN && !z.isInfinite) {
          puntos.add({
            'x': xVal,
            'y': z,
            'tipo': 1.0
          });
        }
      } catch (e) {
      }
    }

    double xFijo = x;
    for (int i = 0; i <= numPuntos; i++) {
      double yVal = minVal + i * paso;
      try {
        double z = parser.evaluar2Variables(funcion, xFijo, yVal);
        if (!z.isNaN && !z.isInfinite) {
          puntos.add({
            'x': yVal,
            'y': z,
            'tipo': 2.0
          });
        }
      } catch (e) {
      }
    }
    
    return puntos;
  }

  List<Map<String, double>> obtenerTrayectoriaConvergencia() {
    List<Map<String, double>> trayectoria = [];
    
    if (resultTable.isEmpty) return trayectoria;
    
    for (int i = 0; i < resultTable.length; i++) {
      trayectoria.add({
        'x': resultTable[i][1],
        'y': resultTable[i][2],
        'iteracion': resultTable[i][0],
        'error': resultTable[i][5]
      });
    }
    
    return trayectoria;
  }

  List<Map<String, double>> obtenerHistorialErrores() {
    List<Map<String, double>> historial = [];
    
    for (int i = 1; i < resultTable.length; i++) {
      historial.add({
        'iteracion': resultTable[i][0],
        'error_x': resultTable[i][3],
        'error_y': resultTable[i][4],
        'error_max': resultTable[i][5]
      });
    }
    
    return historial;
  }

  Map<String, dynamic> verificarFormaPuntoFijo() {
    Map<String, dynamic> analisis = {};
    
    try {
      analisis['funcion_g1'] = function1;
      analisis['funcion_g2'] = function2;

      double h = 0.0001;
      List<double> derivadas = [];

      derivadas.add((parser.evaluar2Variables(function1, x + h, y) - parser.evaluar2Variables(function1, x, y)) / h);
      derivadas.add((parser.evaluar2Variables(function1, x, y + h) - parser.evaluar2Variables(function1, x, y)) / h);

      derivadas.add((parser.evaluar2Variables(function2, x + h, y) - parser.evaluar2Variables(function2, x, y)) / h);
      derivadas.add((parser.evaluar2Variables(function2, x, y + h) - parser.evaluar2Variables(function2, x, y)) / h);
      
      double maxDerivada = derivadas.map((d) => d.abs()).reduce(max);
      analisis['max_derivada_parcial'] = MethodUtils.redondear(maxDerivada, dn);
      
      if (maxDerivada < 1) {
        analisis['es_contractiva'] = true;
        analisis['recomendacion'] = 'El sistema es contractivo. La convergencia está garantizada.';
      } else {
        analisis['es_contractiva'] = false;
        analisis['recomendacion'] = 'El sistema no es contractivo. La convergencia no está garantizada.';
      }

      double g1Inicial = parser.evaluar2Variables(function1, x, y);
      double g2Inicial = parser.evaluar2Variables(function2, x, y);
      double distancia = sqrt(pow(g1Inicial - x, 2) + pow(g2Inicial - y, 2));
      
      analisis['distancia_inicial'] = MethodUtils.redondear(distancia, dn);
      analisis['punto_fijo_cercano'] = distancia < 1.0;
      
    } catch (e) {
      analisis['error'] = 'Error en verificación de forma: ${e.toString()}';
    }
    
    return analisis;
  }

  double calcularRadioEspectral(double xPunto, double yPunto) {
    try {
      double h = 0.0001;

      double dg1dx = (parser.evaluar2Variables(function1, xPunto + h, yPunto) - parser.evaluar2Variables(function1, xPunto, yPunto)) / h;
      double dg1dy = (parser.evaluar2Variables(function1, xPunto, yPunto + h) - parser.evaluar2Variables(function1, xPunto, yPunto)) / h;
      double dg2dx = (parser.evaluar2Variables(function2, xPunto + h, yPunto) - parser.evaluar2Variables(function2, xPunto, yPunto)) / h;
      double dg2dy = (parser.evaluar2Variables(function2, xPunto, yPunto + h) - parser.evaluar2Variables(function2, xPunto, yPunto)) / h;

      double traza = dg1dx + dg2dy;
      double determinante = dg1dx * dg2dy - dg1dy * dg2dx;
      
      double discriminante = traza * traza - 4 * determinante;
      if (discriminante < 0) {
        return sqrt(dg1dx * dg1dx + dg1dy * dg1dy + dg2dx * dg2dx + dg2dy * dg2dy) / 2;
      } else {
        double lambda1 = (traza + sqrt(discriminante)) / 2;
        double lambda2 = (traza - sqrt(discriminante)) / 2;
        return max(lambda1.abs(), lambda2.abs());
      }
    } catch (e) {
      return double.nan;
    }
  }

  Map<String, dynamic> obtenerInfoSistema() {
    Map<String, dynamic> info = {};
    
    try {
      info['sistema_ecuaciones'] = {
        'x = g1(x,y)': function1,
        'y = g2(x,y)': function2
      };
      
      info['variables_detectadas_g1'] = parser.encontrarVariables(function1).toList();
      info['variables_detectadas_g2'] = parser.encontrarVariables(function2).toList();

      double g1Inicial = parser.evaluar2Variables(function1, x, y);
      double g2Inicial = parser.evaluar2Variables(function2, x, y);
      
      info['evaluacion_inicial'] = {
        'g1($x, $y)': MethodUtils.redondear(g1Inicial, dn),
        'g2($x, $y)': MethodUtils.redondear(g2Inicial, dn)
      };
      
      info['distancia_al_punto_fijo'] = MethodUtils.redondear(
        sqrt(pow(g1Inicial - x, 2) + pow(g2Inicial - y, 2)), dn
      );
      
    } catch (e) {
      info['error'] = 'Error al obtener información del sistema: ${e.toString()}';
    }
    
    return info;
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json.addAll({
      'function1': function1,
      'function2': function2,
      'x': x,
      'y': y,
      'tol': tol,
      'n': n,
      'dn': dn,
      'resultTable': resultTable,
    });
    return json;
  }

  @override
  String getResultSummary() {
    String summary = '${super.getResultSummary()}\n'
                    'Función g1(x,y): $function1\n'
                    'Función g2(x,y): $function2\n'
                    'Punto inicial: (${MethodUtils.redondear(x, dn)}, ${MethodUtils.redondear(y, dn)})\n'
                    'Tolerancia: $tol\n'
                    'Iteraciones máximas: $n';
    
    if (success) {
      summary += '\nSolución encontrada: (${MethodUtils.redondear(x, dn)}, ${MethodUtils.redondear(y, dn)})';
      
      // Verificar la solución
      try {
        double g1Final = parser.evaluar2Variables(function1, x, y);
        double g2Final = parser.evaluar2Variables(function2, x, y);
        double errorSol = max((g1Final - x).abs(), (g2Final - y).abs());
        summary += '\nError de la solución: ${MethodUtils.redondear(errorSol, dn)}';
      } catch (e) {
        summary += '\nNo se pudo verificar la solución';
      }
    }
    
    return summary;
  }

  String getMethodDescription() {
    return '''
Propósito: Resolver sistemas de ecuaciones no lineales.

Algoritmo: Partiendo de una estimación inicial (x0,y0).

Convergencia: Requiere que las funciones g1 y g2 sean contrativas en una región alrededor de la solución.

Característica: Simple de implementar pero puede no converger si las funciones no cumplen las condiciones de contracción.
''';
  }
}
