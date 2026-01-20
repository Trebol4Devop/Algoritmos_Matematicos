import 'dart:math';
import 'MathParser.Dart';
import 'MethodClass.Dart';
import 'MethodUtils.Dart';

class BisectClass extends MethodClass {
  String function;
  double a;
  double b;
  double tol;
  int n;
  int dn;
  List<Map<String, dynamic>> resultTable;
  
  BisectClass({
    this.function = "",
    this.a = 0.0,
    this.b = 0.0,
    this.tol = 0.0,
    this.n = 0,
    this.dn = 0,
    List<Map<String, dynamic>>? resultTable,
    int id = 1,
    String title = "Método de Bisección",
    String subtitle = "Encuentra raíces por bisección de intervalos",
    String index = "BIS",
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

  bool validarFuncion(String funcion) {
    List<double> pruebas = [1.0, 2.0, -1.0, 0.5, 10.0];
    return MethodUtils.validarFuncion(funcion, 'x', pruebas);
  }

  void bisectMethod() {
    initialize();
    resultTable.clear();

    try {
      if (function.isEmpty) {
        message = "Error: debe proporcionar una función";
        return;
      }

      if (a >= b) {
        message = "Error: el límite 'a' debe ser menor que 'b'";
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

      String? errorValidacion = MethodUtils.validarParametros(function, tol, n, [a, b], 'x');
      if (errorValidacion != null) {
        message = errorValidacion;
        return;
      }

      double fa, fb;
      try {
        fa = evaluarFuncion(function, a);
        fb = evaluarFuncion(function, b);
      } catch (e) {
        message = "Error: no se puede evaluar la función en el intervalo dado.\nDetalle: $e";
        return;
      }

      if (!MethodUtils.verificarBolzano(function, 'x', a, b)) {
        message = "Error: f(a) = ${MethodUtils.redondear(fa, dn)} y f(b) = ${MethodUtils.redondear(fb, dn)} tienen el mismo signo.\n"
                  "No se puede garantizar que exista una raíz en [$a, $b]";
        return;
      }

      if (fa == 0) {
        success = true;
        result = _redondear(a);
        message = "Raíz exacta encontrada: x = $result (f(x) = 0)";
        iterations = 0;
        return;
      }

      if (fb == 0) {
        success = true;
        result = _redondear(b);
        message = "Raíz exacta encontrada: x = $result (f(x) = 0)";
        iterations = 0;
        return;
      }

      double aActual = a;
      double bActual = b;
      double faActual = fa;
      double fbActual = fb;
      int i = 1;

      while (i <= n) {
        double p = aActual + (bActual - aActual) / 2.0;
        double fp;
        
        try {
          fp = evaluarFuncion(function, p);
        } catch (e) {
          message = "Error al evaluar f($p): $e";
          return;
        }

        double error = (bActual - aActual).abs() / 2.0;

        Map<String, dynamic> iteracion = {
          "i": i,
          "a": MethodUtils.redondear(aActual, dn),
          "b": MethodUtils.redondear(bActual, dn),
          "p": MethodUtils.redondear(p, dn),
          "fa": MethodUtils.redondear(faActual, dn),
          "fb": MethodUtils.redondear(fbActual, dn),
          "fp": MethodUtils.redondear(fp, dn),
          "fa_fp": MethodUtils.redondear(faActual * fp, dn),
          "error": MethodUtils.redondear(error, dn)
        };
        resultTable.add(iteracion);

        if (fp.abs() < 0.00000000000001) {
          success = true;
          result = MethodUtils.redondear(p, dn);
          message = "Raíz exacta encontrada en iteración $i";
          iterations = i;
          return;
        }

        if (error < tol) {
          success = true;
          result = MethodUtils.redondear(p, dn);
          message = "Solución aproximada (error < tolerancia) en iteración $i\n"
                    "Error final: ${MethodUtils.redondear(error, dn)}";
          iterations = i;
          return;
        }

        if (faActual * fp > 0) {
          aActual = p;
          faActual = fp;
        } else {
          bActual = p;
          fbActual = fp;
        }

        i++;
      }

      double pFinal = aActual + (bActual - aActual) / 2.0;
      double errorFinal = (bActual - aActual).abs() / 2.0;
      result = MethodUtils.redondear(pFinal, dn);
      message = "Máximo de iteraciones ($n) alcanzado sin convergencia\n"
                "Mejor aproximación: $result\n"
                "Error estimado: ${MethodUtils.redondear(errorFinal, dn)}";
      iterations = n;
      success = true;

    } catch (e) {
      message = "Error durante la ejecución: ${e.toString()}";
      success = false;
    }
  }

  double _redondear(double valor) {
    return MethodUtils.redondear(valor, dn);
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

  Map<String, dynamic> analizarFuncion() {
    Map<String, dynamic> analisis = {};
    
    try {
      double fa = evaluarFuncion(function, a);
      double fb = evaluarFuncion(function, b);
      
      analisis['f(a)'] = MethodUtils.redondear(fa, dn);
      analisis['f(b)'] = MethodUtils.redondear(fb, dn);
      analisis['f(a) * f(b)'] = MethodUtils.redondear(fa * fb, dn);
      
      if (fa * fb < 0) {
        analisis['bolzano'] = true;
        analisis['motivo'] = "f(a) y f(b) tienen signos opuestos - Raíz garantizada";
      } else if (fa * fb > 0) {
        analisis['bolzano'] = false;
        analisis['motivo'] = "f(a) y f(b) tienen el mismo signo - No se garantiza raíz";
      } else {
        analisis['bolzano'] = true;
        analisis['motivo'] = "f(a) o f(b) es cero - Raíz exacta encontrada";
      }
      
      double medio = (a + b) / 2.0;
      double fmedio = evaluarFuncion(function, medio);
      analisis['f(medio)'] = MethodUtils.redondear(fmedio, dn);
      analisis['punto_medio'] = MethodUtils.redondear(medio, dn);
      
      try {
        double derivada = MethodUtils.calcularDerivadaNumerica(function, 'x', medio);
        
        analisis['f\'(medio)'] = MethodUtils.redondear(derivada, dn);
        if (derivada > 0) {
          analisis['monotonia'] = "Creciente";
        } else if (derivada < 0) {
          analisis['monotonia'] = "Decreciente";
        } else {
          analisis['monotonia'] = "Constante o punto crítico";
        }
      } catch (e) {
        analisis['f\'(medio)'] = 'No calculable';
        analisis['monotonia'] = 'No se pudo determinar';
      }
      
    } catch (e) {
      analisis['error'] = e.toString();
    }
    
    return analisis;
  }

  @override
  String getResultSummary() {
    return '${super.getResultSummary()}\nFunció: $function\nIntervalo: [$a, $b]\nTolerancia: $tol';
  }

  String getMethodDescription() {
    return '''
Propósito: Encontrar una raíz (solución) de una ecuación f(x) = 0.

Premisa Fundamental: Requiere un intervalo inicial [a, b] donde la función f(x) cambie de signo (f(a) · f(b) < 0), garantizando así la existencia de al menos una raíz.

Característica Principal: En cada iteración, el intervalo que contiene la raíz se reduce a la mitad, convergiendo de forma segura pero lenta hacia la solución.c
''';
  }
}
