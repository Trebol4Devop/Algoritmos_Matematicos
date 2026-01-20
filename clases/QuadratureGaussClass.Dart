import 'dart:math' as math;
import 'MethodClass.Dart';
import 'MathParser.Dart';
import 'MethodUtils.Dart';

// Clase para la cuadratura de Gauss-Legendre
class QuadratureGaussClass extends MethodClass {
  String function;
  double lowerLimit;
  double upperLimit;
  int n;
  int dn;
  List<List<double>> resultTable;

  List<List<double>> lcoef = [];
  List<double> lroots = [];
  List<double> weight = [];

  QuadratureGaussClass({
    this.function = "",
    this.lowerLimit = 0.0,
    this.upperLimit = 1.0,
    this.n = 0,
    this.dn = 0,
    this.resultTable = const [],
  }) : super(
          title: "Cuadratura de Gauss-Legendre",
          subtitle: "Aproximación de integrales usando polinomios de Legendre",
          index: "GLQ",
        );

  @override
  void initialize() {
    super.initialize();
    lcoef = [];
    lroots = [];
    weight = [];
    resultTable = [];
  }

  void quadratureGaussMethod() {
    try {
      initialize();
      lcoef = List.generate(n + 1, (_) => List.filled(n + 1, 0.0));
      lroots = List.filled(n, 0.0);
      weight = List.filled(n, 0.0);
      legeCoef();
      legeRoots();
      result = legeInte(lowerLimit, upperLimit);
      resultTable = List.generate(n, (i) => [lroots[i], weight[i]]);

      success = true;
      message = "Cuadratura de Gauss completada exitosamente";
      iterations = n;
    } catch (e) {
      success = false;
      message = "Error en el cálculo: $e";
    }
  }
  void legeCoef() {
    lcoef[0][0] = 1.0;
    if (n >= 1) {
      lcoef[1][1] = 1.0;
    }

    for (int k = 2; k <= n; k++) {
      lcoef[k][0] = -(k - 1) * lcoef[k - 2][0] / k;
      for (int i = 1; i <= k; i++) {
        lcoef[k][i] = ((2 * k - 1) * lcoef[k - 1][i - 1] -
                (k - 1) * lcoef[k - 2][i]) /
            k;
      }
    }
  }
  double legeEval(int n, double x) {
    double s = lcoef[n][n];
    for (int i = n; i > 0; i--) {
      s = s * x + lcoef[n][i - 1];
    }
    return s;
  }
  double legeDiff(int n, double x) {
    return n * (x * legeEval(n, x) - legeEval(n - 1, x)) / (x * x - 1.0);
  }
  void legeRoots() {
    for (int i = 1; i <= n; i++) {
      double x = math.cos(math.pi * (i - 0.25) / (n + 0.5));
      double x1;
      do {
        x1 = x;
        x -= legeEval(n, x) / legeDiff(n, x);
      } while ((x - x1).abs() > 1e-15);

      lroots[i - 1] = x;
      double diffVal = legeDiff(n, x);
      weight[i - 1] = 2.0 / ((1.0 - x * x) * diffVal * diffVal);
    }
  }
  double legeInte(double a, double b) {
    double c1 = (b - a) / 2.0;
    double c2 = (b + a) / 2.0;
    double sum = 0.0;

    for (int i = 0; i < n; i++) {
      double x = c1 * lroots[i] + c2;
      double fx = evaluateFunction(x);
      sum += weight[i] * fx;
    }

    return c1 * sum;
  }
  double evaluateFunction(double x) {
    return MathParser().evaluar(function, 'x', x);
  }
  String? validateParameters() {
    if (lowerLimit >= upperLimit) {
      return "El límite inferior debe ser menor que el límite superior";
    }
    if (n <= 0) {
      return "n debe ser mayor que 0";
    }
    if (dn < 0) {
      return "dn debe ser no negativo";
    }
    try {
      evaluateFunction((lowerLimit + upperLimit) / 2);
    } catch (e) {
      return "La función no es válida en el intervalo especificado: $e";
    }

    return null;
  }

  String getMethodDescription() {
    return '''
Propósito: Calcular integrales definidas con máxima precisión y mínimas evaluaciones de función.

Fundamento: Selecciona puntos de evaluación óptimos (nodos) y pesos para maximizar el grado de exactitud. Coloca los nodos en las raíces de polinomios ortogonales (Legendre).

Características Clave:

    Grado de precisión: 2n-1 (para n puntos integra exactamente polinomios de grado ≤ 2n-1)

    Nodos: Raíces de polinomios de Legendre

    Pesos: Calculados para maximizar exactitud

Ventaja: Máxima precisión con mínimo de evaluaciones, ideal para funciones costosas de computar.
''';
  }
}