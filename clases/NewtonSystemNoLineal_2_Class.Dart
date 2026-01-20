import 'dart:math';
import 'MethodClass.Dart';
import 'MethodUtils.Dart';
import 'MathParser.Dart';

/// Implementación del método de Newton para sistemas de dos ecuaciones no lineales
class NewtonSystemNoLineal_2_Class extends MethodClass {
  String function1;
  String function2;
  String df1dx;
  String df1dy;
  String df2dx;
  String df2dy;
  double x;
  double y;
  int n;
  double tol;
  int dn;
  List<List<double>> resultTable;
  MathParser parser;

  NewtonSystemNoLineal_2_Class({
    this.function1 = "",
    this.function2 = "",
    this.df1dx = "",
    this.df1dy = "",
    this.df2dx = "",
    this.df2dy = "",
    this.x = 0.0,
    this.y = 0.0,
    this.n = 0,
    this.tol = 0.0,
    this.dn = 0,
    this.resultTable = const [],
    int id = 13,
    String title = "Newton Sistema No Lineal 2 Variables",
    String subtitle = "Resolución de sistemas de ecuaciones no lineales",
    String index = "NEWTON2",
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
      return "Error: debe proporcionar ambas funciones f1(x,y) y f2(x,y)";
    }
    
    if (df1dx.isEmpty || df1dy.isEmpty || df2dx.isEmpty || df2dy.isEmpty) {
      return "Error: debe proporcionar todas las derivadas parciales";
    }
    
    if (tol <= 0) {
      return "Error: la tolerancia debe ser mayor que 0";
    }
    
    if (n <= 0) {
      return "Error: el número máximo de iteraciones debe ser mayor que 0";
    }
    try {
      List<String> funciones = [function1, function2, df1dx, df1dy, df2dx, df2dy];
      for (int i = 0; i < funciones.length; i++) {
        if (!parser.validarExpresion2Variables(funciones[i])) {
          return "Error: la expresión ${funciones[i]} no es válida para 2 variables";
        }
      }
    } catch (e) {
      return "Error al validar las funciones: ${e.toString()}";
    }
    try {
      double test1 = parser.evaluar2Variables(function1, x, y);
      double test2 = parser.evaluar2Variables(function2, x, y);
      double test3 = parser.evaluar2Variables(df1dx, x, y);
      double test4 = parser.evaluar2Variables(df1dy, x, y);
      double test5 = parser.evaluar2Variables(df2dx, x, y);
      double test6 = parser.evaluar2Variables(df2dy, x, y);
      
      if (test1.isNaN || test1.isInfinite || 
          test2.isNaN || test2.isInfinite ||
          test3.isNaN || test3.isInfinite ||
          test4.isNaN || test4.isInfinite ||
          test5.isNaN || test5.isInfinite ||
          test6.isNaN || test6.isInfinite) {
        return "Error: las funciones o derivadas producen valores no válidos en el punto inicial";
      }
    } catch (e) {
      return "Error: no se pueden evaluar las funciones en el punto inicial: ${e.toString()}";
    }
    
    return null;
  }

  double _evaluarFuncion(int funcionIndex, double xVal, double yVal) {
    switch (funcionIndex) {
      case 1:
        return parser.evaluar2Variables(function1, xVal, yVal);
      case 2:
        return parser.evaluar2Variables(function2, xVal, yVal);
      default:
        throw Exception("Índice de función no válido: $funcionIndex");
    }
  }

  double _evaluarDerivada(int funcionIndex, int variableIndex, double xVal, double yVal) {
    switch (funcionIndex) {
      case 1:
        switch (variableIndex) {
          case 1: return parser.evaluar2Variables(df1dx, xVal, yVal);
          case 2: return parser.evaluar2Variables(df1dy, xVal, yVal);
          default: throw Exception("Índice de variable no válido: $variableIndex");
        }
      case 2:
        switch (variableIndex) {
          case 1: return parser.evaluar2Variables(df2dx, xVal, yVal);
          case 2: return parser.evaluar2Variables(df2dy, xVal, yVal);
          default: throw Exception("Índice de variable no válido: $variableIndex");
        }
      default:
        throw Exception("Índice de función no válido: $funcionIndex");
    }
  }

