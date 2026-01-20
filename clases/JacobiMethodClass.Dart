import 'dart:math';
import 'MethodClass.Dart';
import 'MethodUtils.Dart';

/// Implementación del método de Jacobi para resolver sistemas de ecuaciones lineales
class JacobiMethodClass extends MethodClass {
  int n_data;
  double tol;
  int n;
  int dn;
  List<double> coefs;
  List<List<double>> resultTable;
  List<List<double>> matrix;
  List<double> initialVector;

  JacobiMethodClass({
    this.n_data = 0,
    this.tol = 0.0,
    this.n = 0,
    this.dn = 0,
    this.coefs = const [],
    this.resultTable = const [],
    this.matrix = const [],
    this.initialVector = const [],
    int id = 9,
    String title = "Método de Jacobi",
    String subtitle = "Resolución iterativa de sistemas de ecuaciones",
    String index = "JAC",
  }) {
    this.id = id;
    this.title = title;
    this.subtitle = subtitle;
    this.index = index;
  }

  @override
  void initialize() {
    super.initialize();
    resultTable = [];
    coefs = [];
  }

  String? validarParametros() {
    if (n <= 0) {
      return "Error: el número de ecuaciones debe ser mayor a 0";
    }
    
    if (n > 10) {
      return "Error: el número de ecuaciones debe ser menor o igual a 10";
    }
    
    if (matrix.isEmpty) {
      return "Error: debe cargar la matriz aumentada primero";
    }
    
    if (matrix.length != n) {
      return "Error: la matriz debe tener $n filas";
    }
    
    for (int i = 0; i < n; i++) {
      if (matrix[i].length != n + 1) {
        return "Error: cada fila de la matriz debe tener ${n + 1} columnas (coeficientes + término independiente)";
      }
    }
    
    if (initialVector.isEmpty) {
      return "Error: debe proporcionar un vector inicial";
    }
    
    if (initialVector.length != n) {
      return "Error: el vector inicial debe tener $n componentes";
    }
    
    if (tol <= 0) {
      return "Error: la tolerancia debe ser mayor que 0";
    }
    
    if (!_esDiagonalmenteDominante()) {
      message = "Advertencia: La matriz no es diagonalmente dominante. La convergencia no está garantizada.\n";
    }
    
    return null;
  }

  bool _esDiagonalmenteDominante() {
    for (int i = 0; i < n; i++) {
      double suma = 0.0;
      for (int j = 0; j < n; j++) {
        if (i != j) {
          suma += matrix[i][j].abs();
        }
      }
      if (matrix[i][i].abs() <= suma) {
        return false;
      }
    }
    return true;
  }

  void jacobiMethod() {
    initialize();
    
    try {
      String? error = validarParametros();
      if (error != null) {
        message = error;
        return;
      }
      List<List<double>> A = List.generate(n, (i) => List<double>.from(matrix[i].sublist(0, n)));
      List<double> b = List.generate(n, (i) => matrix[i][n]);
      List<double> x1 = List.from(initialVector);
      List<double> x2 = List.filled(n, 0.0);
      
      int iteracion = 1;
      bool convergio = false;
      double errorGlobal = 0.0;
      resultTable = [];
      
      while (iteracion <= n_data && !convergio) {
        errorGlobal = 0.0;
        for (int i = 0; i < n; i++) {
          double suma = 0.0;
          
          for (int j = 0; j < n; j++) {
            if (i != j) {
              suma += A[i][j] * x1[j];
            }
          }
          x2[i] = (b[i] - suma) / A[i][i];
          double errorVariable = (x2[i] - x1[i]).abs();
          if (errorVariable > errorGlobal) {
            errorGlobal = errorVariable;
          }
        }

        List<double> filaResultado = [iteracion.toDouble()];
        filaResultado.addAll(x2);
        filaResultado.addAll(List.generate(n, (i) => (x2[i] - x1[i]).abs()));
        filaResultado.add(errorGlobal);
        
        resultTable.add(filaResultado);
        
        if (errorGlobal <= tol) {
          convergio = true;
          success = true;
          iterations = iteracion;
          message = "Error final: ${MethodUtils.redondear(errorGlobal, dn)}";
        } else {
          for (int i = 0; i < n; i++) {
            x1[i] = x2[i];
          }
          iteracion++;
        }
      }

      if (!convergio) {
        success = false;
        iterations = n_data;
        message = "Máximo de iteraciones ($n_data) alcanzado sin convergencia\n"
                  "Error final: ${MethodUtils.redondear(errorGlobal, dn)}";
      }

      coefs = x2;
      result = errorGlobal;
      
    } catch (e) {
      message = "Error durante la ejecución del método de Jacobi: ${e.toString()}";
      success = false;
    }
  }

