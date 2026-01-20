import 'MethodClass.Dart';

// Clase para la derivación numérica
class NumericalDerivationClass extends MethodClass {
  int n;
  double lowerLimit;
  double h;
  List<List<double>> dataTable;
  String gradeDerivation;
  String typeDerivation;
  int dn;

  NumericalDerivationClass({
    this.n = 0,
    this.lowerLimit = 0.0,
    this.h = 0.0,
    this.dataTable = const [],
    this.gradeDerivation = "",
    this.typeDerivation = "",
    this.dn = 0
  });

  @override
  void initialize() {
    super.initialize();
    success = false;
    result = 0.0;
    message = "";
    iterations = 0;
  }

  void numericalDerivationMethod() {
    try {
      initialize();
      
      if (n < 2 || n > 7) {
        message = "Error: n debe estar entre 2 y 7";
        success = false;
        return;
      }

      List<double> x = [];
      List<double> f = [];
      
      for (int i = 0; i < n; i++) {
        if (dataTable.length > i && dataTable[i].length >= 2) {
          x.add(dataTable[i][0]);
          f.add(dataTable[i][1]);
        }
      }

      if (x.length != n || f.length != n) {
        message = "Error: La tabla de datos no tiene la cantidad correcta de puntos";
        success = false;
        return;
      }

      int k = _parseGradeDerivation(gradeDerivation);
      if (k < 1 || k > 4) {
        message = "Error: El orden de derivación debe estar entre 1 y 4";
        success = false;
        return;
      }

      int t = _parseTypeDerivation(typeDerivation);
      if (t < 1 || t > 3) {
        message = "Error: El tipo de derivación debe ser 1 (adelante), 2 (centrada) o 3 (atrás)";
        success = false;
        return;
      }

      double derivationResult = 0.0;
      double c = lowerLimit;

      switch (k) {
        case 1:
          derivationResult = _calculateFirstDerivative(n, t, f, h, c);
          break;
        case 2:
          derivationResult = _calculateSecondDerivative(n, t, f, h, c);
          break;
        case 3:
          derivationResult = _calculateThirdDerivative(n, t, f, h, c);
          break;
        case 4:
          derivationResult = _calculateFourthDerivative(n, t, f, h, c);
          break;
      }

      result = derivationResult;
      success = true;
      
      String prime = _getPrimeNotation(k);
      message = "f$prime($c) = ${result.toStringAsFixed(dn)}";
      
    } catch (e) {
      success = false;
      message = "Error en el cálculo: $e";
    }
  }

  int _parseGradeDerivation(String grade) {
    switch (grade.toLowerCase()) {
      case "primera": return 1;
      case "segunda": return 2;
      case "tercera": return 3;
      case "cuarta": return 4;
      default: return int.tryParse(grade) ?? 1;
    }
  }

  int _parseTypeDerivation(String type) {
    switch (type.toLowerCase()) {
      case "adelante": return 1;
      case "centrada": return 2;
      case "atras": return 3;
      default: return int.tryParse(type) ?? 1;
    }
  }

  String _getPrimeNotation(int k) {
    switch (k) {
      case 1: return "'";
      case 2: return "''";
      case 3: return "'''";
      case 4: return "(4)";
      default: return "";
    }
  }

  double _calculateFirstDerivative(int n, int t, List<double> f, double h, double c) {
    switch (n) {
      case 3:
        switch (t) {
          case 1:
            c = f[0];
            return (-3.0 / (2.0 * h)) * f[0] + (2.0 / h) * f[1] - (1.0 / (2.0 * h)) * f[2];
          case 2:
            c = f[1];
            return (-1.0 / (2.0 * h)) * f[0] + (1.0 / (2.0 * h)) * f[2];
          case 3:
            c = f[2];
            double hNeg = -h;
            return (-3.0 / (2.0 * hNeg)) * f[2] + (2.0 / hNeg) * f[1] - (1.0 / (2.0 * hNeg)) * f[0];
        }
        break;

      case 4:
        switch (t) {
          case 1:
            c = f[0];
            return (-11.0 / (6.0 * h)) * f[0] + (3.0 / h) * f[1] - (3.0 / (2.0 * h)) * f[2] + (1.0 / (3.0 * h)) * f[3];
          case 3:
            c = f[3];
            double hNeg = -h;
            return (-11.0 / (6.0 * hNeg)) * f[3] + (3.0 / hNeg) * f[2] - (3.0 / (2.0 * hNeg)) * f[1] + (1.0 / (3.0 * hNeg)) * f[0];
        }
        break;

      case 5:
        switch (t) {
          case 1:
            c = f[0];
            return (-25.0 / (12.0 * h)) * f[0] + (4.0 / h) * f[1] - (3.0 / h) * f[2] + (4.0 / (3.0 * h)) * f[3] - (1.0 / (4.0 * h)) * f[4];
          case 2:
            c = f[2];
            return (1.0 / (12.0 * h)) * f[0] - (2.0 / (3.0 * h)) * f[1] + (2.0 / (3.0 * h)) * f[3] - (1.0 / (12.0 * h)) * f[4];
          case 3:
            c = f[4];
            double hNeg = -h;
            return (-25.0 / (12.0 * hNeg)) * f[4] + (4.0 / hNeg) * f[3] - (3.0 / hNeg) * f[2] + (4.0 / (3.0 * hNeg)) * f[1] - (1.0 / (4.0 * hNeg)) * f[0];
        }
        break;
    }
    
    throw Exception("Combinación n=$n, t=$t no soportada para primera derivada");
  }

