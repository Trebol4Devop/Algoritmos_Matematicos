import 'dart:math';
import 'MethodClass.Dart';
import 'MethodUtils.Dart';
import 'MathParser.Dart';
import 'RungeKuttaFourthOrderClass.Dart';


// Clase que implementa el método Adams-Bashforth-Moulton
class AdamsFourthOrderPredictorCorrectorClass extends MethodClass {
  String function;
  double lowerLimit;
  double upperLimit;
  int n;
  double alpha;
  int dn;
  List<List<double>> resultTable;
  MathParser parser;

  AdamsFourthOrderPredictorCorrectorClass({
    this.function = "",
    this.lowerLimit = 0.0,
    this.upperLimit = 0.0,
    this.n = 0,
    this.alpha = 0.0,
    this.dn = 0,
    List<List<double>>? resultTable,
    int id = 15,
    String title = "Adams 4 Orden Predictor-Corrector",
    String subtitle = "Método multipasos para EDOs",
    String index = "ADAMS4",
  }) : parser = MathParser(), resultTable = resultTable ?? [] {
    this.id = id;
    this.title = title;
    this.subtitle = subtitle;
    this.index = index;
  }

  @override
  void initialize() {
    super.initialize();
    resultTable = [];
  }

  String? validarParametros() {
    if (function.isEmpty) {
      return "Error: debe proporcionar la función f(t, y)";
    }
    
    if (lowerLimit >= upperLimit) {
      return "Error: el límite inferior debe ser menor que el límite superior";
    }
    
    if (n <= 0) {
      return "Error: el número de subintervalos debe ser mayor que 0";
    }
    
    if (n < 4) {
      return "Error: el método Adams de 4º orden requiere al menos 4 subintervalos (n >= 4)";
    }
    
    if (dn < 0) {
      return "Error: el número de decimales debe ser no negativo";
    }
    
    try {
      if (!parser.validarFuncionEuler(function)) {
        return "Error: la función f(t, y) no es válida";
      }
    } catch (e) {
      return "Error al validar la función: ${e.toString()}";
    }
    
    try {
      double test = parser.evaluarFuncionTY(function, lowerLimit, alpha);
      if (test.isNaN || test.isInfinite) {
        return "Error: la función produce valores no válidos en el punto inicial";
      }
    } catch (e) {
      return "Error: no se puede evaluar la función en el punto inicial: ${e.toString()}";
    }
    
    return null;
  }

  void adamsFourthOrderPredictorCorrectorMethod() {
    initialize();
    
    try {
      String? error = validarParametros();
      if (error != null) {
        message = error;
        return;
      }
      
      double a = lowerLimit;
      double b = upperLimit;
      double h = (b - a) / n;
      
      List<double> tValues = List.filled(4, 0.0);
      List<double> yValues = List.filled(4, 0.0);
      
      resultTable = [];
      
      tValues[0] = a;
      yValues[0] = alpha;
      
      List<double> filaInicial = [
        0.0,
        MethodUtils.redondear(tValues[0], dn),
        MethodUtils.redondear(yValues[0], dn),
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0
      ];
      resultTable.add(filaInicial);
      
      for (int i = 1; i <= 3; i++) {
        double t = tValues[i - 1];
        double y = yValues[i - 1];
        
        double k1 = h * parser.evaluarFuncionTY(function, t, y);
        double k2 = h * parser.evaluarFuncionTY(function, t + h/2, y + k1/2);
        double k3 = h * parser.evaluarFuncionTY(function, t + h/2, y + k2/2);
        double k4 = h * parser.evaluarFuncionTY(function, t + h, y + k3);
        
        yValues[i] = y + (k1 + 2*k2 + 2*k3 + k4)/6;
        tValues[i] = a + i * h;
        
        List<double> filaRK = [
          i.toDouble(),
          MethodUtils.redondear(tValues[i], dn),
          MethodUtils.redondear(yValues[i], dn),
          MethodUtils.redondear(k1, dn),
          MethodUtils.redondear(k2, dn),
          MethodUtils.redondear(k3, dn),
          MethodUtils.redondear(k4, dn),
          0.0,
          0.0
        ];
        resultTable.add(filaRK);
      }
      
      for (int i = 4; i <= n; i++) {
        double t = a + i * h;
        
        double predictor = yValues[3] + h * (
          55.0 * parser.evaluarFuncionTY(function, tValues[3], yValues[3]) -
          59.0 * parser.evaluarFuncionTY(function, tValues[2], yValues[2]) +
          37.0 * parser.evaluarFuncionTY(function, tValues[1], yValues[1]) -
          9.0 * parser.evaluarFuncionTY(function, tValues[0], yValues[0])
        ) / 24.0;
        
        double corrector = yValues[3] + h * (
          9.0 * parser.evaluarFuncionTY(function, t, predictor) +
          19.0 * parser.evaluarFuncionTY(function, tValues[3], yValues[3]) -
          5.0 * parser.evaluarFuncionTY(function, tValues[2], yValues[2]) +
          parser.evaluarFuncionTY(function, tValues[1], yValues[1])
        ) / 24.0;
        
        List<double> filaAdams = [
          i.toDouble(),
          MethodUtils.redondear(t, dn),
          MethodUtils.redondear(corrector, dn),
          0.0,
          0.0,
          0.0,
          0.0,
          MethodUtils.redondear(predictor, dn),
          MethodUtils.redondear(corrector, dn)
        ];
        resultTable.add(filaAdams);
        
        for (int j = 0; j < 3; j++) {
          tValues[j] = tValues[j + 1];
          yValues[j] = yValues[j + 1];
        }
        tValues[3] = t;
        yValues[3] = corrector;
      }
      
      success = true;
      iterations = n;
      result = yValues[3];
      message = "y(${MethodUtils.redondear(b, dn)}) = ${MethodUtils.redondear(result, dn)}\n"
                "Tamaño de paso h = ${MethodUtils.redondear(h, dn)}\n"
      
    } catch (e) {
      message = "Error durante la ejecución del método Adams: ${e.toString()}";
      success = false;
    }
  }

