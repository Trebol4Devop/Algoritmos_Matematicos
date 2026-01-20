import 'MethodClass.Dart';
import 'MethodUtils.Dart';

// Clase para el método de Eliminación Gaussiana con Sustitución hacia Atrás
class GaussianEliminationWithBackSubstitutionClass extends MethodClass {
  int n;
  List<List<double>> dataTable;
  List<double> resultTable;
  int dn;
  List<List<double>> augmentedMatrix;
  List<double> solution;
  int swapCount;

  GaussianEliminationWithBackSubstitutionClass({
    this.n = 0,
    this.dataTable = const [],
    this.resultTable = const [],
    this.dn = 4,
    List<List<double>>? augmentedMatrix,
    List<double>? solution,
    this.swapCount = 0,
  })  : augmentedMatrix = augmentedMatrix ?? [],
        solution = solution ?? [],
        super(
          id: 10,
          title: "Eliminación Gaussiana con Sustitución hacia Atrás",
          subtitle: "Resolución de Sistemas de Ecuaciones Lineales",
          index: "GEBS",
        );

  @override
  void initialize() {
    super.initialize();
    n = 0;
    dataTable = [];
    resultTable = [];
    augmentedMatrix = [];
    solution = [];
    swapCount = 0;
    message = "";
    success = false;
  }

  void setAugmentedMatrix(List<List<double>> matrix) {
    if (matrix.isEmpty) {
      message = "Error: La matriz está vacía";
      success = false;
      return;
    }

    n = matrix.length;
    augmentedMatrix = List.generate(n, (i) => List<double>.from(matrix[i]));
    dataTable = List.generate(n, (i) => List<double>.from(matrix[i].sublist(0, n)));
    resultTable = List.generate(n, (i) => matrix[i][n]);
    
    for (int i = 0; i < n; i++) {
      if (matrix[i].length != n + 1) {
        message = "Error: La matriz debe ser de tamaño n x (n+1)";
        success = false;
        return;
      }
    }
    
    message = "Matriz configurada correctamente";
    success = true;
  }

  void gaussianEliminationWithBackSubstitutionMethod() {
    try {
      initialize();
      
      if (augmentedMatrix.isEmpty && dataTable.isNotEmpty && resultTable.isNotEmpty) {
        augmentedMatrix = List.generate(n, (i) {
          List<double> row = List<double>.from(dataTable[i]);
          row.add(resultTable[i]);
          return row;
        });
      }
      
      if (augmentedMatrix.isEmpty) {
        message = "Error: No se ha configurado la matriz del sistema";
        success = false;
        return;
      }

      n = augmentedMatrix.length;
      List<List<double>> A = List.generate(n, (i) => List<double>.from(augmentedMatrix[i]));
      solution = List<double>.filled(n, 0.0);
      swapCount = 0;

      String? validationError = _validateInput();
      if (validationError != null) {
        message = validationError;
        success = false;
        return;
      }

      if (!_forwardElimination(A)) {
        message = "Error: El sistema no tiene solución única (matriz singular)";
        success = false;
        return;
      }

      if (!_backSubstitution(A)) {
        message = "Error: No se pudo resolver el sistema";
        success = false;
        return;
      }

      result = _calculateResidual();
      iterations = 0;
      success = true;
      message = "Sistema resuelto exitosamente con $swapCount intercambio(s) de filas";

    } catch (e) {
      message = "Error durante el cálculo: ${e.toString()}";
      success = false;
    }
  }

  String? _validateInput() {
    if (n <= 0) {
      return "Error: El tamaño del sistema debe ser mayor que 0";
    }

    if (augmentedMatrix.length != n) {
      return "Error: Dimensiones inconsistentes en la matriz aumentada";
    }

    for (int i = 0; i < n; i++) {
      if (augmentedMatrix[i].length != n + 1) {
        return "Error: La fila ${i + 1} no tiene $n + 1 elementos";
      }
    }

    return null;
  }

