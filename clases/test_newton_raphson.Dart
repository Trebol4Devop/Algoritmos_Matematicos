import 'dart:math';
import 'NewtonRaphsonClass.Dart';

void main() {
  print("=== PRUEBA DEL MÉTODO DE NEWTON-RAPHSON ===\n");
  
  // Ejecutar todos los casos de prueba
  testCaso1();
  testCaso2();
  testCaso3();
  testCaso4();
  testCasosError();
  testAnalisisConvergencia();
  testFuncionesGraficacion();
  
  print("\n=== TODAS LAS PRUEBAS COMPLETADAS ===");
}

/// Caso 1: Raíz de x² - 4 = 0 (solución: x = 2)
void testCaso1() {
  print("\n" + "="*70);
  print("CASO 1: Raíz de x² - 4 = 0 (solución esperada: x = 2)");
  print("="*70);
  
  var newton = NewtonRaphsonClass(
    function: "x^2 - 4",
    functionDer: "2*x",
    x0: 3.0,
    tol: 0.0001,
    n: 100,
    dn: 6,
    title: "Newton-Raphson - x² - 4",
    subtitle: "Encontrar raíz cuadrada de 4",
    index: "1",
  );
  
  print("Parámetros de entrada:");
  print("• Función f(x): ${newton.function}");
  print("• Derivada f'(x): ${newton.functionDer}");
  print("• Punto inicial x₀: ${newton.x0}");
  print("• Tolerancia: ${newton.tol}");
  print("• Iteraciones máximas: ${newton.n}");
  print("• Decimales: ${newton.dn}");
  
  // Validar funciones
  print("\nValidando funciones...");
  bool funcionesValidas = newton.validarFunciones();
  print("Funciones váladas: ${funcionesValidas ? '✅' : '❌'}");
  
  if (!funcionesValidas) {
    print("❌ Error en validación de funciones");
    return;
  }
  
  // Ejecutar método
  print("\nEjecutando método de Newton-Raphson...");
  newton.newtonRaphsonMethod();
  
  if (newton.success) {
    print("✅ Método convergió exitosamente");
    print("• Raíz encontrada: ${newton.result}");
    print("• Iteraciones: ${newton.iterations}");
    print("• Error final: ${newton.resultTable.isNotEmpty ? newton.resultTable.last['error'] : 'N/A'}");
    print("• Mensaje: ${newton.message}");
    
    // Verificación
    double verificacion = (newton.result * newton.result - 4).abs();
    print("• Verificación |x² - 4|: $verificacion");
    
    if (verificacion < newton.tol) {
      print("✅ Solución verificada correctamente");
    } else {
      print("⚠️  Solución con error significativo");
    }
  } else {
    print("❌ El método no convergió: ${newton.message}");
  }
  
  // Mostrar tabla de iteraciones
  print("\n--- Tabla de Iteraciones ---");
  printTablaResultados(newton.resultTable);
}

/// Caso 2: Raíz de cos(x) - x = 0 (solución: x ≈ 0.739085)
void testCaso2() {
  print("\n" + "="*70);
  print("CASO 2: Raíz de cos(x) - x = 0 (solución esperada: x ≈ 0.739085)");
  print("="*70);
  
  var newton = NewtonRaphsonClass(
    function: "cos(x) - x",
    functionDer: "-sin(x) - 1",
    x0: 1.0,
    tol: 0.000001,
    n: 50,
    dn: 8,
    title: "Newton-Raphson - cos(x) - x",
    subtitle: "Punto fijo trascendental",
    index: "2",
  );
  
  print("Parámetros de entrada:");
  print("• Función f(x): ${newton.function}");
  print("• Derivada f'(x): ${newton.functionDer}");
  print("• Punto inicial x₀: ${newton.x0}");
  print("• Tolerancia: ${newton.tol}");
  
  // Ejecutar método
  print("\nEjecutando método...");
  newton.newtonRaphsonMethod();
  
  if (newton.success) {
    print("✅ Método convergió exitosamente");
    print("• Raíz encontrada: ${newton.result}");
    print("• Iteraciones: ${newton.iterations}");
    
    // Verificación
    double verificacion = (cos(newton.result) - newton.result).abs();
    print("• Verificación |cos(x) - x|: $verificacion");
    
    if (verificacion < newton.tol) {
      print("✅ Solución verificada correctamente");
    }
  } else {
    print("❌ El método no convergió: ${newton.message}");
  }
  
  // Mostrar últimas iteraciones
  print("\n--- Últimas 5 Iteraciones ---");
  printUltimasIteraciones(newton.resultTable, 5);
}

