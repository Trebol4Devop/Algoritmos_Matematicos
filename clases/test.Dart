import 'FalsePositionClass.Dart';
import 'FixedPointClass.Dart';
import 'dart:math';

void main() {
  print('=== PRUEBA DEL MÉTODO DE PUNTO FIJO ===\n');

  // Prueba 1: Raíz cuadrada de 4 usando g(x) = (x + 4/x)/2
  print('--- PRUEBA 1: √4 usando g(x) = (x + 4/x)/2 (Raíz: x=2) ---');
  testFixedPoint(
    function: '(x + 4/x)/2',
    x0: 3.0,
    tol: 0.0001,
    n: 100,
    dn: 6,
    expectedRoot: 2.0,
    testName: 'Raíz cuadrada de 4'
  );

  // Prueba 2: Raíz cúbica de 8 usando g(x) = (2x + 8/x²)/3
  print('\n--- PRUEBA 2: ∛8 usando g(x) = (2x + 8/x^2)/3 (Raíz: x=2) ---');
  testFixedPoint(
    function: '(2*x + 8/x^2)/3',
    x0: 1.5,
    tol: 0.0001,
    n: 100,
    dn: 6,
    expectedRoot: 2.0,
    testName: 'Raíz cúbica de 8'
  );

  // Prueba 3: Ecuación x = cos(x)
  print('\n--- PRUEBA 3: x = cos(x) (Raíz en ~0.739085) ---');
  testFixedPoint(
    function: 'cos(x)',
    x0: 0.5,
    tol: 0.0001,
    n: 100,
    dn: 6,
    expectedRoot: 0.739085,
    testName: 'Ecuación trascendental x = cos(x)'
  );

  // Prueba 4: Raíz cuadrada de 2 usando g(x) = (x + 2/x)/2
  print('\n--- PRUEBA 4: √2 usando g(x) = (x + 2/x)/2 (Raíz: x≈1.414214) ---');
  testFixedPoint(
    function: '(x + 2/x)/2',
    x0: 1.0,
    tol: 0.0001,
    n: 100,
    dn: 6,
    expectedRoot: 1.414214,
    testName: 'Raíz cuadrada de 2'
  );

  // Prueba 5: Ecuación x = e^(-x)
  print('\n--- PRUEBA 5: x = e^(-x) (Raíz en ~0.567143) ---');
  testFixedPoint(
    function: 'exp(-x)',
    x0: 0.5,
    tol: 0.0001,
    n: 100,
    dn: 6,
    expectedRoot: 0.567143,
    testName: 'Ecuación exponencial x = e^(-x)'
  );

  // Prueba 6: Raíz cuadrada de 9 usando g(x) = 0.5*(x + 9/x)
  print('\n--- PRUEBA 6: √9 usando g(x) = 0.5*(x + 9/x) (Raíz: x=3) ---');
  testFixedPoint(
    function: '0.5*(x + 9/x)',
    x0: 2.0,
    tol: 0.0001,
    n: 100,
    dn: 6,
    expectedRoot: 3.0,
    testName: 'Raíz cuadrada de 9'
  );

  // Prueba 7: Caso sin convergencia (debe fallar o converger lentamente)
  print('\n--- PRUEBA 7: g(x) = x² - 2 (Posible divergencia) ---');
  testFixedPoint(
    function: 'x^2 - 2',
    x0: 1.5,
    tol: 0.0001,
    n: 50,
    dn: 6,
    testName: 'Posible divergencia'
  );

  // Prueba 8: Tolerancia muy estricta
  print('\n--- PRUEBA 8: √4 con tolerancia 1e-10 ---');
  testFixedPoint(
    function: '(x + 4/x)/2',
    x0: 3.0,
    tol: 0.0000000001,
    n: 200,
    dn: 10,
    expectedRoot: 2.0,
    testName: 'Tolerancia estricta'
  );

  print('\n\n=== PRUEBA DEL MÉTODO DE LA POSICIÓN FALSA ===\n');

  // Prueba 1: Función cuadrática con raíz conocida
  print('--- PRUEBA 1: f(x) = x² - 4 (Raíz: x=2) ---');
  testFalsePosition(
    function: 'x^2 - 4',
    a: 1.0,
    b: 3.0,
    tol: 0.0001,
    n: 100,
    dn: 6,
    expectedRoot: 2.0,
    testName: 'Función cuadrática'
  );

  // Prueba 2: Función cúbica
  print('\n--- PRUEBA 2: f(x) = x³ - 2x - 5 (Raíz en ~2.0946) ---');
  testFalsePosition(
    function: 'x^3 - 2*x - 5',
    a: 2.0,
    b: 3.0,
    tol: 0.0001,
    n: 100,
    dn: 6,
    testName: 'Función cúbica'
  );

  // Prueba 3: Función trigonométrica
  print('\n--- PRUEBA 3: f(x) = sin(x) (Raíz: x=π) ---');
  testFalsePosition(
    function: 'sin(x)',
    a: 3.0,
    b: 4.0,
    tol: 0.0001,
    n: 100,
    dn: 6,
    expectedRoot: 3.14159,
    testName: 'Función seno'
  );

  // Prueba 4: Función exponencial
  print('\n--- PRUEBA 4: f(x) = e^x - 10 (Raíz en ~2.3026) ---');
  testFalsePosition(
    function: 'exp(x) - 10',
    a: 2.0,
    b: 3.0,
    tol: 0.0001,
    n: 100,
    dn: 6,
    testName: 'Función exponencial'
  );

  // Prueba 5: Caso sin cambio de signo (debe fallar)
  print('\n--- PRUEBA 5: f(x) = x² + 1 (Sin raíces reales en [1,3]) ---');
  testFalsePosition(
    function: 'x^2 + 1',
    a: 1.0,
    b: 3.0,
    tol: 0.0001,
    n: 100,
    dn: 6,
    testName: 'Sin cambio de signo'
  );

  // Prueba 6: Tolerancia muy estricta
  print('\n--- PRUEBA 6: f(x) = x² - 4 con tolerancia 1e-10 ---');
  testFalsePosition(
    function: 'x^2 - 4',
    a: 1.0,
    b: 3.0,
    tol: 0.0000000001,
    n: 100,
    dn: 10,
    expectedRoot: 2.0,
    testName: 'Tolerancia estricta'
  );
}

