import 'dart:math';
import 'MathParser.Dart';
import 'MethodClass.Dart';
import 'MethodUtils.Dart';

class FalsePositionClass extends MethodClass {
  String function;
  double a;
  double b;
  double tol;
  int n;
  int dn;
  List<Map<String, dynamic>> resultTable;
  
  late MathParser _parser;

  FalsePositionClass({
    this.function = "",
    this.a = 0.0,
    this.b = 0.0,
    this.tol = 0.0,
    this.n = 0,
    this.dn = 0,
    List<Map<String, dynamic>>? resultTable,
    int id = 6,
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

  bool validarFuncion() {
    try {
      // Validar función en los puntos iniciales
      double fa = evaluarFuncion(function, a);
      double fb = evaluarFuncion(function, b);
      
      if (fa.isNaN || fa.isInfinite || fb.isNaN || fb.isInfinite) {
        return false;
      }
      
      // Verificar cambio de signo (Teorema de Bolzano)
      return fa * fb < 0;
    } catch (e) {
      return false;
    }
  }

  void falsePositionMethod() {
    initialize();
    resultTable.clear();

    try {
      // Validaciones iniciales
      if (function.isEmpty) {
        message = "Error: debe proporcionar una función f(x)";
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

      if (a == b) {
        message = "Error: los puntos a y b deben ser diferentes";
        return;
      }

      double fa, fb;
      try {
        fa = evaluarFuncion(function, a);
        fb = evaluarFuncion(function, b);
        
        if (fa.isNaN || fa.isInfinite || fb.isNaN || fb.isInfinite) {
          message = "Error: la función produce valores no válidos en los puntos iniciales";
          return;
        }

        if (fa * fb >= 0) {
          message = "Error: no hay cambio de signo en el intervalo [${_redondear(a)}, ${_redondear(b)}]\n"
                    "f(${_redondear(a)}) = ${_redondear(fa)}, f(${_redondear(b)}) = ${_redondear(fb)}";
          return;
        }
      } catch (e) {
        message = "Error: no se puede evaluar la función en los puntos iniciales.\nDetalle: $e";
        return;
      }

      double aActual = a;
      double bActual = b;
      double faActual = fa;
      double fbActual = fb;
      double cAnterior = a;
      int i = 1;
      bool converged = false;

      Map<String, dynamic> iteracionInicial = {
        "i": 0,
        "a": _redondear(aActual),
        "b": _redondear(bActual),
        "f(a)": _redondear(faActual),
        "f(b)": _redondear(fbActual),
        "c": "-",
        "f(c)": "-",
        "error": "-"
      };
      resultTable.add(iteracionInicial);

      while (i <= n && !converged) {
        try {
          double c = (aActual * fbActual - bActual * faActual) / (fbActual - faActual);
          double fc = evaluarFuncion(function, c);

          if (fc.isNaN || fc.isInfinite) {
            message = "Error: la función produce valores no válidos en la iteración $i";
            return;
          }

          double error = (c - cAnterior).abs();
          cAnterior = c;

          Map<String, dynamic> iteracion = {
            "i": i,
            "a": _redondear(aActual),
            "b": _redondear(bActual),
            "f(a)": _redondear(faActual),
            "f(b)": _redondear(fbActual),
            "c": _redondear(c),
            "f(c)": _redondear(fc),
            "error": _redondear(error)
          };
          resultTable.add(iteracion);

          if (error < tol || fc.abs() < tol) {
            success = true;
            result = _redondear(c);
            if (fc.abs() < tol) {
              message = "Solución exacta encontrada (f(c) ≈ 0) en iteración $i\n"
                        "f(c) = ${_redondear(fc)}";
            } else {
              message = "Solución aproximada (error < tolerancia) en iteración $i\n"
                        "Error final: ${_redondear(error)}\n"
                        "f(c) = ${_redondear(fc)}";
            }
            iterations = i;
            converged = true;
          } else {
            if (fc * faActual < 0) {
              bActual = c;
              fbActual = fc;
            } else {
              aActual = c;
              faActual = fc;
            }
            i++;
          }
        } catch (e) {
          message = "Error en la iteración $i: ${e.toString()}";
          return;
        }
      }

      if (!converged) {
        var ultimaIteracion = resultTable.last;
        result = ultimaIteracion["c"];
        message = "Máximo de iteraciones ($n) alcanzado sin convergencia\n"
                  "Mejor aproximación: $result\n"
                  "f(c) = ${ultimaIteracion["f(c)"]}\n"
                  "Error estimado: ${ultimaIteracion["error"]}";
        iterations = n;
        success = false;
      }

    } catch (e) {
      message = "Error durante la ejecución: ${e.toString()}";
      success = false;
    }
  }

  Map<String, dynamic> analizarConvergencia() {
    Map<String, dynamic> analisis = {};
    
    try {
      double fa = evaluarFuncion(function, a);
      double fb = evaluarFuncion(function, b);
      
      analisis['f(a)'] = _redondear(fa);
      analisis['f(b)'] = _redondear(fb);
      analisis['cambio_signo'] = (fa * fb < 0);
      
      if (!analisis['cambio_signo']) {
        analisis['converge'] = false;
        analisis['motivo'] = "No hay cambio de signo en el intervalo (Bolzano no aplica)";
      } else {
        analisis['converge'] = true;
        analisis['motivo'] = "Condiciones iniciales favorables (Bolzano aplica)";
      }
      
      try {
        double c = (a * fb - b * fa) / (fb - fa);
        double fc = evaluarFuncion(function, c);
        analisis['primera_aproximacion'] = _redondear(c);
        analisis['f(c)'] = _redondear(fc);
        
        // Análisis de la pendiente de la recta secante
        double pendiente = (fb - fa) / (b - a);
        analisis['pendiente_secante'] = _redondear(pendiente);
        
        if (pendiente.abs() < 1e-10) {
          analisis['advertencia'] = "Pendiente muy cercana a cero, posible convergencia lenta";
        }
      } catch (e) {
        analisis['primera_aproximacion'] = 'No calculable';
      }
    } catch (e) {
      analisis['error'] = e.toString();
    }
    
    return analisis;
  }

  List<Map<String, double>> obtenerPuntosFuncion({int numPuntos = 100}) {
    List<Map<String, double>> puntos = [];
    
    double margen = 1.0;
    double inicio = min(a, b) - margen;
    double fin = max(a, b) + margen;
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

  List<Map<String, double>> obtenerPuntosInterpolaciones() {
    List<Map<String, double>> puntosInterpolaciones = [];
    
    for (int i = 1; i < resultTable.length; i++) {
      var iter = resultTable[i];
      var iterAnterior = resultTable[i-1];
      
      if (iterAnterior['a'] is double && iterAnterior['b'] is double && 
          iterAnterior['f(a)'] is double && iterAnterior['f(b)'] is double) {
        
        double a = iterAnterior['a'];
        double b = iterAnterior['b'];
        double fa = iterAnterior['f(a)'];
        double fb = iterAnterior['f(b)'];
        
        double m = (fb - fa) / (b - a);
        
        // Generar puntos para la línea de interpolación
        double inicio = min(a, b) - 0.5;
        double fin = max(a, b) + 0.5;
        int numPuntos = 20;
        
        for (int j = 0; j <= numPuntos; j++) {
          double x = inicio + j * (fin - inicio) / numPuntos;
          double y = fa + m * (x - a);
          puntosInterpolaciones.add({
            'x': x,
            'y': y,
            'iteracion': i.toDouble()
          });
        }
      }
    }
    
    return puntosInterpolaciones;
  }

  List<Map<String, dynamic>> obtenerIntervalos() {
    List<Map<String, dynamic>> intervalos = [];
    
    for (var iter in resultTable) {
      if (iter['a'] is double && iter['b'] is double) {
        intervalos.add({
          'a': iter['a'],
          'b': iter['b'],
          'iteracion': iter['i']
        });
      }
    }
    
    return intervalos;
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
      'a': a,
      'b': b,
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
                    'Intervalo inicial: [${_redondear(a)}, ${_redondear(b)}]\n'
                    'Tolerancia: $tol';
    
    if (success && resultTable.isNotEmpty && resultTable.length > 1) {
      var ultimaIteracion = resultTable.last;
      summary += '\nf(c) final: ${ultimaIteracion["f(c)"]}';
    }
    
    return summary;
  }

  String getMethodDescription() {
    return '''
Propósito: Encontrar raíces de una función f(x) = 0.

Fundamento: Combina la garantía de convergencia del método de bisección con la velocidad del método de la secante. Utiliza una recta secante entre dos puntos con signos opuestos para estimar la raíz.

Estrategia: Mantiene siempre un intervalo [a, b] donde f(a) * f(b) < 0 (como la bisección), pero en lugar de usar el punto medio, calcula la intersección de la secante que une (a, f(a)) y (b, f(b)) con el eje x.

Fórmula Central: c = [a·f(b) - b·f(a)] / [f(b) - f(a)]

Característica Principal: Generalmente converge más rápido que la bisección pura al usar información de la función, pero mantiene la seguridad de que la raíz permanece bracketeada en un intervalo.

''';
  }
}