import 'dart:math';
import 'MathParser.Dart';
import 'MethodClass.Dart';

class NewtonRaphsonClass extends MethodClass {
  String function;
  String functionDer;
  double x0;
  double tol;
  int n;
  int dn;
  List<Map<String, dynamic>> resultTable;
  
  late MathParser _parser;

  NewtonRaphsonClass({
    this.function = "",
    this.functionDer = "",
    this.x0 = 0.0,
    this.tol = 0.0,
    this.n = 0,
    this.dn = 0,
    List<Map<String, dynamic>>? resultTable,
    int id = 4,
    String title = "",
    String subtitle = "",
    String index = "",
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

  bool validarFunciones() {
    try {
      List<double> pruebas = [x0, x0 + 1, x0 - 1];
      for (double val in pruebas) {
        double resultado = _parser.evaluar(function, 'x', val);
        if (resultado.isNaN || resultado.isInfinite) {
          return false;
        }
      }

      for (double val in pruebas) {
        double resultado = _parser.evaluar(functionDer, 'x', val);
        if (resultado.isNaN || resultado.isInfinite) {
          return false;
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  void newtonRaphsonMethod() {
    initialize();
    resultTable.clear();

    try {
      if (function.isEmpty) {
        message = "Error: debe proporcionar una función f(x)";
        return;
      }

      if (functionDer.isEmpty) {
        message = "Error: debe proporcionar la derivada f'(x)";
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

      double f0, fp0;
      try {
        f0 = evaluarFuncion(function, x0);
        fp0 = evaluarFuncion(functionDer, x0);
        
        if (f0.isNaN || f0.isInfinite || fp0.isNaN || fp0.isInfinite) {
          message = "Error: las funciones producen valores no válidos en x0";
          return;
        }

        if (fp0 == 0) {
          message = "Error: la derivada es cero en x0. El método no puede continuar.";
          return;
        }
      } catch (e) {
        message = "Error: no se pueden evaluar las funciones en x0 = $x0.\nDetalle: $e";
        return;
      }

      double xn1 = x0;
      double fxn1 = f0;
      int i = 1;
      bool converged = false;

      while (i <= n && !converged) {
        try {
          double fpxn1 = evaluarFuncion(functionDer, xn1);
          
          if (fpxn1 == 0) {
            message = "Error: la derivada es cero en la iteración $i. El método no puede continuar.";
            return;
          }

          double d = fxn1 / fpxn1;
          double xn0 = xn1;
          xn1 = xn0 - d;

          fxn1 = evaluarFuncion(function, xn1);

          if (fxn1.isNaN || fxn1.isInfinite) {
            message = "Error: la función produce valores no válidos en la iteración $i";
            return;
          }

          double error = d.abs();

          Map<String, dynamic> iteracion = {
            "i": i,
            "xn": _redondear(xn0),
            "fxn": _redondear(fxn1),
            "fpxn": _redondear(fpxn1),
            "xn1": _redondear(xn1),
            "error": _redondear(error)
          };
          resultTable.add(iteracion);

          if (error < tol) {
            success = true;
            result = _redondear(xn1);
            message = "Solución aproximada (error < tolerancia) en iteración $i\n"
                      "Error final: ${_redondear(error)}\n"
                      "f(x) = ${_redondear(fxn1)}";
            iterations = i;
            converged = true;
          } else {
            i++;
          }
        } catch (e) {
          message = "Error en la iteración $i: ${e.toString()}";
          return;
        }
      }

      if (!converged) {
        result = _redondear(xn1);
        message = "Máximo de iteraciones ($n) alcanzado sin convergencia\n"
                  "Mejor aproximación: $result\n"
                  "f(x) = ${_redondear(fxn1)}\n"
                  "Error estimado: ${_redondear((result - x0).abs())}";
        iterations = n;
        success = false;
      }

    } catch (e) {
      message = "Error durante la ejecución: ${e.toString()}";
      success = false;
    }
  }

  String calcularDerivadaNumerica() {
    try {
      return "f'(x) [numérica]";
    } catch (e) {
      return "No se pudo calcular la derivada numérica";
    }
  }

  /// Analiza la convergencia del método
  Map<String, dynamic> analizarConvergencia() {
    Map<String, dynamic> analisis = {};
    
    try {
      double f0 = evaluarFuncion(function, x0);
      double fp0 = evaluarFuncion(functionDer, x0);
      
      analisis['f(x0)'] = _redondear(f0);
      analisis['f\'(x0)'] = _redondear(fp0);
      analisis['razon_convergencia'] = _redondear(f0 / fp0);
      
      if (fp0 == 0) {
        analisis['converge'] = false;
        analisis['motivo'] = "Derivada cero en punto inicial";
      } else if (f0.abs() < tol) {
        analisis['converge'] = true;
        analisis['motivo'] = "Punto inicial ya es solución";
      } else {
        analisis['converge'] = true;
        analisis['motivo'] = "Condiciones aparentemente favorables";
      }
      
      try {
        double fpp0 = _parser.derivadaParcialNumerica(functionDer, 'x', {'x': x0});
        analisis['f\'\'(x0)'] = _redondear(fpp0);
        
        double criterio = (f0 * fpp0) / (2 * fp0 * fp0);
        analisis['criterio_convergencia'] = _redondear(criterio.abs());
        
        if (criterio.abs() < 1) {
          analisis['tipo_convergencia'] = "Probable convergencia cuadrática";
        } else {
          analisis['tipo_convergencia'] = "Convergencia lineal esperada";
        }
      } catch (e) {
        analisis['f\'\'(x0)'] = 'No calculable';
        analisis['tipo_convergencia'] = 'No se pudo determinar';
      }
      
    } catch (e) {
      analisis['error'] = e.toString();
    }
    
    return analisis;
  }

  List<Map<String, double>> obtenerPuntosFuncion({int numPuntos = 100}) {
    List<Map<String, double>> puntos = [];
    
    // Determinar rango para graficar
    double margen = 2.0;
    double inicio = x0 - margen;
    double fin = x0 + margen;
    double paso = (fin - inicio) / numPuntos;
    
    for (int i = 0; i <= numPuntos; i++) {
      double x = inicio + i * paso;
      try {
        double y = evaluarFuncion(function, x);
        if (!y.isNaN && !y.isInfinite) {
          puntos.add({'x': x, 'y': y});
        }
      } catch (e) {
      }
    }
    
    return puntos;
  }

  List<Map<String, double>> obtenerPuntosDerivada({int numPuntos = 100}) {
    List<Map<String, double>> puntos = [];
    
    double margen = 2.0;
    double inicio = x0 - margen;
    double fin = x0 + margen;
    double paso = (fin - inicio) / numPuntos;
    
    for (int i = 0; i <= numPuntos; i++) {
      double x = inicio + i * paso;
      try {
        double y = evaluarFuncion(functionDer, x);
        if (!y.isNaN && !y.isInfinite) {
          puntos.add({'x': x, 'y': y});
        }
      } catch (e) {
      }
    }
    
    return puntos;
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
      'functionDer': functionDer,
      'x0': x0,
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
                    'Derivada: $functionDer\n'
                    'Punto inicial: $x0\n'
                    'Tolerancia: $tol';
    
    if (success && resultTable.isNotEmpty) {
      var ultimaIteracion = resultTable.last;
      summary += '\nValor final de f(x): ${ultimaIteracion["fxn"]}';
    }
    
    return summary;
  }

  String getMethodDescription() {
    return '''
Propósito: Encontrar raíces de una función f(x) = 0 de forma muy eficiente.

Fundamento: Utiliza la linealización (aproximación por recta tangente) para mejorar iterativamente una estimación de la raíz. Geométricamente, en cada paso se sigue la tangente a la curva hasta su intersección con el eje x.

Característica Principal: En cada iteración, el intervalo que contiene la raíz se reduce a la mitad, convergiendo de forma segura pero lenta hacia la solución.

Elementos Requeridos:

    La función f(x) cuya raíz se busca.

    Su derivada f'(x).

    Una aproximación inicial x₀ cercana a la raíz verdadera.

Condición Clave: La convergencia es extremadamente rápida (cuadrática) cuando la estimación inicial es buena y f'(x) ≠ 0 en la región de interés.
''';
  }
}
