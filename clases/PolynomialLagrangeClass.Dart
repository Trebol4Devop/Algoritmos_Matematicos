import 'dart:math';
import 'MethodClass.Dart';
import 'MethodUtils.Dart';

/// Implementación del método de interpolación de Lagrange
class PolynomialLagrangeClass extends MethodClass {
  int n;
  double f_c;
  double c;
  int dn;
  List<List<double>> dataTable;
  String polynomial;

  PolynomialLagrangeClass({
    this.n = 0,
    this.f_c = 0.0,
    this.c = 0.0,
    this.dn = 0,
    this.dataTable = const [],
    this.polynomial = "",
    int id = 6,
    String title = "Interpolación de Lagrange",
    String subtitle = "Construye polinomios de interpolación",
    String index = "LAG",
  }) {
    this.id = id;
    this.title = title;
    this.subtitle = subtitle;
    this.index = index;
  }

  @override
  void initialize() {
    super.initialize();
    f_c = 0.0;
    polynomial = "";
  }

  /// Valida los parámetros de entrada
  String? validarParametros() {
    if (n <= 0) {
      return "Error: el grado del polinomio debe ser mayor a 0";
    }
    
    if (n > 8) {
      return "Error: el grado del polinomio debe ser menor o igual a 8";
    }
    
    if (dataTable.isEmpty) {
      return "Error: debe cargar la tabla de datos primero";
    }
    
    if (dataTable.length != n + 1) {
      return "Error: la tabla debe tener exactamente ${n + 1} puntos";
    }
    
    // Validar que todos los puntos tengan valores válidos
    for (int i = 0; i < dataTable.length; i++) {
      if (dataTable[i].length < 3) {
        return "Error: la fila $i de la tabla no tiene suficientes datos";
      }
    }
    
    return null;
  }

  /// Calcula el valor del polinomio de Lagrange en el punto c
  void polynomialLagrangeMethod() {
    initialize();
    
    try {
      // Validar parámetros
      String? error = validarParametros();
      if (error != null) {
        message = error;
        return;
      }
      
      // Extraer arrays de x e y
      List<double> arrayx = [];
      List<double> arrayy = [];
      
      for (int i = 0; i <= n; i++) {
        arrayx.add(dataTable[i][1]); // x en columna 1
        arrayy.add(dataTable[i][2]); // y en columna 2
      }
      
      // Verificar que el punto c esté en un rango razonable
      double minX = arrayx.reduce(min);
      double maxX = arrayx.reduce(max);
      
      if (c < minX - 1 || c > maxX + 1) {
        message = "Advertencia: el punto c está fuera del rango de interpolación";
      }
      
      // Calcular el valor del polinomio de Lagrange en c
      double y = 0.0;
      
      for (int count = 0; count <= n; count++) {
        double numerator = 1.0;
        double denominator = 1.0;
        
        for (int count2 = 0; count2 <= n; count2++) {
          if (count2 != count) {
            numerator *= (c - arrayx[count2]);
            denominator *= (arrayx[count] - arrayx[count2]);
          }
        }
        
        y += (numerator / denominator) * arrayy[count];
      }
      
      // Construir la representación del polinomio
      polynomial = construirPolinomio(arrayx, arrayy);
      
      // Establecer resultados
      f_c = MethodUtils.redondear(y, dn);
      result = f_c;
      success = true;
      iterations = n + 1;
      message = "Interpolación completada exitosamente\n"
                "P({MethodUtils.redondear(c, dn)}) = {MethodUtils.redondear(y, dn)}\n"
                "Polinomio de grado $n";
      
    } catch (e) {
      message = "Error durante la interpolación: ${e.toString()}";
      success = false;
    }
  }

  /// Construye la representación en string del polinomio de Lagrange
  String construirPolinomio(List<double> x, List<double> y) {
    if (x.isEmpty || y.isEmpty) return "";
    
    // Para polinomios de grado bajo, podemos construir la representación
    if (n <= 3) {
      return _construirPolinomioExplicito(x, y);
    } else {
      return _construirPolinomioCompacto(x, y);
    }
  }

  /// Construye una representación explícita del polinomio (para grados bajos)
  String _construirPolinomioExplicito(List<double> x, List<double> y) {
    String polinomio = "";
    
    for (int i = 0; i <= n; i++) {
      if (y[i].abs() < 1e-10) continue;
      
      String termino = _construirTerminoLagrange(x, i);
      
      if (polinomio.isNotEmpty && y[i] >= 0) {
        polinomio += " + ";
      } else if (y[i] < 0) {
        polinomio += " - ";
      }
      
      double coeficiente = y[i].abs();
      if (coeficiente != 1.0 || termino.isEmpty) {
        polinomio += "${MethodUtils.redondear(coeficiente, dn)}";
        if (termino.isNotEmpty) polinomio += " * ";
      }
      
      polinomio += termino;
    }
    
    return polinomio.isEmpty ? "0" : polinomio;
  }

