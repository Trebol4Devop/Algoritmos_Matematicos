import 'dart:math';
import 'MethodClass.Dart';
import 'MathParser.Dart';

// Clase para integración numérica por interpolación
class NumericInterpolationByInterpolationClass extends MethodClass {
  String function;
  double lowerLimit;
  double upperLimit;
  int dn;
  int n;
  double trapezoidalRule;
  double simpsonRule;
  double compositeSimpsonRule;
  double midPointRule;
  MathParser parser = MathParser();

  NumericInterpolationByInterpolationClass({
    this.function = "",
    this.lowerLimit = 0.0,
    this.upperLimit = 0.0,
    this.dn = 0,
    this.n = 0,
    this.trapezoidalRule = 0.0,
    this.simpsonRule = 0.0,
    this.compositeSimpsonRule = 0.0,
    this.midPointRule = 0.0,
  });

  @override
  void initialize() {
    super.initialize();
    success = false;
    result = 0.0;
    message = "";
    iterations = 0;
    trapezoidalRule = 0.0;
    simpsonRule = 0.0;
    compositeSimpsonRule = 0.0;
    midPointRule = 0.0;
  }

  double evaluarFuncion(double x) {
    return parser.evaluar(function, 'x', x);
  }

  String? validateParameters() {
    if (function.isEmpty) {
      return "Error: debe proporcionar una función";
    }
    if (lowerLimit >= upperLimit) {
      return "Error: el límite inferior debe ser menor que el superior";
    }
    if (n <= 0) {
      return "Error: n debe ser mayor que 0";
    }
    if (dn < 0) {
      return "Error: el número de decimales debe ser no negativo";
    }

    try {
      evaluarFuncion(lowerLimit);
      evaluarFuncion(upperLimit);
    } catch (e) {
      return "Error: la función no es válida en los límites dados: $e";
    }

    return null;
  }

  void calculateAllMethods() {
    try {
      initialize();
      String? validationResult = validateParameters();
      if (validationResult != null) {
        message = validationResult;
        success = false;
        return;
      }

      trapezoidalRuleMethod();
      simpsonRuleMethod();
      compositeSimpsonRuleMethod();
      midPointRuleMethod();

      result = trapezoidalRule;
      success = true;
      message = "Métodos de integración calculados exitosamente";
      iterations = n;

    } catch (e) {
      success = false;
      message = "Error en el cálculo: $e";
    }
  }

  void trapezoidalRuleMethod() {
    try {
      double a = lowerLimit;
      double b = upperLimit;
      double h = b - a;
      
      trapezoidalRule = (evaluarFuncion(a) + evaluarFuncion(b)) * h / 2.0;
      
    } catch (e) {
      throw Exception("Error en regla del trapecio: $e");
    }
  }

  void simpsonRuleMethod() {
    try {
      double a = lowerLimit;
      double b = upperLimit;
      double h = (b - a) / 2.0;
      double m = (a + b) / 2.0;
      
      simpsonRule = (evaluarFuncion(a) + 4.0 * evaluarFuncion(m) + evaluarFuncion(b)) * h / 3.0;
      
    } catch (e) {
      throw Exception("Error en regla de Simpson: $e");
    }
  }

  void compositeSimpsonRuleMethod() {
    try {
      double a = lowerLimit;
      double b = upperLimit;
      int n2 = n;

      if (n2 % 2 != 0) {
        n2++;
      }
      
      double h = (b - a) / n2;

      double sumImpar = 0.0;
      for (int i = 1; i < n2; i += 2) {
        double x = a + i * h;
        sumImpar += evaluarFuncion(x);
      }

      double sumPar = 0.0;
      for (int i = 2; i < n2 - 1; i += 2) {
        double x = a + i * h;
        sumPar += evaluarFuncion(x);
      }
      
      compositeSimpsonRule = (evaluarFuncion(a) + evaluarFuncion(b) + 
                              4.0 * sumImpar + 2.0 * sumPar) * h / 3.0;
      
    } catch (e) {
      throw Exception("Error en regla de Simpson compuesta: $e");
    }
  }

  void midPointRuleMethod() {
    try {
      double a = lowerLimit;
      double b = upperLimit;
      double h = (b - a) / n;
      
      double sum = 0.0;
      for (int i = 0; i < n; i++) {
        double x = a + (i + 0.5) * h;
        sum += evaluarFuncion(x);
      }
      
      midPointRule = sum * h;
      
    } catch (e) {
      throw Exception("Error en regla del punto medio: $e");
    }
  }

  void compositeTrapezoidalRuleMethod() {
    try {
      double a = lowerLimit;
      double b = upperLimit;
      double h = (b - a) / n;
      
      double sum = evaluarFuncion(a) + evaluarFuncion(b);
      for (int i = 1; i < n; i++) {
        double x = a + i * h;
        sum += 2.0 * evaluarFuncion(x);
      }
      
      trapezoidalRule = sum * h / 2.0;
      
    } catch (e) {
      throw Exception("Error en regla del trapecio compuesta: $e");
    }
  }

  String getFormattedResults() {
    StringBuffer sb = StringBuffer();
    sb.writeln("Resultados de Integración Numérica:");
    sb.writeln("Función: $function");
    sb.writeln("Intervalo: [${lowerLimit.toStringAsFixed(dn)}, ${upperLimit.toStringAsFixed(dn)}]");
    sb.writeln("Número de subdivisiones: $n");
    sb.writeln("");
    sb.writeln("Regla del trapecio: ${trapezoidalRule.toStringAsFixed(dn)}");
    sb.writeln("Regla de Simpson (1/3): ${simpsonRule.toStringAsFixed(dn)}");
    sb.writeln("Regla de Simpson compuesta: ${compositeSimpsonRule.toStringAsFixed(dn)}");
    sb.writeln("Regla del punto medio: ${midPointRule.toStringAsFixed(dn)}");
    
    return sb.toString();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'function': function,
      'lowerLimit': lowerLimit,
      'upperLimit': upperLimit,
      'n': n,
      'dn': dn,
      'trapezoidalRule': trapezoidalRule,
      'simpsonRule': simpsonRule,
      'compositeSimpsonRule': compositeSimpsonRule,
      'midPointRule': midPointRule,
    };
  }

    String getMethodDescription() {
    return '''
Propósito: Aproximar numéricamente el valor de integrales definidas mediante interpolación polinómica de la función en puntos equidistantes.

Regla del Trapecio:

    Fundamento: Aproxima el área bajo la curva mediante trapecios que unen puntos consecutivos.

    Características: Interpolación lineal entre cada par de puntos. Error O(h^2).

    Ventajas: Simple implementación. Estabilidad para funciones suaves.

Regla del Punto Medio:

    Fundamento: Utiliza rectángulos centrados en puntos medios con altura igual al valor de la función.

    Características: Evita evaluar extremos. Error O(h^2). Menos sensible a discontinuidades.

    Ventajas: Mayor precisión que trapecio para mismos puntos en ciertos casos.

Regla de Simpson:

    Fundamento: Aproxima con parábolas que interpolan tripletes de puntos.

    Características: Usa polinomios cuadráticos. Error O(h^4). Requiere número par de intervalos.

    Ventajas: Alta precisión para funciones suaves. Eficiencia computacional óptima.

General: Todos son casos particulares de fórmulas de Newton-Cotes, mejorando precisión al aumentar grado de polinomio interpolante.
''';
  }
}
