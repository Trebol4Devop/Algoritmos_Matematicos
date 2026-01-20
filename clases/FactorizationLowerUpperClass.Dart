import 'MethodClass.Dart';
import 'MethodUtils.Dart';

/// Clase para el método de Factorización LU con Sobrerrelajación Successive (SOR)
class FactorizationLowerUpperClass extends MethodClass {
  int n;
  double omega;
  double tol;
  int maxIterations;
  int dn;
  List<List<double>> dataTable;
  List<double> x0;
  List<List<double>> iterationResults;
  List<double> finalSolution;
  double finalError;

  FactorizationLowerUpperClass({
    this.n = 0,
    this.omega = 1.0,
    this.tol = 1e-6,
    this.maxIterations = 100,
    this.dn = 6,
    this.dataTable = const [],
    this.x0 = const [],
    this.iterationResults = const [],
    this.finalSolution = const [],
    this.finalError = 0.0,
  }) : super(
          id: 12,
          title: "Factorización LU con Sobrerrelajación Successive",
          subtitle: "Método iterativo SOR para sistemas lineales",
          index: "SOR-LU",
        );

  @override
  void initialize() {
    super.initialize();
    iterationResults = [];
    finalSolution = [];
    finalError = 0.0;
    message = "";
    success = false;
    iterations = 0;
  }

  void factorizationLowerUpperMethod() {
    try {
      initialize();

      if (dataTable.isEmpty) {
        message = "Error: La tabla de datos está vacía";
        success = false;
        return;
      }

      String? validationError = _validateParameters();
      if (validationError != null) {
        message = validationError;
        success = false;
        return;
      }

      List<List<double>> A = _extractMatrixA();
      List<double> b = _extractVectorB();

      if (A.length != n || A[0].length != n) {
        message = "Error: La matriz A debe ser cuadrada de tamaño n x n";
        success = false;
        return;
      }

      if (!_checkConvergenceConditions(A)) {
        message = "Advertencia: La matriz puede no converger con el método SOR";
      }

      _applySORMethod(A, b);

      success = true;
      message = "Método SOR completado exitosamente";
      result = finalError;

    } catch (e) {
      message = "Error durante el cálculo: ${e.toString()}";
      success = false;
    }
  }

  void _applySORMethod(List<List<double>> A, List<double> b) {
    List<double> x = List<double>.from(x0);
    List<double> xOld = List<double>.from(x0);
    iterationResults = [];
    double error = double.infinity;
    int iter = 0;

    while (iter < maxIterations && error > tol) {
      xOld = List<double>.from(x);

      for (int i = 0; i < n; i++) {
        double sum1 = 0.0;
        double sum2 = 0.0;

        for (int j = 0; j < i; j++) {
          sum1 += A[i][j] * x[j];
        }

        for (int j = i + 1; j < n; j++) {
          sum2 += A[i][j] * xOld[j];
        }

        double term = (b[i] - sum1 - sum2) / A[i][i];
        x[i] = xOld[i] + omega * (term - xOld[i]);
      }

      error = _calculateError(x, xOld);

      List<double> iterationResult = [];
      iterationResult.add(iter + 1);
      iterationResult.addAll(x);
      iterationResult.addAll(_calculateAbsoluteErrors(x, xOld));
      iterationResult.add(error);

      iterationResults.add(iterationResult);
      
      iter++;
    }

    iterations = iter;
    finalSolution = List<double>.from(x);
    finalError = error;
  }

  double _calculateError(List<double> xNew, List<double> xOld) {
    double maxError = 0.0;
    for (int i = 0; i < n; i++) {
      double error = (xNew[i] - xOld[i]).abs();
      if (error > maxError) {
        maxError = error;
      }
    }
    return maxError;
  }

  List<double> _calculateAbsoluteErrors(List<double> xNew, List<double> xOld) {
    List<double> errors = [];
    for (int i = 0; i < n; i++) {
      errors.add((xNew[i] - xOld[i]).abs());
    }
    return errors;
  }