  bool _forwardElimination(List<List<double>> A) {
    for (int i = 0; i < n - 1; i++) {
      int maxRow = i;
      double maxVal = A[i][i].abs();
      
      for (int k = i + 1; k < n; k++) {
        if (A[k][i].abs() > maxVal) {
          maxVal = A[k][i].abs();
          maxRow = k;
        }
      }
      if (maxVal < 1e-15) {
        return false;
      }
      if (maxRow != i) {
        _swapRows(A, i, maxRow);
        swapCount++;
      }
      for (int k = i + 1; k < n; k++) {
        double factor = A[k][i] / A[i][i];
        
        for (int j = i; j <= n; j++) {
          A[k][j] -= factor * A[i][j];
        }
        A[k][i] = 0.0;
      }
    }
    if (A[n - 1][n - 1].abs() < 1e-15) {
      return false;
    }

    return true;
  }
  void _swapRows(List<List<double>> A, int row1, int row2) {
    List<double> temp = List<double>.from(A[row1]);
    A[row1] = List<double>.from(A[row2]);
    A[row2] = temp;
  }
  bool _backSubstitution(List<List<double>> A) {
    try {
      for (int i = n - 1; i >= 0; i--) {
        double sum = 0.0;
        
        for (int j = i + 1; j < n; j++) {
          sum += A[i][j] * solution[j];
        }
        
        solution[i] = (A[i][n] - sum) / A[i][i];
        if (solution[i].isNaN || solution[i].isInfinite) {
          return false;
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }
  double _calculateResidual() {
    double maxResidual = 0.0;
    
    for (int i = 0; i < n; i++) {
      double sum = 0.0;
      for (int j = 0; j < n; j++) {
        sum += dataTable[i][j] * solution[j];
      }
      double residual = (sum - resultTable[i]).abs();
      if (residual > maxResidual) {
        maxResidual = residual;
      }
    }
    
    return maxResidual;
  }
  List<String> getFormattedSolution() {
    return solution.map((x) => MethodUtils.redondear(x, dn).toString()).toList();
  }
  List<List<String>> getFormattedUpperTriangular() {
    List<List<String>> formatted = [];
    
    for (int i = 0; i < n; i++) {
      List<String> row = [];
      for (int j = 0; j <= n; j++) {
        row.add(MethodUtils.redondear(augmentedMatrix[i][j], dn).toString());
      }
      formatted.add(row);
    }
    
    return formatted;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'n': n,
      'dataTable': dataTable,
      'resultTable': resultTable,
      'solution': solution,
      'swapCount': swapCount,
      'augmentedMatrix': augmentedMatrix,
    };
  }

  @override
  String getResultSummary() {
    if (!success) {
      return 'Método: $title\nEstado: Falló\nMensaje: $message';
    }

    String solutionStr = solution.asMap().entries.map((entry) {
      return 'x${entry.key + 1} = ${MethodUtils.redondear(entry.value, dn)}';
    }).join('\n');

    return '''
Método: $title
Estado: Éxito
Solución:
$solutionStr
Intercambios de filas: $swapCount
Residual máximo: ${MethodUtils.redondear(result, dn)}
Mensaje: $message''';
  }
  bool hasUniqueSolution() {
    if (augmentedMatrix.isEmpty) return false;
    List<List<double>> temp = List.generate(n, (i) => List<double>.from(augmentedMatrix[i]));
    
    try {
      return _forwardElimination(temp);
    } catch (e) {
      return false;
    }
  }

  String getMethodDescription() {
    return '''
Propósito: Resolver sistemas de ecuaciones lineales transformando la matriz de coeficientes en una forma triangular superior mediante operaciones elementales de fila.

Fundamento: Aplica eliminación hacia adelante para crear ceros bajo los pivotes, seguido de sustitución hacia atrás para obtener las soluciones comenzando desde la última ecuación.

Características:

  Método directo y exacto (salvo errores de redondeo).

  Complejidad computacional: O(n^3) para eliminación, O(n^2) para sustitución.

  Requiere pivoteo parcial para evitar inestabilidad numérica.

  Preserva el determinante de la matriz original (hasta factores de escala).

Ventajas:

    Solución exacta en aritmética precisa.

    Base para otras factorizaciones matriciales (LU).

    Eficiente para sistemas pequeños o medianos.

    Permite resolver múltiples sistemas con misma matriz simultáneamente.
''';
  }

}