import 'dart:math';
import 'MathParser.Dart';
import 'MethodClass.Dart';
import 'MethodUtils.Dart';

/// Implementación del método de Runge-Kutta para sistemas de 2 ecuaciones
class RungeKuttaSystems_2_Class extends MethodClass {
  String function1;
  String function2;
  double lowerLimit;
  double upperLimit;
  double alpha1;
  double alpha2;
  int n;
  int dn;
  List<List<dynamic>> resultTable;
  
  RungeKuttaSystems_2_Class({
    this.function1 = "",
    this.function2 = "",
    this.lowerLimit = 0.0,
    this.upperLimit = 0.0,
    this.alpha1 = 0.0,
    this.alpha2 = 0.0,
    this.n = 0,
    this.dn = 0,
    List<List<dynamic>>? resultTable,
    int id = 1,
    String title = "Método de Runge-Kutta para Sistemas de 2 Ecuaciones",
    String subtitle = "Resuelve sistemas de EDOs usando Runge-Kutta de 4to orden",
    String index = "RK_SYS2",
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

  void rungeKuttaSystems_2_Method() {
    initialize();
    resultTable.clear();

    try {
      if (function1.isEmpty || function2.isEmpty) {
        message = "Error: debe proporcionar ambas funciones";
        return;
      }

      if (lowerLimit >= upperLimit) {
        message = "Error: el límite inferior debe ser menor que el superior";
        return;
      }

      if (n <= 0) {
        message = "Error: el número de pasos debe ser mayor que 0";
        return;
      }
      List<double> puntosPrueba = [lowerLimit, alpha1, alpha2, upperLimit, alpha1, alpha2];
      if (!MethodUtils.validarFuncion3Variables(function1, puntosPrueba) ||
          !MethodUtils.validarFuncion3Variables(function2, puntosPrueba)) {
        message = "Error: las funciones producen valores no válidos en el dominio";
        return;
      }
      double h = (upperLimit - lowerLimit) / n;
      double t = lowerLimit;
      double w1 = alpha1;
      double w2 = alpha2;

      resultTable.add([
        "0",
        MethodUtils.redondear(t, dn),
        MethodUtils.redondear(w1, dn),
        MethodUtils.redondear(w2, dn)
      ]);
      for (int i = 1; i <= n; i++) {
        double k11 = h * _evaluarFuncion(function1, t, w1, w2);
        double k12 = h * _evaluarFuncion(function2, t, w1, w2);
        
        double k21 = h * _evaluarFuncion(function1, t + h/2, w1 + k11/2, w2 + k12/2);
        double k22 = h * _evaluarFuncion(function2, t + h/2, w1 + k11/2, w2 + k12/2);
        
        double k31 = h * _evaluarFuncion(function1, t + h/2, w1 + k21/2, w2 + k22/2);
        double k32 = h * _evaluarFuncion(function2, t + h/2, w1 + k21/2, w2 + k22/2);
        
        double k41 = h * _evaluarFuncion(function1, t + h, w1 + k31, w2 + k32);
        double k42 = h * _evaluarFuncion(function2, t + h, w1 + k31, w2 + k32);

        w1 += (k11 + 2*k21 + 2*k31 + k41) / 6;
        w2 += (k12 + 2*k22 + 2*k32 + k42) / 6;
        t = lowerLimit + i * h;
        resultTable.add([
          i.toString(),
          MethodUtils.redondear(t, dn),
          MethodUtils.redondear(w1, dn),
          MethodUtils.redondear(w2, dn)
        ]);
      }

      success = true;
      iterations = n;
      result = MethodUtils.redondear(w1, dn);
      message = "u1(${MethodUtils.redondear(t, dn)}) = ${MethodUtils.redondear(w1, dn)}\n"
                "u2(${MethodUtils.redondear(t, dn)}) = ${MethodUtils.redondear(w2, dn)}";

    } catch (e) {
      message = "Error durante la ejecución: ${e.toString()}";
      success = false;
    }
  }
  double _evaluarFuncion(String funcion, double t, double u1, double u2) {
    return MethodUtils.evaluarFuncion3Variables(funcion, t, u1, u2);
  Map<String, dynamic> analizarSistema() {
    Map<String, dynamic> analisis = {};
    
    try {
      double f1Inicial = _evaluarFuncion(function1, lowerLimit, alpha1, alpha2);
      double f2Inicial = _evaluarFuncion(function2, lowerLimit, alpha1, alpha2);
      
      analisis['f1(t0, u1o, u2o)'] = MethodUtils.redondear(f1Inicial, dn);
      analisis['f2(t0, u1o, u2o)'] = MethodUtils.redondear(f2Inicial, dn);

      double h = (upperLimit - lowerLimit) / n;
      analisis['paso_h'] = MethodUtils.redondear(h, dn);

      analisis['rango_t'] = '[${MethodUtils.redondear(lowerLimit, dn)}, ${MethodUtils.redondear(upperLimit, dn)}]';
      analisis['condiciones_iniciales'] = 'u1($lowerLimit) = $alpha1, u2($lowerLimit) = $alpha2';
      analisis['numero_pasos'] = n;

      MathParser parser = MathParser();
      Set<String> varsF1 = parser.encontrarVariablesSistema(function1);
      Set<String> varsF2 = parser.encontrarVariablesSistema(function2);
      
      analisis['variables_f1'] = varsF1.toList();
      analisis['variables_f2'] = varsF2.toList();
      
    } catch (e) {
      analisis['error'] = e.toString();
    }
    
    return analisis;
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json.addAll({
      'function1': function1,
      'function2': function2,
      'lowerLimit': lowerLimit,
      'upperLimit': upperLimit,
      'alpha1': alpha1,
      'alpha2': alpha2,
      'n': n,
      'dn': dn,
      'resultTable': resultTable,
    });
    return json;
  }

  @override
  String getResultSummary() {
    if (resultTable.isEmpty) return super.getResultSummary();
    
    List<dynamic> ultimaFila = resultTable.last;
    return '${super.getResultSummary()}\n'
           'Sistema:\n'
           '  f1(t,u1,u2) = $function1\n'
           '  f2(t,u1,u2) = $function2\n'
           'Condiciones iniciales: u1($lowerLimit) = $alpha1, u2($lowerLimit) = $alpha2\n'
           'Resultado final: u1(${ultimaFila[1]}) = ${ultimaFila[2]}, u2(${ultimaFila[1]}) = ${ultimaFila[3]}';
  }
  Map<String, List<Map<String, double>>> obtenerPuntosGrafica() {
    List<Map<String, double>> puntosU1 = [];
    List<Map<String, double>> puntosU2 = [];
    
    for (List<dynamic> fila in resultTable) {
      double t = (fila[1] as double);
      double u1 = (fila[2] as double);
      double u2 = (fila[3] as double);
      
      puntosU1.add({'x': t, 'y': u1});
      puntosU2.add({'x': t, 'y': u2});
    }
    
    return {
      'u1': puntosU1,
      'u2': puntosU2
    };
  }

    String getMethodDescription() {
    return '''
Propósito: Resolver sistemas de ecuaciones diferenciales ordinarias con dos variables dependientes, aproximando simultáneamente sus soluciones con alta precisión.

Fundamento: Extiende el RK4 clásico aplicando las cuatro evaluaciones intermedias a cada ecuación del sistema, calculando pendientes ponderadas para ambas variables en cada paso.

Características:

  Evalúa ambas funciones en los mismos cuatro puntos intermedios por paso.

 Actualiza cada variable usando su conjunto único de pendientes ponderadas.

  Conserva el error de truncamiento local O(h^5) para cada variable.

  Mantiene la correlación temporal entre las variables.

Ventajas:

    Precisión coordinada en ambas soluciones.

    Captura acoplamientos e interdependencias entre variables.

    Eficiencia computacional al evaluar funciones simultáneamente.

    Ideal para sistemas dinámicos acoplados (masa-resorte, orbitales, etc.).
''';
  }
}