void testFixedPoint({
  required String function,
  required double x0,
  required double tol,
  required int n,
  required int dn,
  double? expectedRoot,
  required String testName,
}) {
  try {
    print('Función g(x): $function');
    print('Punto inicial x0: $x0');
    print('Tolerancia: $tol');
    print('Máximo de iteraciones: $n');
    print('Decimales: $dn');

    // Crear instancia del método
    var fixedPoint = FixedPointClass(
      function: function,
      x0: x0,
      tol: tol,
      n: n,
      dn: dn,
    );

    // Ejecutar el método
    fixedPoint.fixedPointMethod();

    // Mostrar resultados
    print('\n✅ $testName');
    print('Éxito: ${fixedPoint.success}');
    print('Mensaje: ${fixedPoint.message}');
    
    if (fixedPoint.success) {
      print('Raíz aproximada: ${fixedPoint.result}');
      print('Iteraciones: ${fixedPoint.iterations}');
      
      if (expectedRoot != null) {
        double errorAbsoluto = (fixedPoint.result - expectedRoot).abs();
        print('Raíz esperada: $expectedRoot');
        print('Error absoluto: $errorAbsoluto');
      }
    }

    // Mostrar tabla de iteraciones (solo las primeras 5 y las últimas 3)
    if (fixedPoint.resultTable.isNotEmpty) {
      print('\n📊 Tabla de iteraciones:');
      print('i\t| x_n\t\t| g(x_n)\t\t| error\t\t');
      print('-' * 60);
      
      int totalIterations = fixedPoint.resultTable.length;
      
      // Mostrar primeras iteraciones
      for (int i = 0; i < min(3, totalIterations); i++) {
        printFixedPointIteration(fixedPoint.resultTable[i]);
      }
      
      if (totalIterations > 6) {
        print('...\t| ...\t\t| ...\t\t| ...');
        // Mostrar últimas iteraciones
        for (int i = max(3, totalIterations - 3); i < totalIterations; i++) {
          printFixedPointIteration(fixedPoint.resultTable[i]);
        }
      } else {
        // Mostrar todas si son pocas
        for (int i = 3; i < totalIterations; i++) {
          printFixedPointIteration(fixedPoint.resultTable[i]);
        }
      }
    }

    // Análisis de convergencia
    var analisis = fixedPoint.analizarConvergencia();
    print('\n📈 Análisis de convergencia:');
    analisis.forEach((key, value) {
      print('$key: $value');
    });

  } catch (e) {
    print('\n❌ Error en $testName: $e');
  }
  print('\n' + '='*80 + '\n');
}