  List<double> _resolverSistemaLineal(List<List<double>> A, List<double> B) {
    int n = 2;
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

  void newtonSystemNoLineal2Method() {
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
      bool ok = true;
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
      
      while (iteracion <= n && ok && !convergio) {
        try {
          double f1 = _evaluarFuncion(1, x0, y0);
          double f2 = _evaluarFuncion(2, x0, y0);

          List<List<double>> jacobiana = [
            [
              _evaluarDerivada(1, 1, x0, y0),
              _evaluarDerivada(1, 2, x0, y0)
            ],
            [
              _evaluarDerivada(2, 1, x0, y0),
              _evaluarDerivada(2, 2, x0, y0)
            ]
          ];
          List<double> vectorB = [-f1, -f2];
          List<double> delta = _resolverSistemaLineal(jacobiana, vectorB);
          double dx = delta[0];
          double dy = delta[1];
          double x1 = x0 + dx;
          double y1 = y0 + dy;
          double errorX = dx.abs();
          double errorY = dy.abs();
          double errorGlobal = max(errorX, errorY);
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
        result = ultimaFila[5];
        message = "Máximo de iteraciones ($n) alcanzado sin convergencia\n"
                  "Mejor aproximación: (${MethodUtils.redondear(x, dn)}, ${MethodUtils.redondear(y, dn)})\n"
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

  double calcularDeterminanteJacobiano(double xPunto, double yPunto) {
    try {
      double derivadaF1x = parser.evaluar2Variables(df1dx, xPunto, yPunto);
      double derivadaF1y = parser.evaluar2Variables(df1dy, xPunto, yPunto);
      double derivadaF2x = parser.evaluar2Variables(df2dx, xPunto, yPunto);
      double derivadaF2y = parser.evaluar2Variables(df2dy, xPunto, yPunto);
      
      return derivadaF1x * derivadaF2y - derivadaF1y * derivadaF2x;
    } catch (e) {
      return double.nan;
    }
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
      double detJ = calcularDeterminanteJacobiano(x, y);
      analisis['determinante_jacobiano'] = MethodUtils.redondear(detJ, dn);
      double f1Inicial = parser.evaluar2Variables(function1, x, y);
      double f2Inicial = parser.evaluar2Variables(function2, x, y);
      analisis['f1(punto_inicial)'] = MethodUtils.redondear(f1Inicial, dn);
      analisis['f2(punto_inicial)'] = MethodUtils.redondear(f2Inicial, dn);
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
        analisis['solucion_final'] = '(${MethodUtils.redondear(x, dn)}, ${MethodUtils.redondear(y, dn)})';
        double f1Final = parser.evaluar2Variables(function1, x, y);
        double f2Final = parser.evaluar2Variables(function2, x, y);
        double errorRaiz = max(f1Final.abs(), f2Final.abs());
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
        'f1(x,y) = 0': function1,
        'f2(x,y) = 0': function2
      };
      
      info['matriz_jacobiana'] = {
        'df1/dx': df1dx,
        'df1/dy': df1dy,
        'df2/dx': df2dx,
        'df2/dy': df2dy
      };
      
      info['variables_detectadas_f1'] = parser.encontrarVariables(function1).toList();
      info['variables_detectadas_f2'] = parser.encontrarVariables(function2).toList();
      double f1ValorInicial = parser.evaluar2Variables(function1, x, y);
      double f2ValorInicial = parser.evaluar2Variables(function2, x, y);
      
      info['evaluacion_inicial'] = {
        'f1($x, $y)': MethodUtils.redondear(f1ValorInicial, dn),
        'f2($x, $y)': MethodUtils.redondear(f2ValorInicial, dn)
      };
      double normaFuncion = sqrt(f1ValorInicial * f1ValorInicial + f2ValorInicial * f2ValorInicial);
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
      'df1dx': df1dx,
      'df1dy': df1dy,
      'df2dx': df2dx,
      'df2dy': df2dy,
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
                    'Función f1(x,y): $function1\n'
                    'Función f2(x,y): $function2\n'
                    'Punto inicial: (${MethodUtils.redondear(x, dn)}, ${MethodUtils.redondear(y, dn)})\n'
                    'Tolerancia: $tol\n'
                    'Iteraciones máximas: $n';
    
    if (success) {
      summary += '\nSolución encontrada: (${MethodUtils.redondear(x, dn)}, ${MethodUtils.redondear(y, dn)})';
      try {
        double f1Final = parser.evaluar2Variables(function1, x, y);
        double f2Final = parser.evaluar2Variables(function2, x, y);
        double errorSol = max(f1Final.abs(), f2Final.abs());
        summary += '\nError de la solución: ${MethodUtils.redondear(errorSol, dn)}';
      } catch (e) {
        summary += '\nNo se pudo verificar la solución';
      }
    }
    
    return summary;
  }
  
  String getMethodDescription() {
    return '''
Propósito: Resolver sistemas de ecuaciones no lineales:
f(x,y)=0,g(x,y)=0

Fundamento: Generalización multivariable del método de Newton-Raphson. Utiliza linearización mediante expansión en serie de Taylor, requiriendo el cálculo de derivadas parciales.

Algoritmo: En cada iteración:

1. Se evalúa la matriz Jacobiana

2. Se resuelve el sistema lineal

3. Se actualizan los valores

Convergencia: Cuadrática si el punto inicial está cerca de la raíz y el Jacobiano es invertible.
''';
  }
}