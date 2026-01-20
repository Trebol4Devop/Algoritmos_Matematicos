import 'dart:math' as math;
import 'MethodClass.Dart';
import 'MethodUtils.Dart';
import 'ComplexOperations.Dart';

// Clase para la Factorización de Schur de una matriz
class SchurFactorizationClass extends MethodClass {
  List<List<double>> matrix;
  List<List<double>> Q;
  List<List<double>> T;
  List<List<double>> eigenvalues;
  int maxIterations;
  double tolerance;
  int dn;

  SchurFactorizationClass({
    this.matrix = const [],
    this.Q = const [],
    this.T = const [],
    this.eigenvalues = const [],
    this.maxIterations = 100,
    this.tolerance = 1e-10,
    this.dn = 6,
  }) : super(
          id: 11,
          title: "Factorización de Schur",
          subtitle: "Descomposición A = Q * T * Q^T",
          index: "SCHUR",
        );

  @override
  void initialize() {
    super.initialize();
    Q = [];
    T = [];
    eigenvalues = [];
    message = "";
    success = false;
    iterations = 0;
  }
  void schurFactorizationMethod() {
    try {
      initialize();

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
      List<List<double>> A = _copyMatrix(matrix);
      Q = _identityMatrix(n);
      T = _copyMatrix(A);
      _qrAlgorithm(A);
      _extractEigenvalues();

      success = true;
      message = "Factorización de Schur completada exitosamente";
      result = _calculateNorm();

    } catch (e) {
      message = "Error durante la factorización: ${e.toString()}";
      success = false;
    }
  }
  void _qrAlgorithm(List<List<double>> A) {
    int n = A.length;
    double norm = _matrixNorm(A);
    int iter = 0;

    while (iter < maxIterations && norm > tolerance) {
      double shift = A[n - 1][n - 1];

      List<List<double>> shiftedA = _copyMatrix(A);
      for (int i = 0; i < n; i++) {
        shiftedA[i][i] -= shift;
      }

      Map<String, List<List<double>>> qrResult = _qrDecomposition(shiftedA);
      List<List<double>> Qk = qrResult['Q']!;
      List<List<double>> R = qrResult['R']!;

      List<List<double>> RQ = _matrixMultiply(R, Qk);
      for (int i = 0; i < n; i++) {
        RQ[i][i] += shift;
      }

      A = RQ;
      Q = _matrixMultiply(Q, Qk);
      T = _copyMatrix(A);

      norm = _subdiagonalNorm(A);
      iter++;
    }

    iterations = iter;
  }

