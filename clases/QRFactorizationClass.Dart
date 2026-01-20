import 'dart:math' as math;
import 'MethodClass.Dart';
import 'MethodUtils.Dart';
import 'ComplexOperations.Dart';

class QRFactorizationClass extends MethodClass {
  List<List<double>> matrix;
  List<List<double>> Q;
  List<List<double>> R;
  List<List<double>> eigenvalues;
  String method;
  double tolerance;
  int maxIterations;
  int dn;

  QRFactorizationClass({
    this.matrix = const [],
    this.Q = const [],
    this.R = const [],
    this.eigenvalues = const [],
    this.method = 'Householder',
    this.tolerance = 1e-6,
    this.maxIterations = 100,
    this.dn = 6,
  });

  @override
  void initialize() {
    super.initialize();
    Q = [];
    R = [];
    eigenvalues = [];
    message = "";
    success = false;
    iterations = 0;
  }

  void qrFactorizationMethod({bool calcEigenvalues = true}) {
    try {
      if (calcEigenvalues) {
        initialize();
      } else {
        Q = [];
        R = [];
      }

      if (matrix.isEmpty) {
        message = "Error: La matriz está vacía";
        success = false;
        return;
      }
      int n = matrix.length;
      for (int i = 0; i < n; i++) {
        if (matrix[i].length != n) {
          message = "Error: La matriz debe ser cuadrada";
          success = false;
          return;
        }
      }

      switch (method) {
        case 'Householder':
          _householderQR();
          break;
        case 'Gram-Schmidt':
          _gramSchmidtQR();
          break;
        case 'Givens':
          _givensQR();
          break;
        default:
          _householderQR();
      }

      if (calcEigenvalues) {
        _computeEigenvaluesQR();
        success = true;
        message = "Factorización QR completada exitosamente usando $method";
        result = _calculateReconstructionError();
      }

    } catch (e) {
      message = "Error durante la factorización QR: ${e.toString()}";
      success = false;
    }
  }

  void _householderQR() {
    int n = matrix.length;
    List<List<double>> A = _copyMatrix(matrix);
    Q = _identityMatrix(n);
    R = _copyMatrix(A);

    for (int k = 0; k < n - 1; k++) {
      List<double> x = List<double>.filled(n - k, 0.0);
      for (int i = k; i < n; i++) {
        x[i - k] = R[i][k];
      }
      
      double normX = _vectorNorm(x);
      if (normX < tolerance) continue;

      List<double> v = List<double>.from(x);
      if (x[0] >= 0) {
        v[0] += normX;
      } else {
        v[0] -= normX;
      }

      double normV = _vectorNorm(v);
      if (normV < tolerance) continue;

      for (int i = 0; i < v.length; i++) {
        v[i] /= normV;
      }

      for (int j = k; j < n; j++) {
        List<double> col = List<double>.filled(n - k, 0.0);
        for (int i = k; i < n; i++) {
          col[i - k] = R[i][j];
        }

        double dot = 0.0;
        for (int i = 0; i < col.length; i++) {
          dot += col[i] * v[i];
        }

        for (int i = k; i < n; i++) {
          R[i][j] -= 2 * v[i - k] * dot;
        }
      }

      for (int j = 0; j < n; j++) {
        List<double> col = List<double>.filled(n - k, 0.0);
        for (int i = k; i < n; i++) {
          col[i - k] = Q[i][j];
        }

        double dot = 0.0;
        for (int i = 0; i < col.length; i++) {
          dot += col[i] * v[i];
        }

        for (int i = k; i < n; i++) {
          Q[i][j] -= 2 * v[i - k] * dot;
        }
      }
    }
    Q = _transposeMatrix(Q);
  }

  void _gramSchmidtQR() {
    int n = matrix.length;
    List<List<double>> A = _copyMatrix(matrix);
    
    Q = List.generate(n, (_) => List<double>.filled(n, 0.0));
    R = List.generate(n, (_) => List<double>.filled(n, 0.0));

    for (int j = 0; j < n; j++) {
      List<double> v = List<double>.filled(n, 0.0);
      for (int i = 0; i < n; i++) {
        v[i] = A[i][j];
      }
      for (int i = 0; i < j; i++) {
        R[i][j] = _dotProduct(Q[i], v);
        for (int k = 0; k < n; k++) {
          v[k] -= R[i][j] * Q[i][k];
        }
      }
      double norm = _vectorNorm(v);
      
      if (norm < tolerance) {
        R[j][j] = 0.0; 
      } else {
        R[j][j] = norm;
        for (int i = 0; i < n; i++) {
          Q[i][j] = v[i] / norm;
        }
      }
    }
  }