  List<List<String>> obtenerTablaResultados() {
    List<List<String>> tabla = [];
    
    if (resultTable.isEmpty) return tabla;
    
    List<String> encabezados = ["i", "ti", "y(ti)", "k1", "k2", "k3", "k4", "Predictor", "Corrector"];
    tabla.add(encabezados);
    
    for (int i = 0; i < resultTable.length; i++) {
      List<String> fila = [];
      for (int j = 0; j < resultTable[i].length; j++) {
        fila.add(MethodUtils.redondear(resultTable[i][j], dn).toString());
      }
      tabla.add(fila);
    }
    
    return tabla;
  }

  List<List<String>> obtenerTablaResultadosSimplificada() {
    List<List<String>> tabla = [];
    
    if (resultTable.isEmpty) return tabla;
    

    List<String> encabezados = ["i", "ti", "y(ti)"];
    tabla.add(encabezados);
    
    for (int i = 0; i < resultTable.length; i++) {
      List<String> fila = [
        MethodUtils.redondear(resultTable[i][0], dn).toString(),
        MethodUtils.redondear(resultTable[i][1], dn).toString(),
        MethodUtils.redondear(resultTable[i][2], dn).toString()
      ];
      tabla.add(fila);
    }
    
    return tabla;
  }

  String obtenerSolucion() {
    if (resultTable.isEmpty) return "No hay solución calculada";
    
    List<double> ultimaFila = resultTable.last;
    double tFinal = ultimaFila[1];
    double yFinal = ultimaFila[2];
    
    return "y(${MethodUtils.redondear(tFinal, dn)}) = ${MethodUtils.redondear(yFinal, dn)}";
  }

  double calcularError(String solucionExacta) {
    if (resultTable.isEmpty) return double.nan;
    
    try {
      List<double> ultimaFila = resultTable.last;
      double tFinal = ultimaFila[1];
      double yAproximado = ultimaFila[2];
      
      double yExacto = parser.evaluar(solucionExacta, "t", tFinal);
      
      return (yAproximado - yExacto).abs();
    } catch (e) {
      return double.nan;
    }
  }

  double calcularErrorRelativo(String solucionExacta) {
    if (resultTable.isEmpty) return double.nan;
    
    try {
      List<double> ultimaFila = resultTable.last;
      double tFinal = ultimaFila[1];
      double yAproximado = ultimaFila[2];
      
      double yExacto = parser.evaluar(solucionExacta, "t", tFinal);
      
      if (yExacto == 0) return double.infinity;
      return ((yAproximado - yExacto).abs() / yExacto.abs()) * 100;
    } catch (e) {
      return double.nan;
    }
  }

  List<Map<String, double>> obtenerPuntosSolucion() {
    List<Map<String, double>> puntos = [];
    
    for (int i = 0; i < resultTable.length; i++) {
      puntos.add({
        'x': resultTable[i][1],
        'y': resultTable[i][2],
        'iteracion': resultTable[i][0],
        'tipo': i <= 3 ? 1.0 : 2.0
      });
    }
    
    return puntos;
  }

