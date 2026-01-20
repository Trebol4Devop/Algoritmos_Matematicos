import 'dart:math';
import 'MethodClass.Dart';
import 'MethodUtils.Dart';
import 'MathParser.Dart';

/// Implementación del método de punto fijo para sistemas de tres ecuaciones no lineales
class FixedPoint3VariablesClass extends MethodClass {
  String function1;
  String function2;
  String function3;
  double x;
  double y;
  double z;
  double tol;
  int n;
  int dn;
  List<List<double>> resultTable;
  MathParser parser;

  FixedPoint3VariablesClass({
    this.function1 = "",
    this.function2 = "",
    this.function3 = "",
    this.x = 0.0,
    this.y = 0.0,
    this.z = 0.0,
    this.tol = 0.0,
    this.n = 0,
    this.dn = 0,
    this.resultTable = const [],
    int id = 12,
    String title = "Punto Fijo 3 Variables",
    String subtitle = "Resolución de sistemas de ecuaciones no lineales",
    String index = "FP3",
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
    if (function1.isEmpty || function2.isEmpty || function3.isEmpty) {
      return "Error: debe proporcionar las tres funciones g1(x,y,z), g2(x,y,z) y g3(x,y,z)";
    }
    
    if (tol <= 0) {
      return "Error: la tolerancia debe ser mayor que 0";
    }
    
    if (n <= 0) {
      return "Error: el número máximo de iteraciones debe ser mayor que 0";
    }

    try {
      if (!parser.validarExpresion3Variables(function1)) {
        return "Error: la función g1(x,y,z) no es válida";
      }
      if (!parser.validarExpresion3Variables(function2)) {
        return "Error: la función g2(x,y,z) no es válida";
      }
      if (!parser.validarExpresion3Variables(function3)) {
        return "Error: la función g3(x,y,z) no es válida";
      }
    } catch (e) {
      return "Error al validar las funciones: ${e.toString()}";
    }

    try {
      double test1 = parser.evaluar3Variables(function1, x, y, z);
      double test2 = parser.evaluar3Variables(function2, x, y, z);
      double test3 = parser.evaluar3Variables(function3, x, y, z);
      
      if (test1.isNaN || test1.isInfinite || 
          test2.isNaN || test2.isInfinite || 
          test3.isNaN || test3.isInfinite) {
        return "Error: las funciones producen valores no válidos en el punto inicial";
      }
    } catch (e) {
      return "Error: no se pueden evaluar las funciones en el punto inicial: ${e.toString()}";
    }
    
    return null;
  }

  void fixedPoint3VariablesMethod() {
    initialize();
    
    try {
      String? error = validarParametros();
      if (error != null) {
        message = error;
        return;
      }
      
      double x0 = x;
      double y0 = y;
      double z0 = z;
      int iteracion = 1;
      bool convergio = false;
      double errorGlobal = 0.0;
      resultTable = [];
      List<double> filaInicial = [
        0.0,
        MethodUtils.redondear(x0, dn),
        MethodUtils.redondear(y0, dn),
        MethodUtils.redondear(z0, dn),
        0.0,
        0.0,
        0.0,
        0.0
      ];
      resultTable.add(filaInicial);
      
      while (iteracion <= n && !convergio) {
        double x1 = parser.evaluar3Variables(function1, x0, y0, z0);
        double y1 = parser.evaluar3Variables(function2, x0, y0, z0);
        double z1 = parser.evaluar3Variables(function3, x0, y0, z0);
        double errorX = (x1 - x0).abs();
        double errorY = (y1 - y0).abs();
        double errorZ = (z1 - z0).abs();
        errorGlobal = max(max(errorX, errorY), errorZ);
        List<double> filaResultado = [
          iteracion.toDouble(),
          MethodUtils.redondear(x1, dn),
          MethodUtils.redondear(y1, dn),
          MethodUtils.redondear(z1, dn),
          MethodUtils.redondear(errorX, dn),
          MethodUtils.redondear(errorY, dn),
          MethodUtils.redondear(errorZ, dn),
          MethodUtils.redondear(errorGlobal, dn)
        ];
        
        resultTable.add(filaResultado);
        if (errorGlobal <= tol) {
          convergio = true;
          success = true;
          iterations = iteracion;
          x = x1;
          y = y1;
          z = z1;
          result = errorGlobal;
          message = "Solución: (${MethodUtils.redondear(x1, dn)}, ${MethodUtils.redondear(y1, dn)}, ${MethodUtils.redondear(z1, dn)})\n"
                    "Error final: ${MethodUtils.redondear(errorGlobal, dn)}";
        } else {
          x0 = x1;
          y0 = y1;
          z0 = z1;
          iteracion++;
        }
      }

      if (!convergio) {
        success = false;
        iterations = n;
        List<double> ultimaFila = resultTable.last;
        x = ultimaFila[1];
        y = ultimaFila[2];
        z = ultimaFila[3];
        result = ultimaFila[7];
        message = "Máximo de iteraciones ($n) alcanzado sin convergencia\n"
                  "Mejor aproximación: (${MethodUtils.redondear(x, dn)}, ${MethodUtils.redondear(y, dn)}, ${MethodUtils.redondear(z, dn)})\n"
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

    List<String> encabezados = ["Iteración", "x", "y", "z", "Error x", "Error y", "Error z", "Error Máximo"];
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
    return "(${MethodUtils.redondear(x, dn)}, ${MethodUtils.redondear(y, dn)}, ${MethodUtils.redondear(z, dn)})";
  }
  Map<String, dynamic> analizarConvergencia() {
    Map<String, dynamic> analisis = {};
    
    try {
      if (function1.isEmpty || function2.isEmpty || function3.isEmpty) {
        analisis['error'] = 'No hay funciones para analizar';
        return analisis;
      }
      
      analisis['punto_inicial'] = '(${MethodUtils.redondear(x, dn)}, ${MethodUtils.redondear(y, dn)}, ${MethodUtils.redondear(z, dn)})';
      analisis['tolerancia'] = tol;
      analisis['iteraciones_maximas'] = n;
      double h = 0.0001;
      double dg1dx = (parser.evaluar3Variables(function1, x + h, y, z) - parser.evaluar3Variables(function1, x, y, z)) / h;
      double dg1dy = (parser.evaluar3Variables(function1, x, y + h, z) - parser.evaluar3Variables(function1, x, y, z)) / h;
      double dg1dz = (parser.evaluar3Variables(function1, x, y, z + h) - parser.evaluar3Variables(function1, x, y, z)) / h;

      double dg2dx = (parser.evaluar3Variables(function2, x + h, y, z) - parser.evaluar3Variables(function2, x, y, z)) / h;
      double dg2dy = (parser.evaluar3Variables(function2, x, y + h, z) - parser.evaluar3Variables(function2, x, y, z)) / h;
      double dg2dz = (parser.evaluar3Variables(function2, x, y, z + h) - parser.evaluar3Variables(function2, x, y, z)) / h;

      double dg3dx = (parser.evaluar3Variables(function3, x + h, y, z) - parser.evaluar3Variables(function3, x, y, z)) / h;
      double dg3dy = (parser.evaluar3Variables(function3, x, y + h, z) - parser.evaluar3Variables(function3, x, y, z)) / h;
      double dg3dz = (parser.evaluar3Variables(function3, x, y, z + h) - parser.evaluar3Variables(function3, x, y, z)) / h;
      
      analisis['dg1/dx'] = MethodUtils.redondear(dg1dx, dn);
      analisis['dg1/dy'] = MethodUtils.redondear(dg1dy, dn);
      analisis['dg1/dz'] = MethodUtils.redondear(dg1dz, dn);
      analisis['dg2/dx'] = MethodUtils.redondear(dg2dx, dn);
      analisis['dg2/dy'] = MethodUtils.redondear(dg2dy, dn);
      analisis['dg2/dz'] = MethodUtils.redondear(dg2dz, dn);
      analisis['dg3/dx'] = MethodUtils.redondear(dg3dx, dn);
      analisis['dg3/dy'] = MethodUtils.redondear(dg3dy, dn);
      analisis['dg3/dz'] = MethodUtils.redondear(dg3dz, dn);

      double normaJacobiana = max(
        max((dg1dx.abs() + dg1dy.abs() + dg1dz.abs()), 
            (dg2dx.abs() + dg2dy.abs() + dg2dz.abs())),
        (dg3dx.abs() + dg3dy.abs() + dg3dz.abs())
      );
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
        analisis['solucion_final'] = '(${MethodUtils.redondear(x, dn)}, ${MethodUtils.redondear(y, dn)}, ${MethodUtils.redondear(z, dn)})';

        double g1Final = parser.evaluar3Variables(function1, x, y, z);
        double g2Final = parser.evaluar3Variables(function2, x, y, z);
        double g3Final = parser.evaluar3Variables(function3, x, y, z);
        double errorPuntoFijo = max(max((g1Final - x).abs(), (g2Final - y).abs()), (g3Final - z).abs());
        analisis['error_punto_fijo'] = MethodUtils.redondear(errorPuntoFijo, dn);
        analisis['es_punto_fijo_exacto'] = errorPuntoFijo < 1e-10;
      }
      
    } catch (e) {
      analisis['error'] = 'Error en análisis de convergencia: ${e.toString()}';
    }
    
    return analisis;
  }

  List<Map<String, double>> obtenerPuntosFuncion1({int numPuntos = 50}) {
    return _obtenerPuntosFuncion3D(function1, numPuntos);
  }

  List<Map<String, double>> obtenerPuntosFuncion2({int numPuntos = 50}) {
    return _obtenerPuntosFuncion3D(function2, numPuntos);
  }

  List<Map<String, double>> obtenerPuntosFuncion3({int numPuntos = 50}) {
    return _obtenerPuntosFuncion3D(function3, numPuntos);
  }

  List<Map<String, double>> _obtenerPuntosFuncion3D(String funcion, int numPuntos) {
    List<Map<String, double>> puntos = [];
    
    double minVal = min(min(x, y), z) - 2.0;
    double maxVal = max(max(x, y), z) + 2.0;
    double paso = (maxVal - minVal) / numPuntos;

    double yFijo = y;
    double zFijo = z;
    for (int i = 0; i <= numPuntos; i++) {
      double xVal = minVal + i * paso;
      try {
        double w = parser.evaluar3Variables(funcion, xVal, yFijo, zFijo);
        if (!w.isNaN && !w.isInfinite) {
          puntos.add({
            'x': xVal,
            'y': w,
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
        double w = parser.evaluar3Variables(funcion, xFijo, yVal, zFijo);
        if (!w.isNaN && !w.isInfinite) {
          puntos.add({
            'x': yVal,
            'y': w,
            'tipo': 2.0
          });
        }
      } catch (e) {
      }
    }

    for (int i = 0; i <= numPuntos; i++) {
      double zVal = minVal + i * paso;
      try {
        double w = parser.evaluar3Variables(funcion, xFijo, yFijo, zVal);
        if (!w.isNaN && !w.isInfinite) {
          puntos.add({
            'x': zVal,
            'y': w,
            'tipo': 3.0
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
        'z': resultTable[i][3],
        'iteracion': resultTable[i][0],
        'error': resultTable[i][7]
      });
    }
    
    return trayectoria;
  }
  List<Map<String, double>> obtenerHistorialErrores() {
    List<Map<String, double>> historial = [];
    
    for (int i = 1; i < resultTable.length; i++) {
      historial.add({
        'iteracion': resultTable[i][0],
        'error_x': resultTable[i][4],
        'error_y': resultTable[i][5],
        'error_z': resultTable[i][6],
        'error_max': resultTable[i][7]
      });
    }
    
    return historial;
  }
  Map<String, dynamic> verificarFormaPuntoFijo() {
    Map<String, dynamic> analisis = {};
    
    try {
      analisis['funcion_g1'] = function1;
      analisis['funcion_g2'] = function2;
      analisis['funcion_g3'] = function3;
      double h = 0.0001;
      List<double> derivadas = [];
      derivadas.add((parser.evaluar3Variables(function1, x + h, y, z) - parser.evaluar3Variables(function1, x, y, z)) / h);
      derivadas.add((parser.evaluar3Variables(function1, x, y + h, z) - parser.evaluar3Variables(function1, x, y, z)) / h);
      derivadas.add((parser.evaluar3Variables(function1, x, y, z + h) - parser.evaluar3Variables(function1, x, y, z)) / h);

      derivadas.add((parser.evaluar3Variables(function2, x + h, y, z) - parser.evaluar3Variables(function2, x, y, z)) / h);
      derivadas.add((parser.evaluar3Variables(function2, x, y + h, z) - parser.evaluar3Variables(function2, x, y, z)) / h);
      derivadas.add((parser.evaluar3Variables(function2, x, y, z + h) - parser.evaluar3Variables(function2, x, y, z)) / h);

      derivadas.add((parser.evaluar3Variables(function3, x + h, y, z) - parser.evaluar3Variables(function3, x, y, z)) / h);
      derivadas.add((parser.evaluar3Variables(function3, x, y + h, z) - parser.evaluar3Variables(function3, x, y, z)) / h);
      derivadas.add((parser.evaluar3Variables(function3, x, y, z + h) - parser.evaluar3Variables(function3, x, y, z)) / h);
      
      double maxDerivada = derivadas.map((d) => d.abs()).reduce(max);
      analisis['max_derivada_parcial'] = MethodUtils.redondear(maxDerivada, dn);
      
      if (maxDerivada < 1) {
        analisis['es_contractiva'] = true;
        analisis['recomendacion'] = 'El sistema es contractivo. La convergencia está garantizada.';
      } else {
        analisis['es_contractiva'] = false;
        analisis['recomendacion'] = 'El sistema no es contractivo. La convergencia no está garantizada.';
      }
      double g1Inicial = parser.evaluar3Variables(function1, x, y, z);
      double g2Inicial = parser.evaluar3Variables(function2, x, y, z);
      double g3Inicial = parser.evaluar3Variables(function3, x, y, z);
      double distancia = sqrt(pow(g1Inicial - x, 2) + pow(g2Inicial - y, 2) + pow(g3Inicial - z, 2));
      
      analisis['distancia_inicial'] = MethodUtils.redondear(distancia, dn);
      analisis['punto_fijo_cercano'] = distancia < 1.0;
      
    } catch (e) {
      analisis['error'] = 'Error en verificación de forma: ${e.toString()}';
    }
    
    return analisis;
  }
  Map<String, dynamic> obtenerInfoSistema() {
    Map<String, dynamic> info = {};
    
    try {
      info['sistema_ecuaciones'] = {
        'x = g1(x,y,z)': function1,
        'y = g2(x,y,z)': function2,
        'z = g3(x,y,z)': function3
      };
      
      info['variables_detectadas_g1'] = parser.encontrarVariables(function1).toList();
      info['variables_detectadas_g2'] = parser.encontrarVariables(function2).toList();
      info['variables_detectadas_g3'] = parser.encontrarVariables(function3).toList();

      double g1Inicial = parser.evaluar3Variables(function1, x, y, z);
      double g2Inicial = parser.evaluar3Variables(function2, x, y, z);
      double g3Inicial = parser.evaluar3Variables(function3, x, y, z);
      
      info['evaluacion_inicial'] = {
        'g1($x, $y, $z)': MethodUtils.redondear(g1Inicial, dn),
        'g2($x, $y, $z)': MethodUtils.redondear(g2Inicial, dn),
        'g3($x, $y, $z)': MethodUtils.redondear(g3Inicial, dn)
      };
      
      info['distancia_al_punto_fijo'] = MethodUtils.redondear(
        sqrt(pow(g1Inicial - x, 2) + pow(g2Inicial - y, 2) + pow(g3Inicial - z, 2)), dn
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
      'function3': function3,
      'x': x,
      'y': y,
      'z': z,
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
                    'Función g1(x,y,z): $function1\n'
                    'Función g2(x,y,z): $function2\n'
                    'Función g3(x,y,z): $function3\n'
                    'Punto inicial: (${MethodUtils.redondear(x, dn)}, ${MethodUtils.redondear(y, dn)}, ${MethodUtils.redondear(z, dn)})\n'
                    'Tolerancia: $tol\n'
                    'Iteraciones máximas: $n';
    
    if (success) {
      summary += '\nSolución encontrada: (${MethodUtils.redondear(x, dn)}, ${MethodUtils.redondear(y, dn)}, ${MethodUtils.redondear(z, dn)})';

      try {
        double g1Final = parser.evaluar3Variables(function1, x, y, z);
        double g2Final = parser.evaluar3Variables(function2, x, y, z);
        double g3Final = parser.evaluar3Variables(function3, x, y, z);
        double errorSol = max(max((g1Final - x).abs(), (g2Final - y).abs()), (g3Final - z).abs());
        summary += '\nError de la solución: ${MethodUtils.redondear(errorSol, dn)}';
      } catch (e) {
        summary += '\nNo se pudo verificar la solución';
      }
    }
    
    return summary;
  }

  String getMethodDescription() {
    return '''
Propósito: Resolver sistemas de ecuaciones no lineales de la forma:
x=g1(x,y,z),y=g2(x,y,z),z=g3(x,y,z)

Algoritmo: Partiendo de (x0,y0,z0)
''';
  }
}