  List<List<String>> obtenerTablaResultados() {
    List<List<String>> tabla = [];
    
    if (resultTable.isEmpty) return tabla;

    List<String> encabezados = ["Iteración"];
    for (int i = 0; i < n; i++) {
      encabezados.add("x${i+1}");
    }
    for (int i = 0; i < n; i++) {
      encabezados.add("Error x${i+1}");
    }
    encabezados.add("Error Global");
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

  List<String> obtenerSolucion() {
    List<String> solucion = [];
    
    for (int i = 0; i < coefs.length; i++) {
      solucion.add("x${i+1} = ${MethodUtils.redondear(coefs[i], dn)}");
    }
    
    return solucion;
  }

  List<double> calcularErroresResiduales() {
    List<double> errores = [];
    
    if (matrix.isEmpty || coefs.isEmpty) return errores;
    
    for (int i = 0; i < n; i++) {
      double suma = 0.0;
      for (int j = 0; j < n; j++) {
        suma += matrix[i][j] * coefs[j];
      }
      double error = (suma - matrix[i][n]).abs();
      errores.add(error);
    }
    
    return errores;
  }

  Map<String, dynamic> analizarConvergencia() {
    Map<String, dynamic> analisis = {};
    
    try {
      if (matrix.isEmpty) {
        analisis['error'] = 'No hay matriz para analizar';
        return analisis;
      }
      
      analisis['diagonalmente_dominante'] = _esDiagonalmenteDominante();
      analisis['numero_ecuaciones'] = n;
      analisis['tolerancia'] = tol;
      analisis['iteraciones_maximas'] = n_data;

      double radioEspectral = _calcularRadioEspectralAproximado();
      analisis['radio_espectral_aproximado'] = MethodUtils.redondear(radioEspectral, dn);
      
      if (radioEspectral < 1) {
        analisis['convergencia_garantizada'] = true;
        analisis['tipo_convergencia'] = 'Lineal';
      } else {
        analisis['convergencia_garantizada'] = false;
        analisis['tipo_convergencia'] = 'No garantizada';
      }

      if (coefs.isNotEmpty) {
        analisis['solucion_encontrada'] = success;
        analisis['iteraciones_realizadas'] = iterations;
        
        List<double> erroresResiduales = calcularErroresResiduales();
        double errorMaximoResidual = erroresResiduales.reduce(max);
        analisis['error_residual_maximo'] = MethodUtils.redondear(errorMaximoResidual, dn);
      }
      
    } catch (e) {
      analisis['error'] = e.toString();
    }
    
    return analisis;
  }

  double _calcularRadioEspectralAproximado() {
    double norma = 0.0;
    
    for (int i = 0; i < n; i++) {
      double suma = 0.0;
      for (int j = 0; j < n; j++) {
        if (i != j) {
          suma += matrix[i][j].abs() / matrix[i][i].abs();
        }
      }
      if (suma > norma) {
        norma = suma;
      }
    }
    
    return norma;
  }

  void crearMatrizVacia() {
    matrix.clear();
    
    for (int i = 0; i < n; i++) {
      List<double> fila = List.filled(n + 1, 0.0);
      matrix.add(fila);
    }

    initialVector = List.filled(n, 0.0);
  }

  void establecerVectorInicial(String vectorStr) {
    try {
      List<String> componentes = vectorStr.split(',');
      if (componentes.length != n) {
        throw Exception("El vector inicial debe tener $n componentes");
      }
      
      initialVector = componentes.map((c) => double.parse(c.trim())).toList();
    } catch (e) {
      throw Exception("Error al parsear el vector inicial: ${e.toString()}");
    }
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json.addAll({
      'n_data': n_data,
      'tol': tol,
      'n': n,
      'dn': dn,
      'coefs': coefs,
      'resultTable': resultTable,
      'matrix': matrix,
      'initialVector': initialVector,
    });
    return json;
  }

  @override
  String getResultSummary() {
    String summary = '${super.getResultSummary()}\n'
                    'Número de ecuaciones: $n\n'
                    'Tolerancia: $tol\n'
                    'Iteraciones máximas: $n_data';
    
    if (success && coefs.isNotEmpty) {
      summary += '\nSolución:';
      for (int i = 0; i < coefs.length; i++) {
        summary += '\nx${i+1} = ${MethodUtils.redondear(coefs[i], dn)}';
      }
    }
    
    return summary;
  }

  String getMethodDescription() {
    return '''
Propósito: Resolver sistemas de ecuaciones lineales Ax = b de forma iterativa.

Fundamento: Descompone la matriz A en su diagonal (D), triangular inferior (L) y superior (U). En cada iteración, despeja cada variable utilizando los valores de la iteración anterior.

Condición: Converge si la matriz A es estrictamente diagonal dominante o simétrica definida positiva.

Característica: Fácil de implementar pero lenta. Paralelizable ya que cada variable se actualiza independientemente.
''';
  }

  List<double> obtenerErroresFinales() {
    if (resultTable.isEmpty) return [];
    
    List<double> ultimaFila = resultTable.last;
    return ultimaFila.sublist(n + 1, 2 * n + 1);
  }
  List<Map<String, double>> obtenerHistorialConvergencia() {
    List<Map<String, double>> historial = [];
    
    for (int i = 0; i < resultTable.length; i++) {
      double iteracion = resultTable[i][0];
      double errorGlobal = resultTable[i].last;
      
      historial.add({
        'iteracion': iteracion,
        'error': errorGlobal
      });
    }
    
    return historial;
  }
}