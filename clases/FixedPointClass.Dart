import 'dart:math';
import 'MathParser.Dart';
import 'MethodClass.Dart';

/// Implementación del método de punto fijo
class FixedPointClass extends MethodClass {
  String function;
  double x0;
  double tol;
  int n;
  int dn;
  List<Map<String, dynamic>> resultTable;
  
  late MathParser _parser;

  FixedPointClass({
    this.function = "",
    this.x0 = 0.0,
    this.tol = 0.0,
    this.n = 0,
    this.dn = 0,
    List<Map<String, dynamic>>? resultTable,
    int id = 2,
    String title = "Método de Punto Fijo",
    String subtitle = "Encuentra raíces por iteración de punto fijo",
    String index = "FP",
  }) : resultTable = resultTable ?? [] {
    this.id = id;
    this.title = title;
    this.subtitle = subtitle;
    this.index = index;
    _parser = MathParser();
  }

  @override
  void initialize() {
    super.initialize();
    resultTable.clear();
  }

  double evaluarFuncion(String funcion, double x) {
    return _parser.evaluar(funcion, 'x', x);
  }

  void fixedPointMethod() {
    initialize();
    resultTable.clear();

    try {
      if (function.isEmpty) {
        message = "Error: debe proporcionar una función g(x)";
        return;
      }

      if (tol <= 0) {
        message = "Error: la tolerancia debe ser mayor que 0";
        return;
      }

      if (n <= 0) {
        message = "Error: el número máximo de iteraciones debe ser mayor que 0";
        return;
      }
      double gx0;
      try {
        gx0 = evaluarFuncion(function, x0);
        if (gx0.isNaN || gx0.isInfinite) {
          message = "Error: la función produce valores no válidos en x0";
          return;
        }
      } catch (e) {
        message = "Error: no se puede evaluar la función en x0 = $x0.\nDetalle: $e";
        return;
      }
      double p0 = x0;
      double p = 0.0;
      int i = 1;
      bool converged = false;

      while (i <= n && !converged) {
        try {
          p = evaluarFuncion(function, p0);
          if (p.isNaN || p.isInfinite) {
            message = "Error: la función produce valores no válidos en la iteración $i";
            return;
          }
        } catch (e) {
          message = "Error al evaluar g($p0) en iteración $i: $e";
          return;
        }

        double error = (p - p0).abs();

        Map<String, dynamic> iteracion = {
          "i": i,
          "xn": _redondear(p0),
          "gxn": _redondear(p),
          "error": _redondear(error)
        };
        resultTable.add(iteracion);

        if (error < tol) {
          success = true;
          result = _redondear(p);
          message = "Solución aproximada (error < tolerancia) en iteración $i\n"
                    "Error final: ${_redondear(error)}";
          iterations = i;
          converged = true;
        } else {
          p0 = p;
          i++;
        }
      }

      if (!converged) {
        result = _redondear(p);
        message = "Máximo de iteraciones ($n) alcanzado sin convergencia\n"
                  "Mejor aproximación: $result\n"
                  "Error estimado: ${_redondear((p - p0).abs())}";
        iterations = n;
        success = false;
      }

    } catch (e) {
      message = "Error durante la ejecución: ${e.toString()}";
      success = false;
    }
  }
  double _redondear(double valor) {
    if (dn <= 0) return valor;
    if (valor.isNaN || valor.isInfinite) return valor;
    
    double factor = pow(10, dn).toDouble();
    return (valor * factor).roundToDouble() / factor;
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json.addAll({
      'function': function,
      'x0': x0,
      'tol': tol,
      'n': n,
      'dn': dn,
      'resultTable': resultTable,
    });
    return json;
  }
  Map<String, dynamic> analizarConvergencia() {
    Map<String, dynamic> analisis = {};
    
    try {
      double gx0 = evaluarFuncion(function, x0);
      
      analisis['g(xo)'] = _redondear(gx0);
      analisis['xo'] = _redondear(x0);

      try {
        double h = 0.0001;
        double gx0_plus = evaluarFuncion(function, x0 + h);
        double gx0_minus = evaluarFuncion(function, x0 - h);
        double derivada = (gx0_plus - gx0_minus) / (2 * h);
        
        analisis['g\'(xo)'] = _redondear(derivada);
        analisis['|g\'(xo)|'] = _redondear(derivada.abs());
        
        if (derivada.abs() < 1) {
          analisis['converge'] = true;
          analisis['motivo'] = "|g'(xo)| < 1 - Convergencia garantizada";
        } else {
          analisis['converge'] = true;
          analisis['motivo'] = "|g'(xo)| ≥ 1 - Convergencia no garantizada";
        }
      } catch (e) {
        analisis['g\'(xo)'] = 'No calculable';
        analisis['converge'] = true;
        analisis['motivo'] = 'No se pudo calcular la derivada';
      }
      
    } catch (e) {
      analisis['error'] = e.toString();
    }
    
    return analisis;
  }

  @override
  String getResultSummary() {
    return '${super.getResultSummary()}\nFunción: $function\nPunto inicial: $x0\nTolerancia: $tol';
  }

    String getMethodDescription() {
    return '''
Propósito: Encontrar una solución (punto fijo) de una ecuación de la forma x = g(x).

Fundamento: Se transforma la ecuación original f(x) = 0 en una equivalente x = g(x) mediante reordenamiento algebraico. La solución buscada es un valor x* tal que al aplicarlo a g(x), se obtenga el mismo valor (x* = g(x*)).

Condición Clave: La convergencia del método está sujeta a que la función g(x) sea una contracción en un intervalo que contenga al punto fijo. Esto generalmente requiere que |g'(x)| < 1 en dicho intervalo.

Concepto Central: Este método genera una sucesión de aproximaciones donde cada nuevo valor se calcula directamente como x_{n+1}= g(x_n), partiendo de una estimación inicial.
''';
  }
}