  Map<String, List<List<double>>> _qrDecomposition(List<List<double>> A) {
    int n = A.length;
    List<List<double>> Q = _identityMatrix(n);
    List<List<double>> R = _copyMatrix(A);

    for (int k = 0; k < n - 1; k++) {
      List<double> x = List<double>.filled(n - k, 0.0);
      for (int i = k; i < n; i++) {
        x[i - k] = R[i][k];
      }

      double normX = _vectorNorm(x);
      List<double> v = List<double>.from(x);
      v[0] += math.pow(x[0], 2) > 0 ? normX : -normX;

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

    return {'Q': Q, 'R': R};
  }
  void _extractEigenvalues() {
    int n = T.length;
    eigenvalues = [];

    int i = 0;
    while (i < n) {
      if (i == n - 1 || T[i + 1][i].abs() < tolerance) {
        eigenvalues.add([T[i][i], 0.0]);
        i++;
      } else {
        double a = T[i][i];
        double b = T[i][i + 1];
        double c = T[i + 1][i];
        double d = T[i + 1][i + 1];
        double trace = a + d;
        double determinant = a * d - b * c;

        double discriminant = trace * trace - 4 * determinant;
        if (discriminant < 0) {
          double realPart = trace / 2;
          double imagPart = math.sqrt(-discriminant) / 2;
          eigenvalues.add([realPart, imagPart]);
          eigenvalues.add([realPart, -imagPart]);
        } else {
          double lambda1 = (trace + math.sqrt(discriminant)) / 2;
          double lambda2 = (trace - math.sqrt(discriminant)) / 2;
          eigenvalues.add([lambda1, 0.0]);
          eigenvalues.add([lambda2, 0.0]);
        }
        i += 2;
      }
    }
  }
  double _matrixNorm(List<List<double>> A) {
    double norm = 0.0;
    int n = A.length;
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        norm += A[i][j] * A[i][j];
      }
    }
    return math.sqrt(norm);
  }
  double _subdiagonalNorm(List<List<double>> A) {
    double norm = 0.0;
    int n = A.length;
    for (int i = 1; i < n; i++) {
      norm += A[i][i - 1] * A[i][i - 1];
    }
    return math.sqrt(norm);
  }
  double _vectorNorm(List<double> v) {
    double norm = 0.0;
    for (double x in v) {
      norm += x * x;
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
  double _calculateNorm() {
    List<List<double>> QT = _matrixMultiply(Q, T);
    List<List<double>> Q_transpose = _transposeMatrix(Q);
    List<List<double>> reconstructed = _matrixMultiply(QT, Q_transpose);

    double error = 0.0;
    int n = matrix.length;
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        error += (matrix[i][j] - reconstructed[i][j]).abs();
      }
    }

    return error;
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
  void setMatrix(List<List<double>> newMatrix) {
    matrix = _copyMatrix(newMatrix);
    message = "Matriz configurada correctamente";
    success = true;
  }
  Map<String, dynamic> getFormattedResults() {
    return {
      'matrix': _formatMatrix(matrix),
      'Q': _formatMatrix(Q),
      'T': _formatMatrix(T),
      'eigenvalues': _formatEigenvalues(),
      'iterations': iterations,
      'error': MethodUtils.redondear(result, dn),
      'success': success,
      'message': message,
    };
  }
  List<List<String>> _formatMatrix(List<List<double>> mat) {
    return mat.map((row) => row.map((val) => MethodUtils.redondear(val, dn).toString()).toList()).toList();
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
  bool isQOrthogonal() {
    List<List<double>> Q_transpose = _transposeMatrix(Q);
    List<List<double>> product = _matrixMultiply(Q, Q_transpose);
    List<List<double>> identity = _identityMatrix(Q.length);

    double error = 0.0;
    for (int i = 0; i < product.length; i++) {
      for (int j = 0; j < product[i].length; j++) {
        error += (product[i][j] - identity[i][j]).abs();
      }
    }

    return error < tolerance;
  }
  bool isTTriangular() {
    for (int i = 1; i < T.length; i++) {
      for (int j = 0; j < i; j++) {
        if (T[i][j].abs() > tolerance) {
          return false;
        }
      }
    }
    return true;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'matrix': matrix,
      'Q': Q,
      'T': T,
      'eigenvalues': eigenvalues,
      'maxIterations': maxIterations,
      'tolerance': tolerance,
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
Método: $title
Estado: Éxito
Iteraciones: $iterations
Error de reconstrucción: ${MethodUtils.redondear(result, dn)}
Q es ortogonal: ${isQOrthogonal()}
T es triangular: ${isTTriangular()}

Autovalores:
$eigenStr

Mensaje: $message''';
  }

  String getMethodDescription() {
    return '''
Propósito: Resolver sistemas de ecuaciones lineales mediante la descomposición de la matriz de coeficientes en dos matrices triangulares, facilitando la solución eficiente de múltiples sistemas con la misma matriz.

Fundamento: Descompone la matriz A en el producto de una matriz triangular inferior (L) y una triangular superior (U), donde A = LU, transformando el sistema Ax = b en dos sistemas triangulares: Ly = b y Ux = y.

Características:

    Preserva la estructura de la matriz original sin alterar el sistema.

    Requite O(n^3) operaciones para la descomposición, pero O(n^2) para sustituciones posteriores.

    Necesita pivoteo parcial para garantizar estabilidad numérica.

    La diagonal de L contiene unos o la de U unos.

Ventajas:

    Eficiente para resolver múltiples sistemas con misma matriz.

    Base para calcular inversas y determinantes.

    Más estable que la eliminación gaussiana directa.

    Permite implementar optimizaciones para matrices especiales (bandadas, dispersas).
''';
  }

}