import 'NevilleMethodClass.Dart';
import 'dart:math';

void main() {
  print('=== PRUEBA DEL MÉTODO DE NEVILLE ===\n');

  // Prueba 1: Función cuadrática con puntos conocidos
  print('--- PRUEBA 1: f(x) = x² (Puntos: (1,1), (2,4), (3,9)) ---');
  testNevilleMethod(
    dataTable: [
      [0.0, 1.0, 1.0],
      [1.0, 2.0, 4.0],
      [2.0, 3.0, 9.0],
    ],
    c: 2.5,
    dn: 6,
    expectedResult: 6.25,
    testName: 'Función cuadrática'
  );

  // Prueba 2: Función seno con puntos equidistantes
  print('\n--- PRUEBA 2: f(x) = sin(x) (Puntos en [0, π/2]) ---');
  testNevilleMethod(
    dataTable: [
      [0.0, 0.0, 0.0],
      [1.0, pi/6, sin(pi/6)],
      [2.0, pi/4, sin(pi/4)],
      [3.0, pi/3, sin(pi/3)],
      [4.0, pi/2, sin(pi/2)],
    ],
    c: pi/5,
    dn: 6,
    expectedResult: sin(pi/5),
    testName: 'Función seno'
  );

  // Prueba 3: Función exponencial
  print('\n--- PRUEBA 3: f(x) = e^x (Puntos en [0, 2]) ---');
  testNevilleMethod(
    dataTable: [
      [0.0, 0.0, exp(0)],
      [1.0, 0.5, exp(0.5)],
      [2.0, 1.0, exp(1)],
      [3.0, 1.5, exp(1.5)],
      [4.0, 2.0, exp(2)],
    ],
    c: 1.2,
    dn: 6,
    expectedResult: exp(1.2),
    testName: 'Función exponencial'
  );

  // Prueba 4: Polinomio cúbico
  print('\n--- PRUEBA 4: f(x) = x³ - 2x + 1 ---');
  testNevilleMethod(
    dataTable: [
      [0.0, -2.0, pow(-2, 3) - 2*(-2) + 1],
      [1.0, -1.0, pow(-1, 3) - 2*(-1) + 1],
      [2.0, 0.0, pow(0, 3) - 2*0 + 1],
      [3.0, 1.0, pow(1, 3) - 2*1 + 1],
      [4.0, 2.0, pow(2, 3) - 2*2 + 1],
    ],
    c: 0.5,
    dn: 6,
    expectedResult: pow(0.5, 3) - 2*0.5 + 1,
    testName: 'Polinomio cúbico'
  );

  // Prueba 5: Caso con pocos puntos
  print('\n--- PRUEBA 5: Solo 2 puntos (interpolación lineal) ---');
  testNevilleMethod(
    dataTable: [
      [0.0, 1.0, 2.0],
      [1.0, 3.0, 6.0],
    ],
    c: 2.0,
    dn: 6,
    expectedResult: 4.0,
    testName: 'Interpolación lineal'
  );

  // Prueba 6: Caso con muchos puntos
  print('\n--- PRUEBA 6: 6 puntos para f(x) = 1/(1+x²) ---');
  List<List<double>> dataTable6 = [];
  for (int i = 0; i < 6; i++) {
    double x = -2.5 + i;
    dataTable6.add([i.toDouble(), x, 1/(1 + x*x)]);
  }
  testNevilleMethod(
    dataTable: dataTable6,
    c: 0.3,
    dn: 8,
    expectedResult: 1/(1 + 0.3*0.3),
    testName: 'Función racional'
  );

  // Prueba 7: Caso de error - tabla vacía
  print('\n--- PRUEBA 7: Tabla de datos vacía (debe fallar) ---');
  testNevilleMethod(
    dataTable: [],
    c: 1.0,
    dn: 6,
    testName: 'Tabla vacía'
  );

  // Prueba 8: Caso de error - más de 25 puntos
  print('\n--- PRUEBA 8: Demasiados puntos (más de 25) ---');
  List<List<double>> dataTable26 = [];
  for (int i = 0; i < 26; i++) {
    dataTable26.add([i.toDouble(), i.toDouble(), i.toDouble()]);
  }
  testNevilleMethod(
    dataTable: dataTable26,
    c: 12.5,
    dn: 6,
    testName: 'Demasiados puntos'
  );
}