  /// Construye un término individual del polinomio de Lagrange
  String _construirTerminoLagrange(List<double> x, int index) {
    if (n == 0) return "";
    
    List<String> factores = [];
    
    for (int j = 0; j <= n; j++) {
      if (j != index) {
        String factor = "(x - ${MethodUtils.redondear(x[j], dn)})";
        factores.add(factor);
      }
    }
    
    if (factores.isEmpty) return "1";
    
    // Calcular denominador
    double denominador = 1.0;
    for (int j = 0; j <= n; j++) {
      if (j != index) {
        denominador *= (x[index] - x[j]);
      }
    }
    
    String resultado = factores.join(" * ");
    if (denominador != 1.0) {
      resultado = "($resultado) / ${MethodUtils.redondear(denominador, dn)}";
    }
    
    return resultado;
  }

  /// Construye una representación compacta del polinomio (para grados altos)
  String _construirPolinomioCompacto(List<double> x, List<double> y) {
    return "P(x) = Σ [yᵢ * Lᵢ(x)] para i = 0 to $n\n"
           "donde Lᵢ(x) = Π (x - xⱼ)/(xᵢ - xⱼ) para j ≠ i";
  }

  /// Obtiene puntos para graficar el polinomio interpolante
  List<Map<String, double>> obtenerPuntosPolinomio({int numPuntos = 100}) {
    if (dataTable.isEmpty) return [];
    
    List<double> arrayx = [];
    List<double> arrayy = [];
    
    for (int i = 0; i <= n; i++) {
      arrayx.add(dataTable[i][1]);
      arrayy.add(dataTable[i][2]);
    }
    
    double minX = arrayx.reduce(min);
    double maxX = arrayx.reduce(max);
    double margen = (maxX - minX) * 0.2;
    
    List<Map<String, double>> puntos = [];
    double paso = (maxX + margen - (minX - margen)) / numPuntos;
    
    for (int i = 0; i <= numPuntos; i++) {
      double x = minX - margen + i * paso;
      double y = _evaluarPolinomioEnPunto(arrayx, arrayy, x);
      
      if (!y.isNaN && !y.isInfinite) {
        puntos.add({'x': x, 'y': y});
      }
    }
    
    return puntos;
  }

  /// Evalúa el polinomio de Lagrange en un punto específico
  double _evaluarPolinomioEnPunto(List<double> x, List<double> y, double punto) {
    double resultado = 0.0;
    
    for (int i = 0; i <= n; i++) {
      double termino = y[i];
      
      for (int j = 0; j <= n; j++) {
        if (j != i) {
          termino *= (punto - x[j]) / (x[i] - x[j]);
        }
      }
      
      resultado += termino;
    }
    
    return resultado;
  }

  /// Obtiene los puntos originales de la tabla
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

  /// Crea una tabla de datos vacía basada en el grado n
  void crearTablaVacia() {
    dataTable.clear();
    
    for (int i = 0; i <= n; i++) {
      dataTable.add([i.toDouble(), 0.0, 0.0]);
    }
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json.addAll({
      'n': n,
      'f_c': f_c,
      'c': c,
      'dn': dn,
      'dataTable': dataTable,
      'polynomial': polynomial,
    });
    return json;
  }

  @override
  String getResultSummary() {
    String summary = '${super.getResultSummary()}\n'
                    'Grado del polinomio: $n\n'
                    'Punto de interpolación (c): ${MethodUtils.redondear(c, dn)}\n'
                    'P(c) = ${MethodUtils.redondear(f_c, dn)}';
    
    if (polynomial.isNotEmpty) {
      summary += '\nPolinomio: $polynomial';
    }
    
    return summary;
  }

  /// Analiza la calidad de la interpolación
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
      
      // Verificar si los puntos están igualmente espaciados
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
      
      // Calcular error en los puntos conocidos (debería ser cero)
      double errorMaximo = 0.0;
      for (int i = 0; i < x.length; i++) {
        double valorInterpolado = _evaluarPolinomioEnPunto(x, y, x[i]);
        double error = (valorInterpolado - y[i]).abs();
        errorMaximo = max(errorMaximo, error);
      }
      
      analisis['error_maximo_puntos_conocidos'] = MethodUtils.redondear(errorMaximo, dn);
      analisis['interpolacion_exacta'] = errorMaximo < 1e-10;
      
    } catch (e) {
      analisis['error'] = e.toString();
    }
    
    return analisis;
  }

  String getMethodDescription() {
    return '''
Propósito: Encontrar el polinomio único de grado mínimo que pasa exactamente por un conjunto de puntos dados (interpolación polinómica).

Fundamento: Construye el polinomio interpolador como una combinación lineal de polinomios base de Lagrange, donde cada polinomio base L_i(x) vale 1 en el punto x_1 y 0 en todos los demás puntos del conjunto.

Fórmula Central:
Para n puntos (x_i, y_i), el polinomio interpolador es:
P(x) = Sumatoria([y_i * L_i(x)])
donde L_i(x) = Multiplicatoria([(x - x_j) / (x_i - x_j)]) para j ≠ i

Característica Principal: Proporciona una forma explícita y directa del polinomio interpolador sin necesidad de resolver sistemas de ecuaciones. Cada polinomio base L_i(x) "se activa" solo en su punto correspondiente xᵢ.

Aplicación: Interpolación de datos, integración numérica (fórmula de Cuadratura de Gauss) y resolución de ecuaciones diferenciales.
''';
  }
}