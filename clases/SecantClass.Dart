import 'dart:math';
import 'MathParser.Dart';
import 'MethodClass.Dart';
import 'MethodUtils.Dart';

/// Implementación del método de la Secante
class SecantClass extends MethodClass {
  String function;
  double xn_1;
  double xn;
  double tol;
  int n;
  int dn;
  List<Map<String, dynamic>> resultTable;
  
  SecantClass({
    this.function = "",
    this.xn_1 = 0.0,
    this.xn = 0.0,
    this.tol = 0.0,
    this.n = 0,
    this.dn = 0,
    List<Map<String, dynamic>>? resultTable,
    int id = 5,
    String title = "Método de la Secante",
    String subtitle = "Encuentra raíces sin usar derivadas",
    String index = "SEC",
  }) : resultTable = resultTable ?? [] {
    this.id = id;
    this.title = title;
    this.subtitle = subtitle;
    this.index = index;
  }

  @override
  void initialize() {
    super.initialize();
    resultTable.clear();
  }

  double evaluarFuncion(String funcion, double x) {
    return MethodUtils.evaluarFuncion(funcion, 'x', x);
  }

  bool validarFuncion() {
    List<double> pruebas = [xn_1, xn, (xn_1 + xn) / 2];
    return MethodUtils.validarFuncion(function, 'x', pruebas);
  }

