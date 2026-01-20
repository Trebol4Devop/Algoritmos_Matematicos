import 'dart:math';
import 'MethodClass.Dart';
import 'MethodUtils.Dart';

/// Implementación del método de Neville para interpolación polinómica
class NevilleMethodClass extends MethodClass {
  int n;
  double c;
  int dn;
  List<List<double>> dataTable;
  List<List<double>> nevilleTable;
  List<String> resultMatrix;

  NevilleMethodClass({
    this.n = 0,
    this.c = 0.0,
    this.dn = 0,
    this.dataTable = const [],
    this.nevilleTable = const [],
    this.resultMatrix = const [],
    int id = 7,
    String title = "Método de Neville",
    String subtitle = "Interpolación polinómica iterativa",
    String index = "NEV",
  }) {
    this.id = id;
    this.title = title;
    this.subtitle = subtitle;
    this.index = index;
  }

  @override
  void initialize() {
    super.initialize();
    nevilleTable = [];
    resultMatrix = [];
  }

  String? validarParametros() {
    if (n <= 0) {
      return "Error: el número de puntos debe ser mayor a 0";
    }
    
    if (n > 25) {
      return "Error: el número de puntos debe ser menor o igual a 25";
    }
    
    if (dataTable.isEmpty) {
      return "Error: debe cargar la tabla de datos primero";
    }
    
    if (dataTable.length != n) {
      return "Error: la tabla debe tener exactamente $n puntos";
    }
    
    for (int i = 0; i < dataTable.length; i++) {
      if (dataTable[i].length < 3) {
        return "Error: la fila $i de la tabla no tiene suficientes datos";
      }
    }
    
    return null;
  }

  void nevilleMethod() {
    initialize();
    
    try {
      String? error = validarParametros();
      if (error != null) {
        message = error;
        return;
      }
      List<double> xx = List.filled(26, 0.0);
      List<double> temp = List.filled(26, 0.0);
      List<List<double>> q = List.generate(26, (_) => List.filled(26, 0.0));
      List<double> d = List.filled(26, 0.0);

      for (int count = 0; count < n; count++) {
        xx[count] = dataTable[count][1];
        temp[count] = dataTable[count][2];
      }
      for (int i = 0; i < n; i++) {
        q[i][0] = temp[i];
      }
      d[0] = c - xx[0];
      for (int i = 1; i < n; i++) {
        d[i] = c - xx[i];
        for (int j = 1; j <= i; j++) {
          double numerator = d[i] * q[i-1][j-1] - d[i-j] * q[i][j-1];
          double denominator = d[i] - d[i-j];
          
          if (denominator.abs() < 1e-15) {
            message = "Error: división por cero en el cálculo de Neville (denominador muy pequeño)";
            return;
          }
          
          q[i][j] = numerator / denominator;
        }
      }
      
      nevilleTable = [];
      for (int i = 0; i < n; i++) {
        List<double> row = [];
        for (int j = 0; j <= i; j++) {
          row.add(q[i][j]);
        }
        nevilleTable.add(row);
      }
      resultMatrix = _construirMatrizResultados(xx, q);
      double resultadoFinal = q[n-1][n-1];
      result = MethodUtils.redondear(resultadoFinal, dn);
      success = true;
      iterations = n;
      message = "Interpolación de Neville completada exitosamente\n"
                "P(${MethodUtils.redondear(c, dn)}) = ${MethodUtils.redondear(resultadoFinal, dn)}\n"
                "Usando $n puntos de interpolación";
      
    } catch (e) {
      message = "Error durante la interpolación de Neville: ${e.toString()}";
      success = false;
    }
  }

  List<String> _construirMatrizResultados(List<double> xx, List<List<double>> q) {
    List<String> matriz = [];
    List<String> encabezados = ["n", "xo"];
    for (int i = 0; i < n; i++) {
      encabezados.add("Qo,${i}");
    }
    
    for (int i = 0; i < n; i++) {
      String fila = "${i} | ${MethodUtils.redondear(xx[i], dn)}";
      
      for (int j = 0; j <= i; j++) {
        fila += " | ${MethodUtils.redondear(q[i][j], dn)}";
      }
      for (int j = i + 1; j < n; j++) {
        fila += " | -";
      }
      
      matriz.add(fila);
    }
    
    return matriz;
  }

  List<List<String>> obtenerTablaResultados() {
    List<List<String>> tabla = [];
    
    if (nevilleTable.isEmpty) return tabla;
    List<String> encabezados = ["i", "xᵢ"];
    for (int i = 0; i < n; i++) {
      encabezados.add("Q[$i,$i]");
    }
    tabla.add(encabezados);
    for (int i = 0; i < n; i++) {
      List<String> fila = [
        i.toString(),
        MethodUtils.redondear(dataTable[i][1], dn).toString()
      ];
      
      for (int j = 0; j <= i; j++) {
        fila.add(MethodUtils.redondear(nevilleTable[i][j], dn).toString());
      }
      for (int j = i + 1; j < n; j++) {
        fila.add("");
      }
      
      tabla.add(fila);
    }
    
    return tabla;
  }