void testNevilleMethod({
  required List<List<double>> dataTable,
  required double c,
  required int dn,
  double? expectedResult,
  required String testName,
}) {
  try {
    print('Tabla de datos:');
    for (int i = 0; i < dataTable.length; i++) {
      print('  Punto ${dataTable[i][0]}: (${dataTable[i][1]}, ${dataTable[i][2]})');
    }
    print('Punto de interpolación (c): $c');
    print('Decimales: $dn');

    // Crear instancia del método
    var neville = NevilleMethodClass(
      n: dataTable.length,
      c: c,
      dn: dn,
      dataTable: dataTable,
    );

    // Ejecutar el método
    neville.nevilleMethod();

    // Mostrar resultados
    print('\n✅ $testName');
    print('Éxito: ${neville.success}');
    print('Mensaje: ${neville.message}');
    
    if (neville.success) {
      print('Resultado interpolado: ${neville.result}');
      print('Iteraciones: ${neville.iterations}');
      
      if (expectedResult != null) {
        double errorAbsoluto = (neville.result - expectedResult).abs();
        print('Resultado esperado: $expectedResult');
        print('Error absoluto: $errorAbsoluto');
        print('Error relativo: ${(errorAbsoluto / expectedResult.abs() * 100).toStringAsFixed(6)}%');
      }

      // Mostrar tabla de Neville (solo si es pequeña)
      if (neville.nevilleTable.isNotEmpty && dataTable.length <= 5) {
        print('\n📊 Tabla de Neville:');
        var tablaResultados = neville.obtenerTablaResultados();
        for (var fila in tablaResultados) {
          print(fila.join('\t| '));
        }
      } else if (neville.nevilleTable.isNotEmpty) {
        print('\n📊 Tabla de Neville disponible (${dataTable.length} puntos)');
      }

      // Mostrar polinomio interpolante
      print('\n📐 Polinomio interpolante:');
      print(neville.obtenerPolinomioInterpolante());

      // Análisis de la interpolación
      var analisis = neville.analizarInterpolacion();
      print('\n📈 Análisis de interpolación:');
      analisis.forEach((key, value) {
        print('$key: $value');
      });

      // Evaluar en puntos adicionales
      if (dataTable.length >= 3) {
        print('\n🔍 Evaluación en puntos adicionales:');
        double xTest1 = (dataTable[0][1] + dataTable[1][1]) / 2;
        double xTest2 = (dataTable[dataTable.length-2][1] + dataTable[dataTable.length-1][1]) / 2;
        
        double yTest1 = neville.evaluarEnPunto(xTest1);
        double yTest2 = neville.evaluarEnPunto(xTest2);
        
        print('P($xTest1) ≈ $yTest1');
        print('P($xTest2) ≈ $yTest2');
      }
    }

  } catch (e) {
    print('\n❌ Error en $testName: $e');
  }
  print('\n' + '='*80 + '\n');
}

// Función auxiliar para mostrar puntos del polinomio
void mostrarPuntosPolinomio(NevilleMethodClass neville) {
  var puntos = neville.obtenerPuntosPolinomio(numPuntos: 10);
  var puntosOriginales = neville.obtenerPuntosOriginales();
  
  print('\n📈 Puntos del polinomio interpolante:');
  print('x\t\t| y interpolado');
  print('-' * 40);
  
  for (var punto in puntos) {
    print('${punto['x']!.toStringAsFixed(4)}\t| ${punto['y']!.toStringAsFixed(6)}');
  }
  
  print('\n📌 Puntos originales:');
  print('x\t\t| y original');
  print('-' * 40);
  
  for (var punto in puntosOriginales) {
    print('${punto['x']!.toStringAsFixed(4)}\t| ${punto['y']!.toStringAsFixed(6)}');
  }
}