  Map<String, dynamic> analizarMetodo() {
    Map<String, dynamic> analisis = {};
    
    try {
      double h = (upperLimit - lowerLimit) / n;
      
      analisis['tamaño_paso'] = MethodUtils.redondear(h, dn);
      analisis['numero_pasos'] = n;
      analisis['punto_inicial'] = '(${MethodUtils.redondear(lowerLimit, dn)}, ${MethodUtils.redondear(alpha, dn)})';
      analisis['punto_final'] = resultTable.isNotEmpty ? 
          '(${MethodUtils.redondear(resultTable.last[1], dn)}, ${MethodUtils.redondear(resultTable.last[2], dn)})' : 
          'No calculado';

      analisis['tipo_metodo'] = 'Multipasos (4 pasos)';
      analisis['predictor'] = 'Adams-Bashforth 4 orden';
      analisis['corrector'] = 'Adams-Moulton 3 orden';
      analisis['inicializacion'] = 'Runge-Kutta 4 orden (primeros 4 puntos)';
      analisis['error_local'] = 'O(h5)';
      analisis['error_global'] = 'O(h4)';

      int pasosRK4 = min(4, resultTable.length);
      int pasosAdams = max(0, resultTable.length - 4);
      analisis['pasos_rk4'] = pasosRK4;
      analisis['pasos_adams'] = pasosAdams;

      if (h > 0.1) {
        analisis['advertencia'] = 'El tamaño de paso podría afectar la estabilidad';
        analisis['recomendacion'] = 'Considere reducir el tamaño de paso h';
      } else {
        analisis['advertencia'] = 'Ninguna';
        analisis['recomendacion'] = 'El tamaño de paso parece adecuado';
      }

      analisis['funcion'] = function;
      analisis['tipo_ecuacion'] = 'Primer orden: y\' = f(t, y)';
      
    } catch (e) {
      analisis['error'] = 'Error en análisis del método: ${e.toString()}';
    }
    
    return analisis;
  }

  Map<String, dynamic> obtenerInfoPredictorCorrector() {
    Map<String, dynamic> info = {};
    
    try {
      if (resultTable.length < 5) {
        info['error'] = 'No hay suficientes iteraciones para analizar';
        return info;
      }

      List<double> ultimaFila = resultTable.last;
      
      info['iteracion'] = ultimaFila[0].toInt();
      info['t'] = MethodUtils.redondear(ultimaFila[1], dn);
      info['predictor'] = MethodUtils.redondear(ultimaFila[7], dn);
      info['corrector'] = MethodUtils.redondear(ultimaFila[8], dn);
      info['diferencia_pc'] = MethodUtils.redondear((ultimaFila[8] - ultimaFila[7]).abs(), dn);

      if (ultimaFila[7] != 0) {
        double correccionRelativa = ((ultimaFila[8] - ultimaFila[7]).abs() / ultimaFila[7].abs()) * 100;
        info['correccion_relativa'] = '${MethodUtils.redondear(correccionRelativa, 4)}%';
      }

      double diferencia = (ultimaFila[8] - ultimaFila[7]).abs();
      if (diferencia < 1e-8) {
        info['calidad_correccion'] = 'Excelente';
      } else if (diferencia < 1e-6) {
        info['calidad_correccion'] = 'Muy buena';
      } else if (diferencia < 1e-4) {
        info['calidad_correccion'] = 'Buena';
      } else {
        info['calidad_correccion'] = 'Aceptable';
      }
      
    } catch (e) {
      info['error'] = 'Error al obtener información predictor-corrector: ${e.toString()}';
    }
    
    return info;
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json.addAll({
      'function': function,
      'lowerLimit': lowerLimit,
      'upperLimit': upperLimit,
      'n': n,
      'alpha': alpha,
      'dn': dn,
      'resultTable': resultTable,
    });
    return json;
  }

  @override
  String getResultSummary() {
    String summary = '${super.getResultSummary()}\n'
                    'Función: y\' = $function\n'
                    'Intervalo: [${MethodUtils.redondear(lowerLimit, dn)}, ${MethodUtils.redondear(upperLimit, dn)}]\n'
                    'Subintervalos: $n\n'
                    'Condición inicial: y(${MethodUtils.redondear(lowerLimit, dn)}) = ${MethodUtils.redondear(alpha, dn)}';
    
    if (success && resultTable.isNotEmpty) {
      List<double> ultimaFila = resultTable.last;
      summary += '\nSolución aproximada: y(${MethodUtils.redondear(ultimaFila[1], dn)}) = ${MethodUtils.redondear(ultimaFila[2], dn)}';

      if (ultimaFila.length > 8 && ultimaFila[0] >= 4) {
        summary += '\nÚltima iteración Adams - Predictor: ${MethodUtils.redondear(ultimaFila[7], dn)}, ' +
                  'Corrector: ${MethodUtils.redondear(ultimaFila[8], dn)}';
      }
    }
    
    return summary;
  }

  String getMethodDescription() {
    return '''
Propósito: Resolver ecuaciones diferenciales ordinarias mediante un esquema predictor-corrector multipaso.

Estructura: Combina dos métodos:

  Adams-Bashforth (Cuarto orden): Predictor explícito

  Adams-Moulton (Cuarto orden): Corrector implícito

Características:

    Método multipaso: Requiere 4 puntos anteriores para iniciar

    Alta precisión: Error de truncamiento O(h^5)

    Estabilidad: Mejor que métodos explícitos puros

    Proceso iterativo: Se puede repetir la corrección (f(t_{n+1}, y_{n+1}^C))

Implementación: Se necesita un método de arranque (como Runge-Kutta) para obtener los primeros 4 puntos.

Ventaja: Mayor eficiencia que Runge-Kutta para problemas donde evaluar f(x,y) es costoso, al requerir solo 2 evaluaciones por paso (vs 4 de RK4).
''';
  }
}