/// Caso 3: Raíz cúbica de 8: x³ - 8 = 0 (solución: x = 2)
void testCaso3() {
  print("\n" + "="*70);
  print("CASO 3: Raíz cúbica de 8: x³ - 8 = 0 (solución esperada: x = 2)");
  print("="*70);
  
  var newton = NewtonRaphsonClass(
    function: "x^3 - 8",
    functionDer: "3*x^2",
    x0: 1.5,
    tol: 0.00001,
    n: 30,
    dn: 6,
    title: "Newton-Raphson - x³ - 8",
    subtitle: "Raíz cúbica de 8",
    index: "3",
  );
  
  print("Parámetros de entrada:");
  print("• Función f(x): ${newton.function}");
  print("• Derivada f'(x): ${newton.functionDer}");
  print("• Punto inicial x₀: ${newton.x0}");
  
  // Ejecutar método
  print("\nEjecutando método...");
  newton.newtonRaphsonMethod();
  
  if (newton.success) {
    print("✅ Método convergió exitosamente");
    print("• Raíz encontrada: ${newton.result}");
    print("• Iteraciones: ${newton.iterations}");
    
    // Verificación
    double verificacion = (pow(newton.result, 3).toDouble() - 8).abs();
    print("• Verificación |x³ - 8|: $verificacion");
    
    if (verificacion < newton.tol) {
      print("✅ Solución verificada correctamente");
    }
  } else {
    print("❌ El método no convergió: ${newton.message}");
  }
}

/// Caso 4: Función con convergencia lenta: x^(1/3) = 0
void testCaso4() {
  print("\n" + "="*70);
  print("CASO 4: Función con convergencia problemática: x^(1/3) = 0");
  print("="*70);
  
  var newton = NewtonRaphsonClass(
    function: "x^(1/3)",
    functionDer: "(1/3)*x^(-2/3)",
    x0: 0.1,
    tol: 0.0001,
    n: 20,
    dn: 6,
    title: "Newton-Raphson - x^(1/3)",
    subtitle: "Caso con convergencia problemática",
    index: "4",
  );
  
  print("Parámetros de entrada:");
  print("• Función f(x): ${newton.function}");
  print("• Derivada f'(x): ${newton.functionDer}");
  print("• Punto inicial x₀: ${newton.x0}");
  
  // Ejecutar método
  print("\nEjecutando método...");
  newton.newtonRaphsonMethod();
  
  if (newton.success) {
    print("✅ Método convergió exitosamente");
    print("• Raíz encontrada: ${newton.result}");
    print("• Iteraciones: ${newton.iterations}");
  } else {
    print("⚠️  El método tuvo dificultades: ${newton.message}");
  }
}

/// Pruebas de casos de error
void testCasosError() {
  print("\n" + "="*70);
  print("PRUEBAS DE CASOS DE ERROR");
  print("="*70);
  
  // Caso 1: Función vacía
  print("\n--- Caso 1: Función vacía ---");
  var newton1 = NewtonRaphsonClass(
    function: "",
    functionDer: "2*x",
    x0: 1.0,
    tol: 0.0001,
    n: 10,
  );
  newton1.newtonRaphsonMethod();
  print("Resultado: ${newton1.message}");
  
  // Caso 2: Derivada vacía
  print("\n--- Caso 2: Derivada vacía ---");
  var newton2 = NewtonRaphsonClass(
    function: "x^2 - 4",
    functionDer: "",
    x0: 1.0,
    tol: 0.0001,
    n: 10,
  );
  newton2.newtonRaphsonMethod();
  print("Resultado: ${newton2.message}");
  
  // Caso 3: Tolerancia no válida
  print("\n--- Caso 3: Tolerancia no válida ---");
  var newton3 = NewtonRaphsonClass(
    function: "x^2 - 4",
    functionDer: "2*x",
    x0: 1.0,
    tol: -0.0001,
    n: 10,
  );
  newton3.newtonRaphsonMethod();
  print("Resultado: ${newton3.message}");
  
  // Caso 4: Iteraciones no válidas
  print("\n--- Caso 4: Iteraciones no válidas ---");
  var newton4 = NewtonRaphsonClass(
    function: "x^2 - 4",
    functionDer: "2*x",
    x0: 1.0,
    tol: 0.0001,
    n: 0,
  );
  newton4.newtonRaphsonMethod();
  print("Resultado: ${newton4.message}");
  
  // Caso 5: Derivada cero en punto inicial
  print("\n--- Caso 5: Derivada cero en punto inicial ---");
  var newton5 = NewtonRaphsonClass(
    function: "x^2",
    functionDer: "2*x",
    x0: 0.0,
    tol: 0.0001,
    n: 10,
  );
  newton5.newtonRaphsonMethod();
  print("Resultado: ${newton5.message}");
  
  // Caso 6: Función no evaluable en punto inicial
  print("\n--- Caso 6: Función no evaluable en punto inicial ---");
  var newton6 = NewtonRaphsonClass(
    function: "ln(x-1)",
    functionDer: "1/(x-1)",
    x0: 0.5,
    tol: 0.0001,
    n: 10,
  );
  newton6.newtonRaphsonMethod();
  print("Resultado: ${newton6.message}");
}