  void _givensQR() {
    int n = matrix.length;
    R = _copyMatrix(matrix);
    Q = _identityMatrix(n);

    for (int j = 0; j < n; j++) {
      for (int i = j + 1; i < n; i++) {
        if (R[i][j].abs() > tolerance) {
          double a = R[j][j];
          double b = R[i][j];
          double r = math.sqrt(a * a + b * b);
          
          double c = a / r;
          double s = -b / r;
          
          for (int k = j; k < n; k++) {
            double temp1 = c * R[j][k] - s * R[i][k];
            double temp2 = s * R[j][k] + c * R[i][k];
            R[j][k] = temp1;
            R[i][k] = temp2;
          }
          
          for (int k = 0; k < n; k++) {
            double temp1 = c * Q[k][j] - s * Q[k][i];
            double temp2 = s * Q[k][j] + c * Q[k][i];
            Q[k][j] = temp1;
            Q[k][i] = temp2;
          }
        }
      }
    }
  }

  void _computeEigenvaluesQR() {
    List<List<double>> A = _copyMatrix(matrix);
    eigenvalues = [];
    int iter = 0;
    int maxSeguridad = maxIterations > 0 ? maxIterations : 100;
    double norm = _subdiagonalNorm(A);

    while (iter < maxSeguridad && norm > tolerance) {
      double shift = A[A.length - 1][A.length - 1];
      List<List<double>> shiftedA = _copyMatrix(A);
      
      for (int i = 0; i < A.length; i++) {
        shiftedA[i][i] -= shift;
      }

      var tempQR = QRFactorizationClass(
        matrix: shiftedA, 
        method: 'Householder', 
        tolerance: tolerance,
        dn: dn
      );
      
      tempQR.qrFactorizationMethod(calcEigenvalues: false);
      
      List<List<double>> Qk = tempQR.Q;
      List<List<double>> Rk = tempQR.R;
      
      List<List<double>> RQ = _matrixMultiply(Rk, Qk);
      for (int i = 0; i < A.length; i++) {
        RQ[i][i] += shift;
      }

      A = RQ;
      norm = _subdiagonalNorm(A);
      iter++;
    }

    iterations = iter;
    for (int i = 0; i < A.length; i++) {
      eigenvalues.add([A[i][i], 0.0]);
    }
  }

  double _dotProduct(List<double> a, List<double> b) {
    double result = 0.0;
    for (int i = 0; i < a.length; i++) {
      result += a[i] * b[i];
    }
    return result;
  }

  double _vectorNorm(List<double> v) {
    return math.sqrt(_dotProduct(v, v));
  }

  double _subdiagonalNorm(List<List<double>> A) {
    double norm = 0.0;
    for (int i = 1; i < A.length; i++) {
      norm += A[i][i - 1] * A[i][i - 1];
    }
    return math.sqrt(norm);
  }

  List<List<double>> _identityMatrix(int n) {
    List<List<double>> I = List.generate(n, (_) => List<double>.filled(n, 0.0));
    for (int i = 0; i < n; i++) {
      I[i][i] = 1.0;
    }
    return I;
  }

  List<List<double>> _copyMatrix(List<List<double>> A) {
    return A.map((row) => List<double>.from(row)).toList();
  }

  List<List<double>> _matrixMultiply(List<List<double>> A, List<List<double>> B) {
    int n = A.length;
    int m = B[0].length;
    int p = B.length;

    List<List<double>> C = List.generate(n, (_) => List<double>.filled(m, 0.0));

    for (int i = 0; i < n; i++) {
      for (int j = 0; j < m; j++) {
        for (int k = 0; k < p; k++) {
          C[i][j] += A[i][k] * B[k][j];
        }
      }
    }
    return C;
  }

  List<List<double>> _transposeMatrix(List<List<double>> A) {
    int n = A.length;
    int m = A[0].length;
    List<List<double>> T = List.generate(m, (_) => List<double>.filled(n, 0.0));

    for (int i = 0; i < n; i++) {
      for (int j = 0; j < m; j++) {
        T[j][i] = A[i][j];
      }
    }
    return T;
  }

