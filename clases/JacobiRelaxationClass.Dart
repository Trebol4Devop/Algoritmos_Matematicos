import 'dart:math';
import 'MethodClass.Dart';
import 'MethodUtils.Dart';

/// Implementación del método de relajación de Jacobi para resolver sistemas de ecuaciones lineales
class JacobiRelaxationClass extends MethodClass {
  int n_data;
  double tol;
  int n;
  int dn;
  List<double> coefs;
  List<List<double>> resultTable;
  List<List<double>> matrix;
  List<double> initialVector;
  double omega;

  JacobiRelaxationClass({
    this.n_data = 0,
    this.tol = 0.0,
    this.n = 0,
    this.dn = 0,
    this.coefs = const [],
    this.resultTable = const [],
    this.matrix = const [],
    this.initialVector = const [],
    this.omega = 1.0,
    int id = 10,
    String title = "Método de Relajación de Jacobi",
    String subtitle = "Resolución iterativa con factor de relajación",
    String index = "JACR",
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
    
    if (omega <= 0) {
      return "Error: el factor de relajación omega debe ser mayor que 0";
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

  void jacobiRelaxationMethod() {
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
          double xJacobi = (b[i] - suma) / A[i][i];
          x2[i] = (1 - omega) * x1[i] + omega * xJacobi;
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
          message = "Error final: ${MethodUtils.redondear(errorGlobal, dn)}\n"
                    "Factor de relajación ω: ${MethodUtils.redondear(omega, dn)}";
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
                  "Error final: ${MethodUtils.redondear(errorGlobal, dn)}\n"
                  "Factor de relajación ω: ${MethodUtils.redondear(omega, dn)}";
      }
      coefs = x2;
      result = errorGlobal;
      
    } catch (e) {
      message = "Error durante la ejecución del método de relajación de Jacobi: ${e.toString()}";
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
      analisis['factor_relajacion'] = MethodUtils.redondear(omega, dn);
      double radioEspectral = _calcularRadioEspectralAproximado();
      analisis['radio_espectral_aproximado'] = MethodUtils.redondear(radioEspectral, dn);
      if (omega == 1.0) {
        analisis['tipo_metodo'] = 'Jacobi estándar';
      } else if (omega > 1.0) {
        analisis['tipo_metodo'] = 'Sobre-relajación (SOR)';
        analisis['recomendacion'] = 'ω > 1 puede acelerar convergencia para sistemas positivos definidos';
      } else {
        analisis['tipo_metodo'] = 'Sub-relajación';
        analisis['recomendacion'] = 'ω < 1 puede ayudar en sistemas oscilatorios';
      }
      
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
      double normaFila = omega * suma;
      if (i == n - 1) {
        normaFila = max(normaFila, (1 - omega).abs());
      }
      if (normaFila > norma) {
        norma = normaFila;
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
  void establecerFactorRelajacion(double omega) {
    if (omega <= 0) {
      throw Exception("El factor de relajación debe ser mayor que 0");
    }
    this.omega = omega;
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
      'omega': omega,
    });
    return json;
  }

  @override
  String getResultSummary() {
    String summary = '${super.getResultSummary()}\n'
                    'Número de ecuaciones: $n\n'
                    'Tolerancia: $tol\n'
                    'Iteraciones máximas: $n_data\n'
                    'Factor de relajación ω: ${MethodUtils.redondear(omega, dn)}';
    
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
Método de Relajación de Jacobi para sistemas de ecuaciones lineales:
- Método iterativo que modifica el método de Jacobi estándar con un factor de relajación ω
- Fórmula: x_i^(k+1) = x_i^k + ω * ((b_i - Σ_{j≠i} a_ij * x_j^k) / a_ii)
- Ventajas: Puede acelerar convergencia con ω > 1 (sobre-relajación)
- Para ω < 1 (sub-relajación) puede ayudar en sistemas oscilatorios
- Para ω = 1 se reduce al método de Jacobi estándar
- Criterio de parada: error máximo entre iteraciones < tolerancia
- Recomendación: ω entre 1.0 y 2.0 para sistemas positivos definidos
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
  Map<String, dynamic> optimizarFactorRelajacion() {
    Map<String, dynamic> resultado = {};
    List<Map<String, dynamic>> pruebas = [];
    
    if (matrix.isEmpty || initialVector.isEmpty) {
      resultado['error'] = 'No hay datos para optimizar';
      return resultado;
    }
    double omegaOriginal = omega;
    List<double> coefsOriginal = List.from(coefs);
    List<List<double>> resultTableOriginal = List.from(resultTable);
    bool successOriginal = success;
    int iterationsOriginal = iterations;
    List<double> valoresOmega = [0.5, 0.8, 1.0, 1.2, 1.5, 1.8];
    
    for (double omegaTest in valoresOmega) {
      omega = omegaTest;
      jacobiRelaxationMethod();
      
      pruebas.add({
        'omega': omegaTest,
        'convergio': success,
        'iteraciones': iterations,
        'error_final': result,
      });
    }
    omega = omegaOriginal;
    coefs = coefsOriginal;
    resultTable = resultTableOriginal;
    success = successOriginal;
    iterations = iterationsOriginal;
    Map<String, dynamic>? mejorPrueba;
    for (var prueba in pruebas) {
      if (prueba['convergio']) {
        if (mejorPrueba == null || 
            prueba['iteraciones'] < mejorPrueba['iteraciones'] ||
            (prueba['iteraciones'] == mejorPrueba['iteraciones'] && 
             prueba['error_final'] < mejorPrueba['error_final'])) {
          mejorPrueba = prueba;
        }
      }
    }
    
    resultado['pruebas'] = pruebas;
    resultado['mejor_omega'] = mejorPrueba?['omega'];
    resultado['mejor_iteraciones'] = mejorPrueba?['iteraciones'];
    resultado['recomendacion'] = mejorPrueba != null 
        ? 'Se recomienda usar ω = ${mejorPrueba['omega']} para convergencia óptima'
        : 'Ningún valor de ω probado logró convergencia';
    
    return resultado;
  }

  String getMethodDescription() {
    return '''
Propósito: Acelerar la convergencia del método de Jacobi para resolver sistemas de ecuaciones lineales mediante la introducción de un parámetro de relajación que pondera la corrección aplicada en cada iteración.

Fundamento: Combina la iteración de Jacobi estándar con un factor de relajación ω, actualizando cada variable como una combinación lineal entre su valor anterior y el nuevo valor.

Características:

  Parametro ω ajustable:

    ω=1: Método de Jacobi estándar

    ω>1: Sobrerrelajación (acelera convergencia)

    ω<1: Subrelajación (mejora estabilidad)

  Requiere diagonal dominante o simetría definida positiva para convergencia garantizada

  Fácil implementación y paralelización

  Actualiza todas las variables simultáneamente usando valores de la iteración anterior

Ventajas:

  Convergencia significativamente más rápida que Jacobi estándar

  Simple de implementar y paralelizar

  Estabilidad mejorada en sistemas mal condicionados con elección adecuada de ω

  Eficiente para matrices grandes y dispersas
''';
  }
}
