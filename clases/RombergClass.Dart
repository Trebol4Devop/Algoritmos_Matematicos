import 'dart:math';
import 'MethodClass.Dart';
import 'MathParser.Dart';

// Clase para el método de Romberg
class RombergClass extends MethodClass {
  String function;
  double lowerLimit;
  double upperLimit;
  int n;
  int dn;
  List<List<double>> resultTable;
  MathParser parser = MathParser();

  RombergClass({
    this.function = "",
    this.lowerLimit = 0.0,
    this.upperLimit = 0.0,
    this.n = 0,
    this.dn = 0,
    this.resultTable = const []
  });

  @override
  void initialize() {
    super.initialize();
    success = false;
    result = 0.0;
    message = "";
    iterations = 0;
    resultTable = [];
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

  void rombergMethod() {
    try {
      initialize();
      
      String? validationResult = validateParameters();
      if (validationResult != null) {
        message = validationResult;
        success = false;
        return;
      }
      List<List<double>> R = List.generate(n, (_) => List.filled(n, 0.0));
      resultTable = List.generate(n, (_) => List.filled(n, 0.0));

      double a = lowerLimit;
      double b = upperLimit;
      R[0][0] = (evaluarFuncion(a) + evaluarFuncion(b)) * (b - a) / 2.0;
      resultTable[0][0] = R[0][0];

      for (int i = 1; i < n; i++) {
        double h = (b - a) / pow(2, i).toDouble();
        double sum = 0.0;
        for (int k = 1; k <= pow(2, i - 1); k++) {
          double x = a + (2 * k - 1) * h;
          sum += evaluarFuncion(x);
        }

        R[i][0] = 0.5 * R[i - 1][0] + h * sum;
        resultTable[i][0] = R[i][0];
        for (int j = 1; j <= i; j++) {
          double factor = pow(4, j).toDouble();
          R[i][j] = R[i][j - 1] + (R[i][j - 1] - R[i - 1][j - 1]) / (factor - 1);
          resultTable[i][j] = R[i][j];
        }
      }

      result = R[n - 1][n - 1];
      success = true;
      message = "integral([${lowerLimit.toStringAsFixed(dn)}, ${upperLimit.toStringAsFixed(dn)}] $function dx) ≈ ${result.toStringAsFixed(dn)}";
      iterations = n;

    } catch (e) {
      success = false;
      message = "Error en el cálculo: $e";
    }
  }

  String formatResultTable() {
    if (resultTable.isEmpty) return "Tabla vacía";
    
    StringBuffer sb = StringBuffer();
    sb.writeln("Tabla de Romberg:");
    sb.writeln("┌" + "─" * (n * 15) + "┐");

    sb.write("│    i/Rj    ");
    for (int j = 0; j < n; j++) {
      sb.write("│ R$j".padRight(12));
    }
    sb.writeln("│");
    sb.writeln("├" + "─" * (n * 15) + "┤");

    for (int i = 0; i < n; i++) {
      sb.write("│ R$i ".padRight(12));
      for (int j = 0; j <= i; j++) {
        String value = resultTable[i][j].toStringAsFixed(dn);
        sb.write("│ $value".padRight(12));
      }
      for (int j = i + 1; j < n; j++) {
        sb.write("│ -".padRight(12));
      }
      sb.writeln("│");
    }
    sb.writeln("└" + "─" * (n * 15) + "┘");
    
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
      'resultTable': resultTable,
    };
  }

    String getMethodDescription() {
    return '''
Propósito: Acelerar la convergencia de la integración numérica mediante extrapolación de Richardson.

Fundamento: Combina múltiples aplicaciones del método del trapecio con diferentes tamaños de paso, utilizando extrapolación para eliminar términos de error.

Ventaja: Convergencia extremadamente rápida, obteniendo alta precisión con pocas evaluaciones de función.
  }
}