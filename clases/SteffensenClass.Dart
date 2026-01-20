import 'dart:math';
import 'MathParser.Dart';
import 'MethodClass.Dart';
import 'MethodUtils.Dart';

/// Implementación del método de Steffensen (aceleración de convergencia)
class SteffensenClass extends MethodClass {
  String function;
  double p0;
  double tol;
  int n;
  int dn;
  List<Map<String, dynamic>> resultTable;
  
  SteffensenClass({
    this.function = "",
    this.p0 = 0.0,
    this.tol = 0.0,
    this.n = 0,
    this.dn = 0,
    List<Map<String, dynamic>>? resultTable,
    int id = 7,
    String title = "Método de Steffensen",
    String subtitle = "Aceleración de convergencia para punto fijo",
    String index = "STE",
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
    return MethodUtils.validarFuncionEnPunto(function, 'x', p0);
  }

  void steffensenMethod() {
    initialize();
    resultTable.clear();

    try {
      String? errorValidacion = MethodUtils.validarParametros(
        function, tol, n, [p0], 'x'
      );
      if (errorValidacion != null) {
        message = errorValidacion;
        return;
      }
      double g_p0;
      try {
        g_p0 = evaluarFuncion(function, p0);
        
        if (g_p0.isNaN || g_p0.isInfinite) {
          message = "Error: la función produce valores no válidos en p0";
          return;
        }
      } catch (e) {
        message = "Error: no se puede evaluar la función en p0 = $p0.\nDetalle: $e";
        return;
      }
      double current_p0 = p0;
      int i = 1;
      bool converged = false;

      while (i <= n && !converged) {
        try {
          double p1 = evaluarFuncion(function, current_p0);
          double p2 = evaluarFuncion(function, p1);
          double denominador = p2 - 2.0 * p1 + current_p0;
          
          if (denominador.abs() < 1e-15) {
            message = "Error: denominador cero en la iteración $i. El método no puede continuar.\n"
                      "Denominador = $denominador\n"
                      "Mejor aproximación: ${_redondear(p2)}";
            result = _redondear(p2);
            success = false;
            iterations = i;
            return;
          }
          double d = (p1 - current_p0) * (p1 - current_p0) / denominador;
          double p_next = current_p0 - d;
          double g_p_next = evaluarFuncion(function, p_next);

          if (g_p_next.isNaN || g_p_next.isInfinite) {
            message = "Error: la función produce valores no válidos en la iteración $i";
            return;
          }
          double error = d.abs();
          Map<String, dynamic> iteracion = {
            "i": i,
            "p0": _redondear(current_p0),
            "p1": _redondear(p1),
            "p2": _redondear(p2),
            "p_next": _redondear(p_next),
            "error": _redondear(error)
          };
          resultTable.add(iteracion);
          if (error < tol) {
            success = true;
            result = _redondear(p_next);
            message = "Solución aproximada (error < tolerancia) en iteración $i\n"
                      "Error final: ${_redondear(error)}\n"
                      "p = $result";
            iterations = i;
            converged = true;
          } else {
            current_p0 = p_next;
            i++;
          }
        } catch (e) {
          message = "Error en la iteración $i: ${e.toString()}";
          return;
        }
      }
      if (!converged) {
        var ultimaIteracion = resultTable.isNotEmpty ? resultTable.last : null;
        if (ultimaIteracion != null) {
          result = ultimaIteracion["p_next"];
          message = "Máximo de iteraciones ($n) alcanzado sin convergencia\n"
                    "Mejor aproximación: $result\n"
                    "Error estimado: ${ultimaIteracion["error"]}";
        } else {
          result = _redondear(current_p0);
          message = "Máximo de iteraciones ($n) alcanzado sin convergencia\n"
                    "Mejor aproximación: $result";
        }
        iterations = n;
        success = false;
      }

    } catch (e) {
      message = "Error durante la ejecución: ${e.toString()}";
      success = false;
    }
  }
  Map<String, dynamic> analizarConvergencia() {
    Map<String, dynamic> analisis = MethodUtils.analizarConvergenciaBasica(function, 'x', p0, tol);
    try {
      double g_p0 = evaluarFuncion(function, p0);
      double g_g_p0 = evaluarFuncion(function, g_p0);
      
      analisis['g(p0)'] = _redondear(g_p0);
      analisis['g(g(p0))'] = _redondear(g_g_p0);
      double denominador = g_g_p0 - 2.0 * g_p0 + p0;
      if (denominador.abs() > 1e-15) {
        double aceleracion = (g_p0 - p0) * (g_p0 - p0) / denominador;
        analisis['aceleracion_inicial'] = _redondear(aceleracion);
        
        if (aceleracion.abs() < 1) {
          analisis['tipo_convergencia'] = "Alta aceleración esperada";
        } else {
          analisis['tipo_convergencia'] = "Aceleración moderada";
        }
      } else {
        analisis['aceleracion_inicial'] = 'Indeterminada (denominador cero)';
        analisis['tipo_convergencia'] = 'No se pudo determinar (denominador cero)';
      }
    } catch (e) {
      analisis['error_especifico'] = e.toString();
    }
    
    return analisis;
  }
  List<Map<String, double>> obtenerPuntosFuncion({int numPuntos = 100}) {
    double margen = 2.0;
    double inicio = p0 - margen;
    double fin = p0 + margen;
    
    return MethodUtils.obtenerPuntosFuncion(function, 'x', inicio, fin, numPuntos: numPuntos);
  }
  List<Map<String, double>> obtenerPuntosIdentidad({int numPuntos = 100}) {
    double margen = 2.0;
    double inicio = p0 - margen;
    double fin = p0 + margen;
    
    return MethodUtils.obtenerPuntosIdentidad(inicio, fin, numPuntos: numPuntos);
  }
  List<Map<String, dynamic>> obtenerIteracionesPuntoFijo() {
    List<Map<String, dynamic>> iteraciones = [];
    
    if (resultTable.isNotEmpty) {
      for (var iter in resultTable) {
        iteraciones.add({
          'p0': iter['p0'],
          'p1': iter['p1'],
          'p2': iter['p2'],
          'iteracion': iter['i']
        });
      }
    }
    
    return iteraciones;
  }
  double _redondear(double valor) {
    return MethodUtils.redondear(valor, dn);
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json.addAll({
      'function': function,
      'p0': p0,
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
                    'Función g(x): $function\n'
                    'Punto inicial p0: $p0\n'
                    'Tolerancia: $tol';
    
    if (success && resultTable.isNotEmpty) {
      var ultimaIteracion = resultTable.last;
      summary += '\nValor final: ${ultimaIteracion["p_next"]}';
    }
    
    return summary;
  }

  String getMethodDescription() {
    return '''
Propósito: Acelerar la convergencia de métodos de punto fijo para encontrar raíces de ecuaciones.

Fundamento: Combina el método de punto fijo con la extrapolación de Aitken para lograr convergencia cuadrática sin necesidad de calcular derivadas.

Característica Principal: Transforma un esquema de punto fijo de convergencia lineal en uno de convergencia cuadrática. Utiliza tres evaluaciones de función consecutivas para construir una mejor aproximación.

Fórmula Central:
Dada x_n, calcula:
a = g(x_n), b = g(a)
x_n+1 = xₙ - (a - x_n)^2 / (b - 2a + x_n)

Ventaja Clave: Logra la velocidad de convergencia del método de Newton-Raphson sin requerir el cálculo de derivadas, solo evaluaciones de la función.

Condición: Requiere que la estimación inicial esté suficientemente cerca de la raíz y que la función g(x) sea adecuada para la aceleración.
''';
  }  
}