  double _calculateSecondDerivative(int n, int t, List<double> f, double h, double c) {
    switch (n) {
      case 3:
        switch (t) {
          case 1:
            c = f[0];
            return (1.0 / (h * h)) * f[0] - (2.0 / (h * h)) * f[1] + (1.0 / (h * h)) * f[2];
          case 2:
            c = f[1];
            return (1.0 / (h * h)) * f[0] - (2.0 / (h * h)) * f[1] + (1.0 / (h * h)) * f[2];
          case 3:
            c = f[2];
            double hNeg = -h;
            return (1.0 / (hNeg * hNeg)) * f[2] - (2.0 / (hNeg * hNeg)) * f[1] + (1.0 / (hNeg * hNeg)) * f[0];
        }
        break;

      case 4:
        switch (t) {
          case 1:
            c = f[0];
            return (2.0 / (h * h)) * f[0] - (5.0 / (h * h)) * f[1] + (4.0 / (h * h)) * f[2] - (1.0 / (h * h)) * f[3];
          case 3:
            c = f[3];
            double hNeg = -h;
            return (2.0 / (hNeg * hNeg)) * f[3] - (5.0 / (hNeg * hNeg)) * f[2] + (4.0 / (hNeg * hNeg)) * f[1] - (1.0 / (hNeg * hNeg)) * f[0];
        }
        break;

      case 5:
        switch (t) {
          case 1:
            c = f[0];
            return (35.0 / (12.0 * h * h)) * f[0] - (26.0 / (3.0 * h * h)) * f[1] + (19.0 / (2.0 * h * h)) * f[2] - (14.0 / (3.0 * h * h)) * f[3] + (11.0 / (12.0 * h * h)) * f[4];
          case 2:
            c = f[2];
            return (-1.0 / (12.0 * h * h)) * f[0] + (4.0 / (3.0 * h * h)) * f[1] - (5.0 / (2.0 * h * h)) * f[2] + (4.0 / (3.0 * h * h)) * f[3] - (1.0 / (12.0 * h * h)) * f[4];
          case 3:
            c = f[4];
            double hNeg = -h;
            return (35.0 / (12.0 * hNeg * hNeg)) * f[4] - (26.0 / (3.0 * hNeg * hNeg)) * f[3] + (19.0 / (2.0 * hNeg * hNeg)) * f[2] - (14.0 / (3.0 * hNeg * hNeg)) * f[1] + (11.0 / (12.0 * hNeg * hNeg)) * f[0];
        }
        break;
    }
    
    throw Exception("Combinación n=$n, t=$t no soportada para segunda derivada");
  }

  double _calculateThirdDerivative(int n, int t, List<double> f, double h, double c) {
    switch (n) {
      case 4:
        switch (t) {
          case 1:
            c = f[0];
            return (-1.0 / (h * h * h)) * f[0] + (3.0 / (h * h * h)) * f[1] - (3.0 / (h * h * h)) * f[2] + (1.0 / (h * h * h)) * f[3];
          case 3:
            c = f[3];
            double hNeg = -h;
            return (-1.0 / (hNeg * hNeg * hNeg)) * f[3] + (3.0 / (hNeg * hNeg * hNeg)) * f[2] - (3.0 / (hNeg * hNeg * hNeg)) * f[1] + (1.0 / (hNeg * hNeg * hNeg)) * f[0];
        }
        break;

      case 5:
        switch (t) {
          case 1:
            c = f[0];
            return (-5.0 / (2.0 * h * h * h)) * f[0] + (9.0 / (h * h * h)) * f[1] - (12.0 / (h * h * h)) * f[2] + (7.0 / (h * h * h)) * f[3] - (3.0 / (2.0 * h * h * h)) * f[4];
          case 2:
            c = f[2];
            return (-1.0 / (2.0 * h * h * h)) * f[0] + (1.0 / (h * h * h)) * f[1] - (1.0 / (h * h * h)) * f[3] + (1.0 / (2.0 * h * h * h)) * f[4];
          case 3:
            c = f[4];
            double hNeg = -h;
            return (-5.0 / (2.0 * hNeg * hNeg * hNeg)) * f[4] + (9.0 / (hNeg * hNeg * hNeg)) * f[3] - (12.0 / (hNeg * hNeg * hNeg)) * f[2] + (7.0 / (hNeg * hNeg * hNeg)) * f[1] - (3.0 / (2.0 * hNeg * hNeg * hNeg)) * f[0];
        }
        break;
    }
    
    throw Exception("Combinación n=$n, t=$t no soportada para tercera derivada");
  }

