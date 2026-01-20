import 'dart:math';
import 'MethodClass.Dart';
import 'MethodUtils.Dart';

/// Implementación del método de diferencias divididas de Newton para interpolación
class DividedDifferencesNewtonClass extends MethodClass {
  int n;
  double c;
  int dn;
  List<List<double>> dataTable;
  List<List<double>> differencesTable;
  String polynomial;
  List<double> coefficients;

  DividedDifferencesNewtonClass({
    this.n = 0,
    this.c = 0.0,
    this.dn = 0,
    this.dataTable = const [],
    this.differencesTable = const [],
    this.polynomial = "",
    this.coefficients = const [],
    int id = 8,
    String title = "Diferencias Divididas de Newton",
    String subtitle = "Interpolación polinómica con diferencias divididas",
    String index = "DDN",
  }) {
    this.id = id;
    this.title = title;
    this.subtitle = subtitle;
    this.index = index;
  }

  @override
  void initialize() {
    super.initialize();
    differencesTable = [];
    polynomial = "";
    coefficients = [];
  }

  String? validarParametros() {
    if (n <= 0) {
      return "Error: el número de puntos debe ser mayor a 0";
    }
    
    if (n > 8) {
      return "Error: el número de puntos debe ser menor o igual a 8";
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

  void dividedDifferencesMethod() {
    initialize();
    
    try {
      String? error = validarParametros();
      if (error != null) {
        message = error;
        return;
      }

      List<double> xx = List.filled(n, 0.0);
      List<double> temp = List.filled(n, 0.0);
      List<List<double>> q = List.generate(n, (_) => List.filled(n, 0.0));

      for (int count = 0; count < n; count++) {
        xx[count] = dataTable[count][1];
        temp[count] = dataTable[count][2];
      }

      for (int i = 0; i < n; i++) {
        q[i][0] = temp[i];
      }

      for (int i = 1; i < n; i++) {
        for (int j = 1; j <= i; j++) {
          double numerator = q[i][j-1] - q[i-1][j-1];
          double denominator = xx[i] - xx[i-j];
          
          if (denominator.abs() < 1e-15) {
            message = "Error: división por cero en el cálculo de diferencias divididas (denominador muy pequeño)";
            return;
          }
          
          q[i][j] = numerator / denominator;
        }
      }

      differencesTable = [];
      for (int i = 0; i < n; i++) {
        List<double> row = [];
        for (int j = 0; j <= i; j++) {
          row.add(q[i][j]);
        }
        differencesTable.add(row);
      }

      coefficients = [];
      for (int i = 0; i < n; i++) {
        coefficients.add(q[i][i]);
      }

      double p = _calcularPolinomioEnPunto(xx, coefficients, c);

      polynomial = _construirPolinomioNewton(xx, coefficients);

      result = MethodUtils.redondear(p, dn);
      success = true;
      iterations = n;
      message = "Interpolación con diferencias divididas completada exitosamente\n"
                "P(${MethodUtils.redondear(c, dn)}) = ${MethodUtils.redondear(p, dn)}\n"
                "Polinomio de grado ${n-1} construido";
      
    } catch (e) {
      message = "Error durante la interpolación: ${e.toString()}";
      success = false;
    }
  }

  double _calcularPolinomioEnPunto(List<double> xx, List<double> coefs, double punto) {
    double p = 0.0;
    
    for (int i = 0; i < n; i++) {
      double producto = coefs[i];
      for (int j = 0; j < i; j++) {
        producto *= (punto - xx[j]);
      }
      p += producto;
    }
    
    return p;
  }

  String _construirPolinomioNewton(List<double> xx, List<double> coefs) {
    if (n == 0) return "P(x) = 0";
    
    String polinomio = "P(x) = ${_formatearCoeficiente(coefs[0], 0)}";
    
    for (int i = 1; i < n; i++) {
      if (coefs[i].abs() < 1e-10) continue;
      
      String termino = _formatearCoeficiente(coefs[i], i);
      String factores = "";
      
      for (int j = 0; j < i; j++) {
        factores += "(x - ${MethodUtils.redondear(xx[j], dn)})";
        if (j < i - 1) factores += " * ";
      }
      
      if (coefs[i] >= 0) {
        polinomio += " + ";
      } else {
        polinomio += " - ";
      }
      
      polinomio += "${termino}";
      if (factores.isNotEmpty) {
        polinomio += " * $factores";
      }
    }
    
    return polinomio;
  }

  String _formatearCoeficiente(double coef, int index) {
    if (index == 0) {
      return MethodUtils.redondear(coef, dn).toString();
    }
    
    double absCoef = coef.abs();
    if (absCoef == 1.0) {
      return "";
    } else {
      return MethodUtils.redondear(absCoef, dn).toString();
    }
  }

  List<List<String>> obtenerTablaDiferencias() {
    List<List<String>> tabla = [];
    
    if (differencesTable.isEmpty) return tabla;

    List<String> encabezados = ["i", "xi", "f[xi]"];
    for (int i = 1; i < n; i++) {
      encabezados.add("Orden $i");
    }
    tabla.add(encabezados);

    for (int i = 0; i < n; i++) {
      List<String> fila = [
        i.toString(),
        MethodUtils.redondear(dataTable[i][1], dn).toString(),
        MethodUtils.redondear(differencesTable[i][0], dn).toString()
      ];

      for (int j = 1; j <= i; j++) {
        fila.add(MethodUtils.redondear(differencesTable[i][j], dn).toString());
      }

      for (int j = i + 1; j < n; j++) {
        fila.add("");
      }
      
      tabla.add(fila);
    }
    
    return tabla;
  }

  double evaluarEnPunto(double punto) {
    if (dataTable.isEmpty || coefficients.isEmpty) return double.nan;
    
    List<double> xx = [];
    for (int i = 0; i < dataTable.length; i++) {
      xx.add(dataTable[i][1]);
    }
    
    return _calcularPolinomioEnPunto(xx, coefficients, punto);
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

  List<double> obtenerCoeficientesEstandar() {
    if (dataTable.isEmpty || coefficients.isEmpty) return [];
    
    List<double> xx = [];
    for (int i = 0; i < dataTable.length; i++) {
      xx.add(dataTable[i][1]);
    }
    
    List<double> coefEstandar = List.filled(n, 0.0);

    coefEstandar[0] += coefficients[0];
    
    for (int i = 1; i < n; i++) {
      _expandirProductoPolinomio(xx, i, coefficients[i], coefEstandar);
    }
    
    return coefEstandar;
  }

  void _expandirProductoPolinomio(List<double> xx, int k, double coeficiente, List<double> coefEstandar) {
    List<double> producto = [1.0];
    
    for (int i = 0; i < k; i++) {
      List<double> nuevoProducto = List.filled(producto.length + 1, 0.0);
      
      for (int j = 0; j < producto.length; j++) {
        nuevoProducto[j] += producto[j];
        nuevoProducto[j+1] += producto[j] * (-xx[i]);
      }
      
      producto = nuevoProducto;
    }

    for (int i = 0; i < producto.length; i++) {
      if (i < coefEstandar.length) {
        coefEstandar[i] += coeficiente * producto[i];
      }
    }
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
      
      analisis['rango_x'] = '${MethodUtils.redondear(x.reduce(min), dn)} a ${MethodUtils.redondear(x.reduce(max), dn)}';
      analisis['rango_y'] = '${MethodUtils.redondear(y.reduce(min), dn)} a ${MethodUtils.redondear(y.reduce(max), dn)}';
      analisis['numero_puntos'] = n;
      analisis['grado_polinomio'] = n - 1;

      double errorMaximo = 0.0;
      for (int i = 0; i < x.length; i++) {
        double valorInterpolado = evaluarEnPunto(x[i]);
        double error = (valorInterpolado - y[i]).abs();
        errorMaximo = max(errorMaximo, error);
      }
      
      analisis['error_maximo_puntos_conocidos'] = MethodUtils.redondear(errorMaximo, dn);
      analisis['interpolacion_exacta'] = errorMaximo < 1e-10;

      if (coefficients.isNotEmpty) {
        analisis['coeficientes'] = coefficients.map((c) => MethodUtils.redondear(c, dn)).toList();
        analisis['primer_coeficiente'] = MethodUtils.redondear(coefficients[0], dn);
        analisis['ultimo_coeficiente'] = MethodUtils.redondear(coefficients[n-1], dn);
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
      'differencesTable': differencesTable,
      'polynomial': polynomial,
      'coefficients': coefficients,
    });
    return json;
  }

  @override
  String getResultSummary() {
    String summary = '${super.getResultSummary()}\n'
                    'Número de puntos: $n\n'
                    'Punto de interpolación (c): ${MethodUtils.redondear(c, dn)}\n'
                    'P(c) = ${MethodUtils.redondear(result, dn)}\n'
                    'Grado del polinomio: ${n-1}';
    
    if (coefficients.isNotEmpty) {
      summary += '\nCoeficiente principal: ${MethodUtils.redondear(coefficients[n-1], dn)}';
    }
    
    return summary;
  }

  String getMethodDescription() {
    return '''
Propósito: Construir el polinomio interpolador de forma eficiente y recursiva.

Fundamento: Organiza las diferencias divididas en una tabla triangular, donde cada nivel representa el coeficiente del polinomio de Newton.

Fórmula del Polinomio:
P_n(x) = f[x_0] + fx_0,x_1 + fx_0,x_1,x_2(x-x_1) + ⋯

Cálculo Recursivo:
f[x_i] = f(x_i)
f[x_i,...,x_j] = (f[x_{i=1},...,x_j] - f[x_i,...,x_{j-1}]) / (x_j - x_i)

Ventaja: Permite añadir nuevos puntos fácilmente sin recalcular todo el polinomio.
''';
  }
}