  void secantMethod() {
    initialize();
    resultTable.clear();

    try {
      String? errorValidacion = MethodUtils.validarParametros(
        function, tol, n, [xn_1, xn], 'x'
      );
      if (errorValidacion != null) {
        message = errorValidacion;
        return;
      }

      if (xn_1 == xn) {
        message = "Error: los puntos iniciales xn-1 y xn deben ser diferentes";
        return;
      }

      double fxn_1, fxn;
      try {
        fxn_1 = evaluarFuncion(function, xn_1);
        fxn = evaluarFuncion(function, xn);
        
        if (fxn_1.isNaN || fxn_1.isInfinite || fxn.isNaN || fxn.isInfinite) {
          message = "Error: la función produce valores no válidos en los puntos iniciales";
          return;
        }
      } catch (e) {
        message = "Error: no se puede evaluar la función en los puntos iniciales.\nDetalle: $e";
        return;
      }

      double x0 = xn_1;
      double x1 = xn;
      double fx0 = fxn_1;
      double fx1 = fxn;
      int i = 1;
      bool converged = false;

      Map<String, dynamic> iteracionInicial = {
        "i": 0,
        "xn-1": _redondear(x0),
        "fxn-1": _redondear(fx0),
        "xn": _redondear(x1),
        "fxn": _redondear(fx1),
        "xn+1": "-",
        "error": "-"
      };
      resultTable.add(iteracionInicial);

      while (i <= n && !converged) {
        try {
          if ((fx1 - fx0) == 0) {
            message = "Error: división por cero en la iteración $i (f(xn) - f(xn-1) = 0)";
            return;
          }
          double x2 = x1 - fx1 * (x1 - x0) / (fx1 - fx0);

          double fx2 = evaluarFuncion(function, x2);

          if (fx2.isNaN || fx2.isInfinite) {
            message = "Error: la función produce valores no válidos en la iteración $i";
            return;
          }

          double error = (x2 - x1).abs();

          Map<String, dynamic> iteracion = {
            "i": i,
            "xn-1": _redondear(x0),
            "fxn-1": _redondear(fx0),
            "xn": _redondear(x1),
            "fxn": _redondear(fx1),
            "xn+1": _redondear(x2),
            "error": _redondear(error)
          };
          resultTable.add(iteracion);

          if (error < tol) {
            success = true;
            result = _redondear(x2);
            message = "Solución aproximada (error < tolerancia) en iteración $i\n"
                      "Error final: ${_redondear(error)}\n"
                      "f(x) = ${_redondear(fx2)}";
            iterations = i;
            converged = true;
          } else {
            x0 = x1;
            fx0 = fx1;
            x1 = x2;
            fx1 = fx2;
            i++;
          }
        } catch (e) {
          message = "Error en la iteración $i: ${e.toString()}";
          return;
        }
      }
      if (!converged) {
        result = _redondear(x1);
        message = "Máximo de iteraciones ($n) alcanzado sin convergencia\n"
                  "Mejor aproximación: $result\n"
                  "f(x) = ${_redondear(fx1)}\n"
                  "Error estimado: ${_redondear((result - xn).abs())}";
        iterations = n;
        success = false;
      }

    } catch (e) {
      message = "Error durante la ejecución: ${e.toString()}";
      success = false;
    }
  }
  Map<String, dynamic> analizarConvergencia() {
    return MethodUtils.analizarConvergenciaBasica(function, 'x', xn, tol);
  }
  List<Map<String, double>> obtenerPuntosFuncion({int numPuntos = 100}) {
    double margen = 2.0;
    double inicio = min(xn_1, xn) - margen;
    double fin = max(xn_1, xn) + margen;
    
    return MethodUtils.obtenerPuntosFuncion(function, 'x', inicio, fin, numPuntos: numPuntos);
  }
  List<Map<String, double>> obtenerPuntosSecantes() {
    List<Map<String, double>> puntosSecantes = [];
    
    for (int i = 1; i < resultTable.length; i++) {
      var iter = resultTable[i];
      var iterAnterior = resultTable[i-1];
      
      if (iter['xn-1'] is double && iter['xn'] is double && 
          iterAnterior['xn-1'] is double && iterAnterior['xn'] is double) {
        
        double x0 = iterAnterior['xn-1'];
        double x1 = iterAnterior['xn'];
        double fx0 = iterAnterior['fxn-1'];
        double fx1 = iterAnterior['fxn'];
        double m = (fx1 - fx0) / (x1 - x0);
        double inicio = min(x0, x1) - 0.5;
        double fin = max(x0, x1) + 0.5;
        
        for (double x = inicio; x <= fin; x += (fin - inicio) / 10) {
          double y = fx0 + m * (x - x0);
          puntosSecantes.add({
            'x': x,
            'y': y,
            'iteracion': i.toDouble()
          });
        }
      }
    }
    
    return puntosSecantes;
  }
  double _redondear(double valor) {
    return MethodUtils.redondear(valor, dn);
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json.addAll({
      'function': function,
      'xn_1': xn_1,
      'xn': xn,
      'tol': tol,
      'n': n,
      'dn': dn,
      'resultTable': resultTable,
    });
    return json;
  }

  @override
  String getResultSummary() {
    String summary = '${super.getResultSummary()}\n'
                    'Función: $function\n'
                    'Punto xn-1: $xn_1\n'
                    'Punto xn: $xn\n'
                    'Tolerancia: $tol';
    
    if (success && resultTable.isNotEmpty && resultTable.length > 1) {
      var ultimaIteracion = resultTable.last;
      summary += '\nValor final de f(x): ${ultimaIteracion["fxn"]}';
    }
    
    return summary;
  }

  String getMethodDescription() {
    return '''
Propósito: Encontrar raíces de una función f(x) = 0.

Fundamento: Es una variante del método de Newton-Raphson que evita el cálculo de la derivada. Aproxima la pendiente de la recta tangente usando una secante que pasa por los dos últimos puntos calculados.

Elementos Requeridos:

    La función f(x).

    Dos aproximaciones iniciales x_0 y x_1.

Fórmula Central: x_n+1 = x_n - f(x_n) / [ (f(x_n) - f(x_n-1)) / (x_n - x_n-1) ]

Característica Principal: Converge más rápido que la bisección pero no tan rápido como Newton-Raphson. No requiere derivadas, solo evaluaciones de la función.
''';
  }
}