  double _calculateFourthDerivative(int n, int t, List<double> f, double h, double c) {
    switch (n) {
      case 5:
        switch (t) {
          case 1:
            c = f[0];
            return (1.0 / (h * h * h * h)) * f[0] - (4.0 / (h * h * h * h)) * f[1] + (6.0 / (h * h * h * h)) * f[2] - (4.0 / (h * h * h * h)) * f[3] + (1.0 / (h * h * h * h)) * f[4];
          case 2:
            c = f[2];
            return (1.0 / (h * h * h * h)) * f[0] - (4.0 / (h * h * h * h)) * f[1] + (6.0 / (h * h * h * h)) * f[2] - (4.0 / (h * h * h * h)) * f[3] + (1.0 / (h * h * h * h)) * f[4];
          case 3:
            c = f[4];
            double hNeg = -h;
            return (1.0 / (hNeg * hNeg * hNeg * hNeg)) * f[4] - (4.0 / (hNeg * hNeg * hNeg * hNeg)) * f[3] + (6.0 / (hNeg * hNeg * hNeg * hNeg)) * f[2] - (4.0 / (hNeg * hNeg * hNeg * hNeg)) * f[1] + (1.0 / (hNeg * hNeg * hNeg * hNeg)) * f[0];
        }
        break;
    }
    
    throw Exception("Combinación n=$n, t=$t no soportada para cuarta derivada");
  }

  String? validateParameters() {
    if (n < 2 || n > 7) {
      return "Error: n debe estar entre 2 y 7";
    }
    
    if (h <= 0) {
      return "Error: h debe ser mayor que 0";
    }
    
    if (dataTable.length < n) {
      return "Error: La tabla de datos no tiene suficientes puntos";
    }
    
    for (int i = 0; i < dataTable.length; i++) {
      if (dataTable[i].length < 2) {
        return "Error: Cada fila de la tabla debe tener al menos 2 valores (x, f(x))";
      }
    }
    
    return null;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'n': n,
      'lowerLimit': lowerLimit,
      'h': h,
      'dataTable': dataTable,
      'gradeDerivation': gradeDerivation,
      'typeDerivation': typeDerivation,
      'dn': dn,
    };
  }

  String getMethodDescription() {
    return '''
Diferenciación Numérica (Primer a cuarta orden)

Progresiva (Forward):

    Primer orden: f'(x) ≈ (f(x+h) - f(x))/h

    Segundo orden: f'(x) ≈ (-f(x+2h) + 4f(x+h) - 3f(x))/(2h)

    Tercer orden: f' '(x) ≈ (-f(x+3h) + 4f(x+2h) - 5f(x+h) + 2f(x))/h^2

    Cuarto orden: f' ' '(x) ≈ (-3f(x+4h) + 14f(x+3h) - 24f(x+2h) + 18f(x+h) - 5f(x))/(2h^3)

Regresiva (Backward):

    Primer orden: f'(x) ≈ (f(x) - f(x-h))/h

    Segundo orden: f'(x) ≈ (3f(x) - 4f(x-h) + f(x-2h))/(2h)

    Tercer orden: f' '(x) ≈ (2f(x) - 5f(x-h) + 4f(x-2h) - f(x-3h))/h^2

    Cuarto orden: f' ' '(x) ≈ (5f(x) - 18f(x-h) + 24f(x-2h) - 14f(x-3h) + 3f(x-4h))/(2h^3)

Centrada (Centered):

    Primer orden: f'(x) ≈ (f(x+h) - f(x-h))/(2h)

    Segundo orden: f' '(x) ≈ (f(x+h) - 2f(x) + f(x-h))/h^2

    Tercer orden: f' ' '(x) ≈ (f(x+2h) - 2f(x+h) + 2f(x-h) - f(x-2h))/(2h^3)

    Cuarto orden: f' ' ' '(x) ≈ (f(x+2h) - 4f(x+h) + 6f(x) - 4f(x-h) + f(x-2h))/h^4

Precisión: Las fórmulas centradas generalmente ofrecen mayor exactitud para el mismo espaciamiento h.
''';
  }
}