void testFalsePosition({
  required String function,
  required double a,
  required double b,
  required double tol,
  required int n,
  required int dn,
  double? expectedRoot,
  required String testName,
}) {
  try {
    print('Función: $function');
    print('Intervalo: [$a, $b]');
    print('Tolerancia: $tol');
    print('Máximo de iteraciones: $n');
    print('Decimales: $dn');

    // Crear instancia del método
    var falsePosition = FalsePositionClass(
      function: function,
      a: a,
      b: b,
      tol: tol,
      n: n,
      dn: dn,
    );

    // Ejecutar el método
    falsePosition.falsePositionMethod();

    // Mostrar resultados
    print('\n✅ $testName');
    print('Éxito: ${falsePosition.success}');
    print('Mensaje: ${falsePosition.message}');
    
    if (falsePosition.success) {
      print('Raíz aproximada: ${falsePosition.result}');
      print('Iteraciones: ${falsePosition.iterations}');
      
      if (expectedRoot != null) {
        double errorAbsoluto = (falsePosition.result - expectedRoot).abs();
        print('Raíz esperada: $expectedRoot');
        print('Error absoluto: $errorAbsoluto');
      }
    }

    // Mostrar tabla de iteraciones (solo las primeras 5 y las últimas 3)
    if (falsePosition.resultTable.isNotEmpty) {
      print('\n📊 Tabla de iteraciones:');
      print('i\t| a\t\t| b\t\t| f(a)\t\t| f(b)\t\t| c\t\t| f(c)\t\t| error');
      print('-' * 120);
      
      int totalIterations = falsePosition.resultTable.length;
      
      // Mostrar primeras iteraciones
      for (int i = 0; i < min(3, totalIterations); i++) {
        printIteration(falsePosition.resultTable[i]);
      }
      
      if (totalIterations > 6) {
        print('...\t| ...\t\t| ...\t\t| ...\t\t| ...\t\t| ...\t\t| ...\t\t| ...');
        // Mostrar últimas iteraciones
        for (int i = max(3, totalIterations - 3); i < totalIterations; i++) {
          printIteration(falsePosition.resultTable[i]);
        }
      } else {
        // Mostrar todas si son pocas
        for (int i = 3; i < totalIterations; i++) {
          printIteration(falsePosition.resultTable[i]);
        }
      }
    }

    // Análisis de convergencia
    var analisis = falsePosition.analizarConvergencia();
    print('\n📈 Análisis de convergencia:');
    analisis.forEach((key, value) {
      print('$key: $value');
    });

  } catch (e) {
    print('\n❌ Error en $testName: $e');
  }
  print('\n' + '='*80 + '\n');
}

void printFixedPointIteration(Map<String, dynamic> iteracion) {
  String i = iteracion['i'].toString();
  String xn = _formatNumber(iteracion['xn']);
  String gxn = _formatNumber(iteracion['gxn']);
  String error = _formatNumber(iteracion['error']);
  
  print('$i\t| $xn\t| $gxn\t| $error');
}

void printIteration(Map<String, dynamic> iteracion) {
  String i = iteracion['i'].toString();
  String a = _formatNumber(iteracion['a']);
  String b = _formatNumber(iteracion['b']);
  String fa = _formatNumber(iteracion['f(a)']);
  String fb = _formatNumber(iteracion['f(b)']);
  String c = _formatNumber(iteracion['c']);
  String fc = _formatNumber(iteracion['f(c)']);
  String error = _formatNumber(iteracion['error']);
  
  print('$i\t| $a\t| $b\t| $fa\t| $fb\t| $c\t| $fc\t| $error');
}

String _formatNumber(dynamic value) {
  if (value == '-') return '-';
  if (value is double) {
    if (value.abs() < 0.001 && value != 0) {
      return value.toStringAsExponential(4);
    }
    return value.toStringAsFixed(6);
  }
  return value.toString();
}
