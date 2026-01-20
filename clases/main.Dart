import 'dart:math';
import 'MathParser.Dart';
import 'AdamsFourthOrderPredictorCorrectorClass.Dart';
import 'RungeKuttaFourthOrderClass.Dart';
import 'MethodUtils.Dart';
import 'HyperbolicEquationWaveClass.Dart';

void main() {
 var ecuacionOnda = HyperbolicEquationWaveClass(
    function1: "sin(pi*x)",           // Condición inicial de desplazamiento
    function2: "0",                   // Condición inicial de velocidad
    upperLimitx: 1.0,                 // Longitud del dominio
    maxTime: 1.0,                     // Tiempo final
    n: 20,                           // Divisiones temporales
    m: 20,                            // Divisiones espaciales
    alpha: 1.0,                       // Velocidad de la onda
    dn: 6
  );
  
  // Ejecutar el método
  ecuacionOnda.hyperbolicEquationWaveMethod();
  
  // Mostrar resultados
  print(ecuacionOnda.message);
  
  // Mostrar tabla de resultados (primeros 5 puntos)
  for (int i = 0; i < min(5, ecuacionOnda.resultTable.length); i++) {
    var fila = ecuacionOnda.resultTable[i];
    print("i: ${fila[0]}, x: ${fila[1]}, u(x,T): ${fila[2]}");
  }
  
  // Análisis de la ecuación
  var analisis = ecuacionOnda.analizarEcuacionOnda();
  print("\nAnálisis de la ecuación de onda:");
  analisis.forEach((key, value) {
    print("$key: $value");
  });
  
  // Verificar estabilidad CFL
  var estabilidad = ecuacionOnda.verificarEstabilidadCFL();
  print("\nAnálisis de estabilidad CFL:");
  estabilidad.forEach((key, value) {
    print("$key: $value");
  });
  
  // Calcular energía
  double energia = ecuacionOnda.calcularEnergia();
  print("\nEnergía aproximada de la onda: $energia");
  
  // Calcular evolución temporal
  var evolucion = ecuacionOnda.calcularEvolucionTemporal(numTiempos: 3);
  print("\nEvolución temporal (primeros 3 tiempos):");
  for (var tiempo in evolucion.take(3)) {
    print("t = ${tiempo['tiempo']}: ${tiempo['solucion'].take(3).toList()}...");
  }
}