  double _calculateReconstructionError() {
    if (Q.isEmpty || R.isEmpty) return 0.0;
    List<List<double>> QR = _matrixMultiply(Q, R);
    
    double error = 0.0;
    int n = matrix.length;
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        error += (matrix[i][j] - QR[i][j]).abs();
      }
    }
    return error;
  }

  bool isQOrthogonal() {
    if (Q.isEmpty) return false;
    List<List<double>> Q_transpose = _transposeMatrix(Q);
    List<List<double>> product = _matrixMultiply(Q, Q_transpose);
    List<List<double>> identity = _identityMatrix(Q.length);

    double error = 0.0;
    for (int i = 0; i < product.length; i++) {
      for (int j = 0; j < product[i].length; j++) {
        error += (product[i][j] - identity[i][j]).abs();
      }
    }
    return error < tolerance * 10;
  }

  bool isRTriangular() {
    if (R.isEmpty) return false;
    for (int i = 1; i < R.length; i++) {
      for (int j = 0; j < i; j++) {
        if (R[i][j].abs() > tolerance) {
          return false;
        }
      }
    }
    return true;
  }

  void setMatrix(List<List<double>> newMatrix, {String method = 'Householder'}) {
    matrix = _copyMatrix(newMatrix);
    this.method = method;
    message = "Matriz configurada correctamente para factorización QR con $method";
    success = true;
  }

  Map<String, dynamic> getFormattedResults() {
    return {
      'matrix': _formatMatrix(matrix),
      'Q': _formatMatrix(Q),
      'R': _formatMatrix(R),
      'eigenvalues': _formatEigenvalues(),
      'method': method,
      'iterations': iterations,
      'reconstruction_error': MethodUtils.redondear(result, dn),
      'Q_orthogonal': isQOrthogonal(),
      'R_triangular': isRTriangular(),
      'success': success,
      'message': message,
    };
  }

  List<List<String>> _formatMatrix(List<List<double>> mat) {
    return mat.map((row) => 
      row.map((val) => MethodUtils.redondear(val, dn).toString()).toList()
    ).toList();
  }

  List<String> _formatEigenvalues() {
    return eigenvalues.map((eigenvalue) {
      if (eigenvalue[1].abs() < tolerance) {
        return MethodUtils.redondear(eigenvalue[0], dn).toString();
      } else {
        return ComplexOperations.toComplexString(eigenvalue[0], eigenvalue[1], decimales: dn);
      }
    }).toList();
  }

  List<double> solveLinearSystem(List<double> b) {
    if (Q.isEmpty || R.isEmpty) {
      throw Exception("Primero debe calcular la factorización QR");
    }

    int n = b.length;
    List<double> y = List<double>.filled(n, 0.0);
    List<List<double>> Q_transpose = _transposeMatrix(Q);
    
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        y[i] += Q_transpose[i][j] * b[j];
      }
    }
    List<double> x = List<double>.filled(n, 0.0);
    for (int i = n - 1; i >= 0; i--) {
      x[i] = y[i];
      for (int j = i + 1; j < n; j++) {
        x[i] -= R[i][j] * x[j];
      }
      x[i] /= R[i][i];
    }

    return x;
  }

  double conditionNumber() {
    if (eigenvalues.isEmpty) return 0.0;
    try {
        double maxEigenvalue = eigenvalues.map((e) => e[0].abs()).reduce(math.max);
        double minEigenvalue = eigenvalues.map((e) => e[0].abs()).reduce(math.min);
        if (minEigenvalue == 0) return double.infinity;
        return maxEigenvalue / minEigenvalue;
    } catch(e) {
        return 0.0;
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'matrix': matrix,
      'Q': Q,
      'R': R,
      'eigenvalues': eigenvalues,
      'method': method,
      'tolerance': tolerance,
      'maxIterations': maxIterations,
      'dn': dn,
    };
  }

  @override
  String getResultSummary() {
    if (!success) {
      return 'Método: $title\nEstado: Falló\nMensaje: $message';
    }

    String eigenStr = _formatEigenvalues().asMap().entries.map((entry) {
      return 'λ${entry.key + 1} = ${entry.value}';
    }).join('\n');

    return '''
Método: $title ($method)
Estado: Éxito
Iteraciones: $iterations
Error de reconstrucción: ${MethodUtils.redondear(result, dn)}
Número de condición: ${MethodUtils.redondear(conditionNumber(), dn)}
Q es ortogonal: ${isQOrthogonal()}
R es triangular: ${isRTriangular()}

Autovalores:
$eigenStr

Mensaje: $message''';
  }

  void loadExampleMatrix({String method = 'Householder'}) {
    List<List<double>> example = [
      [4.0, 1.0, 1.0],
      [1.0, 3.0, -1.0],
      [1.0, -1.0, 2.0]
    ];

    setMatrix(example, method: method);
    message = "Matriz de ejemplo 3x3 cargada para factorización QR con $method";
  }

  Map<String, dynamic> compareQRMethods() {
    Map<String, dynamic> comparison = {};
    
    List<String> methods = ['Householder', 'Gram-Schmidt', 'Givens'];
    
    for (String method in methods) {
      var qrTemp = QRFactorizationClass(
        matrix: _copyMatrix(matrix),
        method: method,
        tolerance: tolerance,
        maxIterations: maxIterations,
        dn: dn,
      );
      
      qrTemp.qrFactorizationMethod();
      
      comparison[method] = {
        'success': qrTemp.success,
        'iterations': qrTemp.iterations,
        'error': MethodUtils.redondear(qrTemp.result, dn),
        'Q_orthogonal': qrTemp.isQOrthogonal(),
        'R_triangular': qrTemp.isRTriangular(),
        'message': qrTemp.message,
      };
    }
    
    return comparison;
  }

  String getMethodDescription() {
    return '''
Propósito: Descomponer una matriz en el producto de una matriz ortogonal y una triangular superior para resolver sistemas lineales, mínimos cuadrados y problemas de autovalores.

Fundamento: Factoriza cualquier matriz A en A=QR, donde Q es ortogonal/unitaria (Q^{T}Q = I) y R es triangular superior, preservando las propiedades numéricas.

Características:

    Estabilidad numérica superior.

    Preserva la norma Euclidiana y la ortogonalidad.

    Aplicable a matrices rectangulares (m x n).

Ventajas:

    Solución óptima para problemas de mínimos cuadrados.

    Base para algoritmos de autovalores.

    Estabilidad numérica en matrices mal condicionadas.

    Útil para descomposiciones en subespacios y proyecciones ortogonales.
''';
  }
}