/// Prueba del análisis de convergencia
void testAnalisisConvergencia() {
  print("\n" + "="*70);
  print("PRUEBA DE ANÁLISIS DE CONVERGENCIA");
  print("="*70);
  
  var newton = NewtonRaphsonClass(
    function: "x^3 - 2*x - 5",
    functionDer: "3*x^2 - 2",
    x0: 2.0,
    tol: 0.0001,
    n: 20,
    dn: 6,
  );
  
  print("Función: ${newton.function}");
  print("Derivada: ${newton.functionDer}");
  print("Punto inicial: ${newton.x0}");
  
  // Realizar análisis de convergencia
  print("\n--- Análisis de Convergencia ---");
  Map<String, dynamic> analisis = newton.analizarConvergencia();
  
  for (var entry in analisis.entries) {
    if (entry.key != 'error') {
      print("• ${entry.key}: ${entry.value}");
    }
  }
  
  // Ejecutar método para comparar
  print("\n--- Ejecución del Método ---");
  newton.newtonRaphsonMethod();
  
  if (newton.success) {
    print("✅ Convergió a: ${newton.result} en ${newton.iterations} iteraciones");
  } else {
    print("❌ No convergió: ${newton.message}");
  }
}

/// Prueba de funciones para graficación
void testFuncionesGraficacion() {
  print("\n" + "="*70);
  print("PRUEBA DE FUNCIONES PARA GRAFICACIÓN");
  print("="*70);
  
  var newton = NewtonRaphsonClass(
    function: "x^3 - x - 1",
    functionDer: "3*x^2 - 1",
    x0: 1.5,
    tol: 0.0001,
    n: 20,
    dn: 4,
  );
  
  print("Función: ${newton.function}");
  print("Punto inicial: ${newton.x0}");
  
  // Obtener puntos para graficar la función
  print("\n--- Puntos para graficar la función ---");
  List<Map<String, double>> puntosFuncion = newton.obtenerPuntosFuncion(numPuntos: 10);
  print("Se generaron ${puntosFuncion.length} puntos");
  print("Primeros 5 puntos:");
  for (int i = 0; i < 5 && i < puntosFuncion.length; i++) {
    var punto = puntosFuncion[i];
    print("  x = ${punto['x']!.toStringAsFixed(2)}, y = ${punto['y']!.toStringAsFixed(4)}");
  }
  
  // Obtener puntos para graficar la derivada
  print("\n--- Puntos para graficar la derivada ---");
  List<Map<String, double>> puntosDerivada = newton.obtenerPuntosDerivada(numPuntos: 10);
  print("Se generaron ${puntosDerivada.length} puntos");
  print("Primeros 5 puntos:");
  for (int i = 0; i < 5 && i < puntosDerivada.length; i++) {
    var punto = puntosDerivada[i];
    print("  x = ${punto['x']!.toStringAsFixed(2)}, y = ${punto['y']!.toStringAsFixed(4)}");
  }
  
  // Ejecutar método
  print("\n--- Ejecución del Método ---");
  newton.newtonRaphsonMethod();
  
  if (newton.success) {
    print("✅ Raíz encontrada: ${newton.result}");
  }
}

/// Función auxiliar para imprimir tabla de resultados
void printTablaResultados(List<Map<String, dynamic>> tabla) {
  if (tabla.isEmpty) {
    print("No hay iteraciones que mostrar");
    return;
  }
  
  // Imprimir encabezado
  String header = " Iteración │     xn     │    f(xn)   │   f'(xn)   │    xn+1    │    Error   ";
  print(header);
  print("-" * header.length);
  
  // Imprimir todas las filas
  for (var fila in tabla) {
    String row = " ${fila['i'].toString().padLeft(8)} │ ";
    row += "${fila['xn'].toString().padLeft(10)} │ ";
    row += "${fila['fxn'].toString().padLeft(10)} │ ";
    row += "${fila['fpxn'].toString().padLeft(10)} │ ";
    row += "${fila['xn1'].toString().padLeft(10)} │ ";
    row += "${fila['error'].toString().padLeft(10)}";
    print(row);
  }
}

/// Función auxiliar para imprimir las últimas N iteraciones
void printUltimasIteraciones(List<Map<String, dynamic>> tabla, int n) {
  if (tabla.isEmpty) {
    print("No hay iteraciones que mostrar");
    return;
  }
  
  int startIndex = (tabla.length > n) ? tabla.length - n : 0;
  
  // Imprimir encabezado
  String header = " Iteración │     xn     │    f(xn)   │   f'(xn)   │    xn+1    │    Error   ";
  print(header);
  print("-" * header.length);
  
  // Imprimir últimas N filas
  for (int i = startIndex; i < tabla.length; i++) {
    var fila = tabla[i];
    String row = " ${fila['i'].toString().padLeft(8)} │ ";
    row += "${fila['xn'].toString().padLeft(10)} │ ";
    row += "${fila['fxn'].toString().padLeft(10)} │ ";
    row += "${fila['fpxn'].toString().padLeft(10)} │ ";
    row += "${fila['xn1'].toString().padLeft(10)} │ ";
    row += "${fila['error'].toString().padLeft(10)}";
    print(row);
  }
}