  List<List<double>> _extractMatrixA() {
    List<List<double>> A = [];
    for (int i = 0; i < n; i++) {
      List<double> row = [];
      for (int j = 0; j < n; j++) {
        row.add(dataTable[i][j]);
      }
      A.add(row);
    }
    return A;
  }

  List<double> _extractVectorB() {
    List<double> b = [];
    for (int i = 0; i < n; i++) {
      b.add(dataTable[i][n]);
    }
    return b;
  }

  String? _validateParameters() {
    if (n <= 0) {
      return "Error: n debe ser mayor que 0";
    }

    if (omega <= 0 || omega >= 2) {
      return "Error: omega debe estar en el intervalo (0, 2)";
    }

    if (tol <= 0) {
      return "Error: la tolerancia debe ser mayor que 0";
    }

    if (maxIterations <= 0) {
      return "Error: el número máximo de iteraciones debe ser mayor que 0";
    }

    if (dataTable.length != n) {
      return "Error: la tabla de datos debe tener n filas";
    }

    for (int i = 0; i < n; i++) {
      if (dataTable[i].length != n + 1) {
        return "Error: cada fila debe tener n + 1 elementos";
      }
    }

    if (x0.length != n) {
      return "Error: el vector inicial x0 debe tener n elementos";
    }

    return null;
  }

  bool _checkConvergenceConditions(List<List<double>> A) {
    bool strictlyDiagonallyDominant = true;
    bool weaklyDiagonallyDominant = true;

    for (int i = 0; i < n; i++) {
      double diagonal = A[i][i].abs();
      double sum = 0.0;

      for (int j = 0; j < n; j++) {
        if (j != i) {
          sum += A[i][j].abs();
        }
      }

      if (diagonal <= sum) {
        strictlyDiagonallyDominant = false;
      }
      if (diagonal < sum) {
        weaklyDiagonallyDominant = false;
      }
    }

    return strictlyDiagonallyDominant || weaklyDiagonallyDominant;
  }

  void setAugmentedMatrix(List<List<double>> matrix, List<double> initialGuess) {
    n = matrix.length;
    dataTable = List.generate(n, (i) => List<double>.from(matrix[i]));
    x0 = List<double>.from(initialGuess);
    message = "Sistema configurado correctamente";
    success = true;
  }

  List<List<String>> getIterationResultsFormatted() {
    List<List<String>> formatted = [];

    for (var iteration in iterationResults) {
      List<String> row = [];

      row.add(iteration[0].toInt().toString());

      for (int i = 1; i <= n; i++) {
        row.add(MethodUtils.redondear(iteration[i], dn).toString());
      }

      for (int i = n + 1; i <= 2 * n; i++) {
        row.add(MethodUtils.redondear(iteration[i], dn).toString());
      }

      row.add(MethodUtils.redondear(iteration[2 * n + 1], dn).toString());
      
      formatted.add(row);
    }

    return formatted;
  }

  List<String> getResultHeaders() {
    List<String> headers = ['n'];

    for (int i = 1; i <= n; i++) {
      headers.add('x$i');
    }

    for (int i = 1; i <= n; i++) {
      headers.add('Ex$i');
    }
    
    headers.add('Error');
    
    return headers;
  }

  List<String> getFinalSolutionFormatted() {
    return finalSolution.map((x) => MethodUtils.redondear(x, dn).toString()).toList();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'n': n,
      'omega': omega,
      'tol': tol,
      'maxIterations': maxIterations,
      'dn': dn,
      'dataTable': dataTable,
      'x0': x0,
      'finalSolution': finalSolution,
      'finalError': finalError,
    };
  }

  @override
  String getResultSummary() {
    if (!success) {
      return 'Método: $title\nEstado: Falló\nMensaje: $message';
    }

    String solutionStr = finalSolution.asMap().entries.map((entry) {
      return 'x${entry.key + 1} = ${MethodUtils.redondear(entry.value, dn)}';
    }).join('\n');

    return '''
Método: $title
Estado: Éxito
Iteraciones: $iterations
Error final: ${MethodUtils.redondear(finalError, dn)}
Parámetro omega: $omega
Tolerancia: $tol

Solución final:
$solutionStr

Mensaje: $message''';
  }
}