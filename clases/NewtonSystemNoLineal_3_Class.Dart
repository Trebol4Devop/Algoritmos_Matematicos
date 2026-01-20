import 'dart:math';
import 'MethodClass.Dart';
import 'MethodUtils.Dart';
import 'MathParser.Dart';

/// Implementación del método de Newton para sistemas de tres ecuaciones no lineales
class NewtonSystemNoLineal_3_Class extends MethodClass {
  String function1;
  String function2;
  String function3;
  String df1dx;
  String df1dy;
  String df1dz;
  String df2dx;
  String df2dy;
  String df2dz;
  String df3dx;
  String df3dy;
  String df3dz;
  double x;
  double y;
  double z;
  int n;
  double tol;
  int dn;
  List<List<double>> resultTable;
  MathParser parser;

  NewtonSystemNoLineal_3_Class({
    this.function1 = "",
    this.function2 = "",
    this.function3 = "",
    this.df1dx = "",
    this.df1dy = "",
    this.df1dz = "",
    this.df2dx = "",
    this.df2dy = "",
    this.df2dz = "",
    this.df3dx = "",
    this.df3dy = "",
    this.df3dz = "",
    this.x = 0.0,
    this.y = 0.0,
    this.z = 0.0,
    this.n = 0,
    this.tol = 0.0,
    this.dn = 0,
    this.resultTable = const [],
    int id = 14,
    String title = "Newton Sistema No Lineal 3 Variables",
    String subtitle = "Resolución de sistemas de ecuaciones no lineales",
    String index = "NEWTON3",
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
      return "Error: debe proporcionar las tres funciones f1(x,y,z), f2(x,y,z) y f3(x,y,z)";
    }
    
    if (df1dx.isEmpty || df1dy.isEmpty || df1dz.isEmpty ||
        df2dx.isEmpty || df2dy.isEmpty || df2dz.isEmpty ||
        df3dx.isEmpty || df3dy.isEmpty || df3dz.isEmpty) {
      return "Error: debe proporcionar todas las derivadas parciales";
    }
    
    if (tol <= 0) {
      return "Error: la tolerancia debe ser mayor que 0";
    }
    
    if (n <= 0) {
      return "Error: el número máximo de iteraciones debe ser mayor que 0";
    }
    try {
      List<String> funciones = [
        function1, function2, function3,
        df1dx, df1dy, df1dz,
        df2dx, df2dy, df2dz,
        df3dx, df3dy, df3dz
      ];
      for (int i = 0; i < funciones.length; i++) {
        if (!parser.validarExpresion3Variables(funciones[i])) {
          return "Error: la expresión ${funciones[i]} no es válida para 3 variables";
        }
      }
    } catch (e) {
      return "Error al validar las funciones: ${e.toString()}";
    }
    try {
      double test1 = parser.evaluar3Variables(function1, x, y, z);
      double test2 = parser.evaluar3Variables(function2, x, y, z);
      double test3 = parser.evaluar3Variables(function3, x, y, z);
      double test4 = parser.evaluar3Variables(df1dx, x, y, z);
      double test5 = parser.evaluar3Variables(df1dy, x, y, z);
      double test6 = parser.evaluar3Variables(df1dz, x, y, z);
      double test7 = parser.evaluar3Variables(df2dx, x, y, z);
      double test8 = parser.evaluar3Variables(df2dy, x, y, z);
      double test9 = parser.evaluar3Variables(df2dz, x, y, z);
      double test10 = parser.evaluar3Variables(df3dx, x, y, z);
      double test11 = parser.evaluar3Variables(df3dy, x, y, z);
      double test12 = parser.evaluar3Variables(df3dz, x, y, z);
      
      if (test1.isNaN || test1.isInfinite || 
          test2.isNaN || test2.isInfinite ||
          test3.isNaN || test3.isInfinite ||
          test4.isNaN || test4.isInfinite ||
          test5.isNaN || test5.isInfinite ||
          test6.isNaN || test6.isInfinite ||
          test7.isNaN || test7.isInfinite ||
          test8.isNaN || test8.isInfinite ||
          test9.isNaN || test9.isInfinite ||
          test10.isNaN || test10.isInfinite ||
          test11.isNaN || test11.isInfinite ||
          test12.isNaN || test12.isInfinite) {
        return "Error: las funciones o derivadas producen valores no válidos en el punto inicial";
      }
    } catch (e) {
      return "Error: no se pueden evaluar las funciones en el punto inicial: ${e.toString()}";
    }
    
    return null;
  }
  double _evaluarFuncion(int funcionIndex, double xVal, double yVal, double zVal) {
    switch (funcionIndex) {
      case 1:
        return parser.evaluar3Variables(function1, xVal, yVal, zVal);
      case 2:
        return parser.evaluar3Variables(function2, xVal, yVal, zVal);
      case 3:
        return parser.evaluar3Variables(function3, xVal, yVal, zVal);
      default:
        throw Exception("Índice de función no válido: $funcionIndex");
    }
  }
  double _evaluarDerivada(int funcionIndex, int variableIndex, double xVal, double yVal, double zVal) {
    switch (funcionIndex) {
      case 1:
        switch (variableIndex) {
          case 1: return parser.evaluar3Variables(df1dx, xVal, yVal, zVal);
          case 2: return parser.evaluar3Variables(df1dy, xVal, yVal, zVal);
          case 3: return parser.evaluar3Variables(df1dz, xVal, yVal, zVal);
          default: throw Exception("Índice de variable no válido: $variableIndex");
        }
      case 2:
        switch (variableIndex) {
          case 1: return parser.evaluar3Variables(df2dx, xVal, yVal, zVal);
          case 2: return parser.evaluar3Variables(df2dy, xVal, yVal, zVal);
          case 3: return parser.evaluar3Variables(df2dz, xVal, yVal, zVal);
          default: throw Exception("Índice de variable no válido: $variableIndex");
        }
      case 3:
        switch (variableIndex) {
          case 1: return parser.evaluar3Variables(df3dx, xVal, yVal, zVal);
          case 2: return parser.evaluar3Variables(df3dy, xVal, yVal, zVal);
          case 3: return parser.evaluar3Variables(df3dz, xVal, yVal, zVal);
          default: throw Exception("Índice de variable no válido: $variableIndex");
        }
      default:
        throw Exception("Índice de función no válido: $funcionIndex");
    }
  }
  List<double> _resolverSistemaLineal(List<List<double>> A, List<double> B) {
    int n = 3;
    List<List<double>> matriz = List.generate(n, (i) => List<double>.from(A[i]));
    List<double> vector = List<double>.from(B);
    for (int i = 0; i < n; i++) {
      double maxVal = matriz[i][i].abs();
      int maxRow = i;
      for (int k = i + 1; k < n; k++) {
        if (matriz[k][i].abs() > maxVal) {
          maxVal = matriz[k][i].abs();
          maxRow = k;
        }
      }
      if (maxRow != i) {
        for (int k = i; k < n; k++) {
          double temp = matriz[i][k];
          matriz[i][k] = matriz[maxRow][k];
          matriz[maxRow][k] = temp;
        }
        double tempVec = vector[i];
        vector[i] = vector[maxRow];
        vector[maxRow] = tempVec;
      }
      if (matriz[i][i].abs() < 1e-12) {
        throw Exception("El sistema lineal es singular");
      }
      for (int k = i + 1; k < n; k++) {
        double factor = matriz[k][i] / matriz[i][i];
        for (int j = i; j < n; j++) {
          if (j == i) {
            matriz[k][j] = 0.0;
          } else {
            matriz[k][j] -= factor * matriz[i][j];
          }
        }
        vector[k] -= factor * vector[i];
      }
    }
    List<double> solucion = List.filled(n, 0.0);
    for (int i = n - 1; i >= 0; i--) {
      solucion[i] = vector[i];
      for (int j = i + 1; j < n; j++) {
        solucion[i] -= matriz[i][j] * solucion[j];
      }
      solucion[i] /= matriz[i][i];
    }
    
    return solucion;
  }
  void newtonSystemNoLineal3Method() {
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
      bool ok = true;
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
      
      while (iteracion <= n && ok && !convergio) {
        try {
          double f1 = _evaluarFuncion(1, x0, y0, z0);
          double f2 = _evaluarFuncion(2, x0, y0, z0);
          double f3 = _evaluarFuncion(3, x0, y0, z0);
          List<List<double>> jacobiana = [
            [
              _evaluarDerivada(1, 1, x0, y0, z0),
              _evaluarDerivada(1, 2, x0, y0, z0),
              _evaluarDerivada(1, 3, x0, y0, z0)
            ],
            [
              _evaluarDerivada(2, 1, x0, y0, z0),
              _evaluarDerivada(2, 2, x0, y0, z0), 
              _evaluarDerivada(2, 3, x0, y0, z0)
            ],
            [
              _evaluarDerivada(3, 1, x0, y0, z0),
              _evaluarDerivada(3, 2, x0, y0, z0),
              _evaluarDerivada(3, 3, x0, y0, z0)
            ]
          ];
          List<double> vectorB = [-f1, -f2, -f3];
          List<double> delta = _resolverSistemaLineal(jacobiana, vectorB);
          double dx = delta[0];
          double dy = delta[1];
          double dz = delta[2];
          double x1 = x0 + dx;
          double y1 = y0 + dy;
          double z1 = z0 + dz;
          double errorX = dx.abs();
          double errorY = dy.abs();
          double errorZ = dz.abs();
          double errorGlobal = max(max(errorX, errorY), errorZ);
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
          
        } catch (e) {
          ok = false;
          message = "Error en la iteración $iteracion: ${e.toString()}";
          success = false;
        }
      }
      if (!convergio && ok) {
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
      message = "Error durante la ejecución del método de Newton: ${e.toString()}";
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
  double calcularDeterminanteJacobiano(double xPunto, double yPunto, double zPunto) {
    try {
      double d11 = parser.evaluar3Variables(df1dx, xPunto, yPunto, zPunto);
      double d12 = parser.evaluar3Variables(df1dy, xPunto, yPunto, zPunto);
      double d13 = parser.evaluar3Variables(df1dz, xPunto, yPunto, zPunto);
      double d21 = parser.evaluar3Variables(df2dx, xPunto, yPunto, zPunto);
      double d22 = parser.evaluar3Variables(df2dy, xPunto, yPunto, zPunto);
      double d23 = parser.evaluar3Variables(df2dz, xPunto, yPunto, zPunto);
      double d31 = parser.evaluar3Variables(df3dx, xPunto, yPunto, zPunto);
      double d32 = parser.evaluar3Variables(df3dy, xPunto, yPunto, zPunto);
      double d33 = parser.evaluar3Variables(df3dz, xPunto, yPunto, zPunto);
      return d11 * (d22 * d33 - d23 * d32) -
             d12 * (d21 * d33 - d23 * d31) +
             d13 * (d21 * d32 - d22 * d31);
    } catch (e) {
      return double.nan;
    }
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
      double detJ = calcularDeterminanteJacobiano(x, y, z);
      analisis['determinante_jacobiano'] = MethodUtils.redondear(detJ, dn);
      double f1Inicial = parser.evaluar3Variables(function1, x, y, z);
      double f2Inicial = parser.evaluar3Variables(function2, x, y, z);
      double f3Inicial = parser.evaluar3Variables(function3, x, y, z);
      analisis['f1(punto_inicial)'] = MethodUtils.redondear(f1Inicial, dn);
      analisis['f2(punto_inicial)'] = MethodUtils.redondear(f2Inicial, dn);
      analisis['f3(punto_inicial)'] = MethodUtils.redondear(f3Inicial, dn);
      if (detJ.abs() > 1e-10) {
        analisis['jacobiano_no_singular'] = true;
        analisis['convergencia_garantizada'] = true;
        analisis['tipo_convergencia'] = 'Cuadrática (Newton)';
      } else {
        analisis['jacobiano_no_singular'] = false;
        analisis['convergencia_garantizada'] = false;
        analisis['tipo_convergencia'] = 'No garantizada (Jacobiano singular)';
      }
      if (success) {
        analisis['solucion_encontrada'] = true;
        analisis['iteraciones_realizadas'] = iterations;
        analisis['solucion_final'] = '(${MethodUtils.redondear(x, dn)}, ${MethodUtils.redondear(y, dn)}, ${MethodUtils.redondear(z, dn)})';

        double f1Final = parser.evaluar3Variables(function1, x, y, z);
        double f2Final = parser.evaluar3Variables(function2, x, y, z);
        double f3Final = parser.evaluar3Variables(function3, x, y, z);
        double errorRaiz = max(max(f1Final.abs(), f2Final.abs()), f3Final.abs());
        analisis['error_raiz'] = MethodUtils.redondear(errorRaiz, dn);
        analisis['es_raiz_exacta'] = errorRaiz < 1e-10;
      }
      
    } catch (e) {
      analisis['error'] = 'Error en análisis de convergencia: ${e.toString()}';
    }
    
    return analisis;
  }
  Map<String, dynamic> obtenerInfoSistema() {
    Map<String, dynamic> info = {};
    
    try {
      info['sistema_ecuaciones'] = {
        'f1(x,y,z) = 0': function1,
        'f2(x,y,z) = 0': function2,
        'f3(x,y,z) = 0': function3
      };
      
      info['matriz_jacobiana'] = {
        'df1/dx': df1dx, 'df1/dy': df1dy, 'df1/dz': df1dz,
        'df2/dx': df2dx, 'df2/dy': df2dy, 'df2/dz': df2dz,
        'df3/dx': df3dx, 'df3/dy': df3dy, 'df3/dz': df3dz
      };
      
      info['variables_detectadas_f1'] = parser.encontrarVariables(function1).toList();
      info['variables_detectadas_f2'] = parser.encontrarVariables(function2).toList();
      info['variables_detectadas_f3'] = parser.encontrarVariables(function3).toList();
      double f1ValorInicial = parser.evaluar3Variables(function1, x, y, z);
      double f2ValorInicial = parser.evaluar3Variables(function2, x, y, z);
      double f3ValorInicial = parser.evaluar3Variables(function3, x, y, z);
      
      info['evaluacion_inicial'] = {
        'f1($x, $y, $z)': MethodUtils.redondear(f1ValorInicial, dn),
        'f2($x, $y, $z)': MethodUtils.redondear(f2ValorInicial, dn),
        'f3($x, $y, $z)': MethodUtils.redondear(f3ValorInicial, dn)
      };
      double normaFuncion = sqrt(f1ValorInicial * f1ValorInicial + 
                                f2ValorInicial * f2ValorInicial + 
                                f3ValorInicial * f3ValorInicial);
      info['norma_funcion_inicial'] = MethodUtils.redondear(normaFuncion, dn);
      
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
      'df1dx': df1dx,
      'df1dy': df1dy,
      'df1dz': df1dz,
      'df2dx': df2dx,
      'df2dy': df2dy,
      'df2dz': df2dz,
      'df3dx': df3dx,
      'df3dy': df3dy,
      'df3dz': df3dz,
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
                    'Función f1(x,y,z): $function1\n'
                    'Función f2(x,y,z): $function2\n'
                    'Función f3(x,y,z): $function3\n'
                    'Punto inicial: (${MethodUtils.redondear(x, dn)}, ${MethodUtils.redondear(y, dn)}, ${MethodUtils.redondear(z, dn)})\n'
                    'Tolerancia: $tol\n'
                    'Iteraciones máximas: $n';
    
    if (success) {
      summary += '\nSolución encontrada: (${MethodUtils.redondear(x, dn)}, ${MethodUtils.redondear(y, dn)}, ${MethodUtils.redondear(z, dn)})';
      try {
        double f1Final = parser.evaluar3Variables(function1, x, y, z);
        double f2Final = parser.evaluar3Variables(function2, x, y, z);
        double f3Final = parser.evaluar3Variables(function3, x, y, z);
        double errorSol = max(max(f1Final.abs(), f2Final.abs()), f3Final.abs());
        summary += '\nError de la solución: ${MethodUtils.redondear(errorSol, dn)}';
      } catch (e) {
        summary += '\nNo se pudo verificar la solución';
      }
    }
    
    return summary;
  }

  String getMethodDescription() {
    return '''
Propósito: Resolver sistemas de 3 ecuaciones no lineales:
f1(x,y,z)=0,f2(x,y,z)=0,f3(x,y,z)=0

Fundamento: Extensión del método de Newton a tres dimensiones mediante linearización con el Jacobiano.

Algoritmo: En cada iteración:

1. Se evalúa la matriz Jacobiana 3x3

2. Se resuelve el sitema lineal

3. Se actualizan los valores

Convergencia: Cuadrática cerca de la raíz, requiere que el Jacobiano sea invertible y una buena estimación inicial.

''';
  }
}