  String obtenerPolinomioInterpolante() {
    if (nevilleTable.isEmpty) return "No hay datos disponibles";
    return "P(x) = ${MethodUtils.redondear(result, dn)} (valor interpolado en x = ${MethodUtils.redondear(c, dn)})";
  }
  double evaluarEnPunto(double punto) {
    if (dataTable.isEmpty) return double.nan;
    
    List<double> xx = [];
    List<double> temp = [];
    
    for (int i = 0; i < n; i++) {
      xx.add(dataTable[i][1]);
      temp.add(dataTable[i][2]);
    }
    
    List<List<double>> q = List.generate(n, (_) => List.filled(n, 0.0));
    for (int i = 0; i < n; i++) {
      q[i][0] = temp[i];
    }
    for (int i = 1; i < n; i++) {
      for (int j = 1; j <= i; j++) {
        double numerador = (punto - xx[i]) * q[i-1][j-1] - (punto - xx[i-j]) * q[i][j-1];
        double denominador = xx[i-j] - xx[i];
        q[i][j] = numerador / denominador;
      }
    }
    
    return q[n-1][n-1];
  }

  List<Map<String, double>> obtenerPuntosPolinomio({int numPuntos = 100}) {
    if (dataTable.isEmpty) return [];
    
    List<double> xValues = [];
    for (int i = 0; i < dataTable.length; i++) {
      xValues.add(dataTable[i][1]);
    }
    
    double minX = xValues.reduce(min);
    double maxX = xValues.reduce(max);
    double margen = (maxX - minX) * 0.2;
    
    List<Map<String, double>> puntos = [];
    double paso = (maxX + margen - (minX - margen)) / numPuntos;
    
    for (int i = 0; i <= numPuntos; i++) {
      double x = minX - margen + i * paso;
      double y = evaluarEnPunto(x);
      
      if (!y.isNaN && !y.isInfinite) {
        puntos.add({'x': x, 'y': y});
      }
    }
    
    return puntos;
  }

  List<Map<String, double>> obtenerPuntosOriginales() {
    List<Map<String, double>> puntos = [];
    
    for (int i = 0; i < dataTable.length; i++) {
      if (dataTable[i].length >= 3) {
        puntos.add({
          'x': dataTable[i][1],
          'y': dataTable[i][2],
          'index': i.toDouble()
        });
      }
    }
    
    return puntos;
  }
  
  void crearTablaVacia() {
    dataTable.clear();
    
    for (int i = 0; i < n; i++) {
      dataTable.add([i.toDouble(), 0.0, 0.0]);
    }
  }
  Map<String, dynamic> analizarInterpolacion() {
    Map<String, dynamic> analisis = {};
    
    try {
      if (dataTable.isEmpty) {
        analisis['error'] = 'No hay datos para analizar';
        return analisis;
      }
      
      List<double> x = [];
      List<double> y = [];
      
      for (int i = 0; i < dataTable.length; i++) {
        x.add(dataTable[i][1]);
        y.add(dataTable[i][2]);
      }
      bool igualmenteEspaciados = true;
      if (x.length > 2) {
        double espacio = x[1] - x[0];
        for (int i = 2; i < x.length; i++) {
          if ((x[i] - x[i-1] - espacio).abs() > 1e-10) {
            igualmenteEspaciados = false;
            break;
          }
        }
      }
      
      analisis['puntos_igualmente_espaciados'] = igualmenteEspaciados;
      analisis['rango_x'] = '${MethodUtils.redondear(x.reduce(min), dn)} a ${MethodUtils.redondear(x.reduce(max), dn)}';
      analisis['rango_y'] = '${MethodUtils.redondear(y.reduce(min), dn)} a ${MethodUtils.redondear(y.reduce(max), dn)}';
      analisis['numero_puntos'] = n;
      double errorMaximo = 0.0;
      for (int i = 0; i < x.length; i++) {
        double valorInterpolado = evaluarEnPunto(x[i]);
        double error = (valorInterpolado - y[i]).abs();
        errorMaximo = max(errorMaximo, error);
      }
      
      analisis['error_maximo_puntos_conocidos'] = MethodUtils.redondear(errorMaximo, dn);
      analisis['interpolacion_exacta'] = errorMaximo < 1e-10;
      if (nevilleTable.isNotEmpty) {
        analisis['valor_interpolado'] = MethodUtils.redondear(result, dn);
        analisis['ultimo_valor_Q'] = MethodUtils.redondear(nevilleTable[n-1][n-1], dn);
      }
      
    } catch (e) {
      analisis['error'] = e.toString();
    }
    
    return analisis;
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json.addAll({
      'n': n,
      'c': c,
      'dn': dn,
      'dataTable': dataTable,
      'nevilleTable': nevilleTable,
      'resultMatrix': resultMatrix,
    });
    return json;
  }

  @override
  String getResultSummary() {
    String summary = '${super.getResultSummary()}\n'
                    'Número de puntos: $n\n'
                    'Punto de interpolación (c): ${MethodUtils.redondear(c, dn)}\n'
                    'P(c) = ${MethodUtils.redondear(result, dn)}';
    
    if (nevilleTable.isNotEmpty && n > 0) {
      summary += '\nValor Q[${n-1},${n-1}]: ${MethodUtils.redondear(nevilleTable[n-1][n-1], dn)}';
    }
    
    return summary;
  }

  String getMethodDescription() {
    return '''
Propósito: Evaluar el polinomio interpolador en un punto específico sin construir el polinomio completo.

Fundamento: Algoritmo recursivo que calcula el valor interpolado combinando sistemáticamente interpolaciones lineales de pares de puntos.

Proceso Clave: Construye una tabla triangular donde cada entrada se obtiene como una combinación lineal de las dos entradas anteriores, ponderadas por las distancias al punto de evaluación.

Fórmula Recursiva:
P{i,j} = [(x - x_i)P_{i+1},{j-1} - (x - x_{i+j})P_{i,j-1}] / (x_{i+j} - x_{i})

Resultado: El valor en la esquina superior de la tabla (P_{0,n}) proporciona el valor interpolado en x.

Ventaja: Eficiente para evaluación puntual y numéricamente estable.
''';
  }
}
