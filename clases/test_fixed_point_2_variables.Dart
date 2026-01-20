import 'dart:math';
import 'FixedPoint2VariablesClass.Dart';

void main() {
  print("=== PRUEBA DEL MÉTODO DE PUNTO FIJO 2 VARIABLES ===\n");
  
  // Ejecutar todos los casos de prueba
  testCaso1();
  //testCaso2();
  //testCaso3();
  //testCaso4();
  //testCasosError();
  //testAnalisisConvergencia();
  //testFuncionesGraficacion();
  //testTrayectoriaConvergencia();
  //testVerificacionFormaPuntoFijo();
  
  print("\n=== TODAS LAS PRUEBAS COMPLETADAS ===");
}

/// Caso 1: Sistema simple con funciones lineales
/// x = (y + 2)/3, y = (x + 1)/2
/// Solución: x = 1, y = 1
void testCaso1() {
  print("\n" + "="*70);
  print("CASO 1: Sistema lineal simple");
  print("Solución esperada: x = 1, y = 1");
  print("="*70);
  
  var fixedPoint = FixedPoint2VariablesClass(
    function1: "sqrt(y + 0.5)",
    function2: "sqrt(x)",
    x: 0.0,
    y: 0.0,
    tol: 0.0001,
    n: 50,
    dn: 6,
    title: "Punto Fijo - Sistema Lineal",
    subtitle: "",
    index: "1",
  );
  
  print("Parámetros de entrada:");
  print("• Función g1(x,y): ${fixedPoint.function1}");
  print("• Función g2(x,y): ${fixedPoint.function2}");
  print("• Punto inicial: (${fixedPoint.x}, ${fixedPoint.y})");
  print("• Tolerancia: ${fixedPoint.tol}");
  print("• Iteraciones máximas: ${fixedPoint.n}");
  print("• Decimales: ${fixedPoint.dn}");
  
  // Validar parámetros
  print("\nValidando parámetros...");
  String? error = fixedPoint.validarParametros();
  if (error != null) {
    print("❌ Error en validación: $error");
    return;
  }
  print("✅ Parámetros válidos");
  
  // Ejecutar método
  print("\nEjecutando método de punto fijo...");
  fixedPoint.fixedPoint2VariablesMethod();
  
  if (fixedPoint.success) {
    print("✅ Método convergió exitosamente");
    print("• Solución encontrada: (${fixedPoint.x}, ${fixedPoint.y})");
    print("• Iteraciones: ${fixedPoint.iterations}");
    print("• Error final: ${fixedPoint.result}");
    print("• Mensaje: ${fixedPoint.message}");
    
    // Verificación
    double g1Final = (fixedPoint.y + 2)/3;
    double g2Final = (fixedPoint.x + 1)/2;
    double errorX = (g1Final - fixedPoint.x).abs();
    double errorY = (g2Final - fixedPoint.y).abs();
    double errorTotal = max(errorX, errorY);
    
    print("• Verificación |g1(x,y) - x|: $errorX");
    print("• Verificación |g2(x,y) - y|: $errorY");
    
    if (errorTotal < fixedPoint.tol) {
      print("✅ Solución verificada correctamente");
    } else {
      print("⚠️  Solución con error significativo");
    }
  } else {
    print("❌ El método no convergió: ${fixedPoint.message}");
  }
  
  // Mostrar tabla de iteraciones
  print("\n--- Tabla de Iteraciones ---");
  printTablaResultados(fixedPoint.obtenerTablaResultados());
}

/// Caso 2: Sistema con funciones que incluyen sqrt()
/// x = sqrt(y + 2), y = sqrt(x + 2)
/// Solución: x ≈ 1.618, y ≈ 1.618 (número áureo)
void testCaso2() {
  print("\n" + "="*70);
  print("CASO 2: Sistema con funciones sqrt()");
  print("Solución esperada: x ≈ 1.618, y ≈ 1.618 (número áureo)");
  print("="*70);
  
  var fixedPoint = FixedPoint2VariablesClass(
    function1: "sqrt(y + 2)",
    function2: "sqrt(x + 2)",
    x: 1.0,
    y: 1.0,
    tol: 0.000001,
    n: 100,
    dn: 8,
    title: "Punto Fijo - Sistema con sqrt()",
    subtitle: "x = sqrt(y+2), y = sqrt(x+2)",
    index: "2",
  );
  
  print("Parámetros de entrada:");
  print("• Función g1(x,y): ${fixedPoint.function1}");
  print("• Función g2(x,y): ${fixedPoint.function2}");
  print("• Punto inicial: (${fixedPoint.x}, ${fixedPoint.y})");
  print("• Tolerancia: ${fixedPoint.tol}");
  
  // Ejecutar método
  print("\nEjecutando método...");
  fixedPoint.fixedPoint2VariablesMethod();
  
  if (fixedPoint.success) {
    print("✅ Método convergió exitosamente");
    print("• Solución encontrada: (${fixedPoint.x}, ${fixedPoint.y})");
    print("• Iteraciones: ${fixedPoint.iterations}");
    
    // Verificación
    double g1Final = sqrt(fixedPoint.y + 2);
    double g2Final = sqrt(fixedPoint.x + 2);
    double errorX = (g1Final - fixedPoint.x).abs();
    double errorY = (g2Final - fixedPoint.y).abs();
    
    print("• Verificación |sqrt(y+2) - x|: $errorX");
    print("• Verificación |sqrt(x+2) - y|: $errorY");
    
    if (errorX < fixedPoint.tol && errorY < fixedPoint.tol) {
      print("✅ Solución verificada correctamente");
    }
    
    // Verificar si es el número áureo
    double phi = (1 + sqrt(5)) / 2;
    double errorPhiX = (fixedPoint.x - phi).abs();
    double errorPhiY = (fixedPoint.y - phi).abs();
    print("• Número áureo φ: $phi");
    print("• Error respecto a φ en x: $errorPhiX");
    print("• Error respecto a φ en y: $errorPhiY");
  } else {
    print("❌ El método no convergió: ${fixedPoint.message}");
  }
  
  // Mostrar últimas iteraciones
  print("\n--- Últimas 5 Iteraciones ---");
  printUltimasIteraciones(fixedPoint.obtenerTablaResultados(), 5);
}

/// Caso 3: Sistema con funciones trigonométricas y exponenciales
/// x = sin(y) + 0.5, y = cos(x) + 0.5
void testCaso3() {
  print("\n" + "="*70);
  print("CASO 3: Sistema con funciones trigonométricas y exponenciales");
  print("x = sin(y) + 0.5, y = cos(x) + 0.5");
  print("="*70);
  
  var fixedPoint = FixedPoint2VariablesClass(
    function1: "sin(y) + 0.5",
    function2: "cos(x) + 0.5",
    x: 0.5,
    y: 0.5,
    tol: 0.00001,
    n: 80,
    dn: 6,
    title: "Punto Fijo - Sistema Trigonométrico",
    subtitle: "x = sin(y)+0.5, y = cos(x)+0.5",
    index: "3",
  );
  
  print("Parámetros de entrada:");
  print("• Función g1(x,y): ${fixedPoint.function1}");
  print("• Función g2(x,y): ${fixedPoint.function2}");
  print("• Punto inicial: (${fixedPoint.x}, ${fixedPoint.y})");
  
  // Ejecutar método
  print("\nEjecutando método...");
  fixedPoint.fixedPoint2VariablesMethod();
  
  if (fixedPoint.success) {
    print("✅ Método convergió exitosamente");
    print("• Solución encontrada: (${fixedPoint.x}, ${fixedPoint.y})");
    print("• Iteraciones: ${fixedPoint.iterations}");
    
    // Verificación
    double g1Final = sin(fixedPoint.y) + 0.5;
    double g2Final = cos(fixedPoint.x) + 0.5;
    double errorX = (g1Final - fixedPoint.x).abs();
    double errorY = (g2Final - fixedPoint.y).abs();
    
    print("• Verificación |sin(y)+0.5 - x|: $errorX");
    print("• Verificación |cos(x)+0.5 - y|: $errorY");
    
    if (errorX < fixedPoint.tol && errorY < fixedPoint.tol) {
      print("✅ Solución verificada correctamente");
    }
  } else {
    print("❌ El método no convergió: ${fixedPoint.message}");
  }
}

/// Caso 4: Sistema con funciones que incluyen potencias y logaritmos
/// x = log(y^2 + 1), y = exp(x/2)
void testCaso4() {
  print("\n" + "="*70);
  print("CASO 4: Sistema con funciones log() y exp()");
  print("x = log(y^2 + 1), y = exp(x/2)");
  print("="*70);
  
  var fixedPoint = FixedPoint2VariablesClass(
    function1: "log(y^2 + 1)",
    function2: "exp(x/2)",
    x: 0.5,
    y: 1.0,
    tol: 0.0001,
    n: 60,
    dn: 6,
    title: "Punto Fijo - Sistema Log-Exp",
    subtitle: "x = log(y²+1), y = exp(x/2)",
    index: "4",
  );
  
  print("Parámetros de entrada:");
  print("• Función g1(x,y): ${fixedPoint.function1}");
  print("• Función g2(x,y): ${fixedPoint.function2}");
  print("• Punto inicial: (${fixedPoint.x}, ${fixedPoint.y})");
  
  // Ejecutar método
  print("\nEjecutando método...");
  fixedPoint.fixedPoint2VariablesMethod();
  
  if (fixedPoint.success) {
    print("✅ Método convergió exitosamente");
    print("• Solución encontrada: (${fixedPoint.x}, ${fixedPoint.y})");
    print("• Iteraciones: ${fixedPoint.iterations}");
    
    // Verificación
    double g1Final = log(pow(fixedPoint.y, 2) + 1);
    double g2Final = exp(fixedPoint.x / 2);
    double errorX = (g1Final - fixedPoint.x).abs();
    double errorY = (g2Final - fixedPoint.y).abs();
    
    print("• Verificación |log(y²+1) - x|: $errorX");
    print("• Verificación |exp(x/2) - y|: $errorY");
    
    if (errorX < fixedPoint.tol && errorY < fixedPoint.tol) {
      print("✅ Solución verificada correctamente");
    }
  } else {
    print("❌ El método no convergió: ${fixedPoint.message}");
  }
}

/// Pruebas de casos de error
void testCasosError() {
  print("\n" + "="*70);
  print("PRUEBAS DE CASOS DE ERROR");
  print("="*70);
  
  // Caso 1: Función 1 vacía
  print("\n--- Caso 1: Función 1 vacía ---");
  var fixedPoint1 = FixedPoint2VariablesClass(
    function1: "",
    function2: "(x + 1)/2",
    x: 0.0,
    y: 0.0,
    tol: 0.0001,
    n: 10,
  );
  fixedPoint1.fixedPoint2VariablesMethod();
  print("Resultado: ${fixedPoint1.message}");
  
  // Caso 2: Función 2 vacía
  print("\n--- Caso 2: Función 2 vacía ---");
  var fixedPoint2 = FixedPoint2VariablesClass(
    function1: "(y + 2)/3",
    function2: "",
    x: 0.0,
    y: 0.0,
    tol: 0.0001,
    n: 10,
  );
  fixedPoint2.fixedPoint2VariablesMethod();
  print("Resultado: ${fixedPoint2.message}");
  
  // Caso 3: Tolerancia no válida
  print("\n--- Caso 3: Tolerancia no válida ---");
  var fixedPoint3 = FixedPoint2VariablesClass(
    function1: "(y + 2)/3",
    function2: "(x + 1)/2",
    x: 0.0,
    y: 0.0,
    tol: -0.0001,
    n: 10,
  );
  fixedPoint3.fixedPoint2VariablesMethod();
  print("Resultado: ${fixedPoint3.message}");
  
  // Caso 4: Iteraciones no válidas
  print("\n--- Caso 4: Iteraciones no válidas ---");
  var fixedPoint4 = FixedPoint2VariablesClass(
    function1: "(y + 2)/3",
    function2: "(x + 1)/2",
    x: 0.0,
    y: 0.0,
    tol: 0.0001,
    n: 0,
  );
  fixedPoint4.fixedPoint2VariablesMethod();
  print("Resultado: ${fixedPoint4.message}");
  
  // Caso 5: Función no evaluable en punto inicial
  print("\n--- Caso 5: Función no evaluable en punto inicial ---");
  var fixedPoint5 = FixedPoint2VariablesClass(
    function1: "sqrt(y - 2)",
    function2: "log(x)",
    x: -1.0,
    y: 1.0,
    tol: 0.0001,
    n: 10,
  );
  fixedPoint5.fixedPoint2VariablesMethod();
  print("Resultado: ${fixedPoint5.message}");
  
  // Caso 6: Función con división por cero
  print("\n--- Caso 6: Función con división por cero ---");
  var fixedPoint6 = FixedPoint2VariablesClass(
    function1: "1/(x - 1)",
    function2: "1/(y - 1)",
    x: 1.0,
    y: 1.0,
    tol: 0.0001,
    n: 10,
  );
  fixedPoint6.fixedPoint2VariablesMethod();
  print("Resultado: ${fixedPoint6.message}");
}

/// Prueba del análisis de convergencia
void testAnalisisConvergencia() {
  print("\n" + "="*70);
  print("PRUEBA DE ANÁLISIS DE CONVERGENCIA");
  print("="*70);
  
  var fixedPoint = FixedPoint2VariablesClass(
    function1: "(y + 2)/3",
    function2: "(x + 1)/2",
    x: 0.0,
    y: 0.0,
    tol: 0.0001,
    n: 20,
    dn: 6,
  );
  
  print("Función g1(x,y): ${fixedPoint.function1}");
  print("Función g2(x,y): ${fixedPoint.function2}");
  print("Punto inicial: (${fixedPoint.x}, ${fixedPoint.y})");
  
  // Realizar análisis de convergencia
  print("\n--- Análisis de Convergencia ---");
  Map<String, dynamic> analisis = fixedPoint.analizarConvergencia();
  
  for (var entry in analisis.entries) {
    if (entry.key != 'error') {
      print("• ${entry.key}: ${entry.value}");
    }
  }
  
  // Ejecutar método para comparar
  print("\n--- Ejecución del Método ---");
  fixedPoint.fixedPoint2VariablesMethod();
  
  if (fixedPoint.success) {
    print("✅ Convergió a (${fixedPoint.x}, ${fixedPoint.y}) en ${fixedPoint.iterations} iteraciones");
  } else {
    print("❌ No convergió: ${fixedPoint.message}");
  }
}

/// Prueba de trayectoria de convergencia
void testTrayectoriaConvergencia() {
  print("\n" + "="*70);
  print("PRUEBA DE TRAYECTORIA DE CONVERGENCIA");
  print("="*70);
  
  var fixedPoint = FixedPoint2VariablesClass(
    function1: "(y + 2)/3",
    function2: "(x + 1)/2",
    x: 0.0,
    y: 0.0,
    tol: 0.0001,
    n: 10,
    dn: 4,
  );
  
  print("Función g1(x,y): ${fixedPoint.function1}");
  print("Función g2(x,y): ${fixedPoint.function2}");
  print("Punto inicial: (${fixedPoint.x}, ${fixedPoint.y})");
  
  // Ejecutar método
  print("\nEjecutando método...");
  fixedPoint.fixedPoint2VariablesMethod();
  
  if (fixedPoint.success) {
    print("✅ Método convergió exitosamente");
    
    // Obtener trayectoria de convergencia
    print("\n--- Trayectoria de Convergencia ---");
    List<Map<String, double>> trayectoria = fixedPoint.obtenerTrayectoriaConvergencia();
    print("Se generaron ${trayectoria.length} puntos en la trayectoria");
    print("Trayectoria completa:");
    for (var punto in trayectoria) {
      print("  Iteración ${punto['iteracion']}: (${punto['x']!.toStringAsFixed(4)}, ${punto['y']!.toStringAsFixed(4)}) - Error: ${punto['error']!.toStringAsFixed(6)}");
    }
    
    // Obtener historial de errores
    print("\n--- Historial de Errores ---");
    List<Map<String, double>> historialErrores = fixedPoint.obtenerHistorialErrores();
    print("Historial de errores por iteración:");
    for (var error in historialErrores) {
      print("  Iteración ${error['iteracion']}: Error x = ${error['error_x']!.toStringAsFixed(6)}, Error y = ${error['error_y']!.toStringAsFixed(6)}, Error máx = ${error['error_max']!.toStringAsFixed(6)}");
    }
  } else {
    print("❌ El método no convergió: ${fixedPoint.message}");
  }
}

/// Prueba de verificación de forma punto fijo
void testVerificacionFormaPuntoFijo() {
  print("\n" + "="*70);
  print("PRUEBA DE VERIFICACIÓN DE FORMA PUNTO FIJO");
  print("="*70);
  
  var fixedPoint = FixedPoint2VariablesClass(
    function1: "sqrt(y + 1)",
    function2: "sqrt(x + 1)",
    x: 1.0,
    y: 1.0,
    tol: 0.0001,
    n: 20,
    dn: 6,
  );
  
  print("Función g1(x,y): ${fixedPoint.function1}");
  print("Función g2(x,y): ${fixedPoint.function2}");
  print("Punto inicial: (${fixedPoint.x}, ${fixedPoint.y})");
  
  // Verificar forma punto fijo
  print("\n--- Verificación de Forma Punto Fijo ---");
  Map<String, dynamic> verificacion = fixedPoint.verificarFormaPuntoFijo();
  
  for (var entry in verificacion.entries) {
    if (entry.key != 'error') {
      print("• ${entry.key}: ${entry.value}");
    }
  }
  
  // Calcular radio espectral
  print("\n--- Cálculo de Radio Espectral ---");
  double radioEspectral = fixedPoint.calcularRadioEspectral(fixedPoint.x, fixedPoint.y);
  print("• Radio espectral en punto inicial: ${radioEspectral.toStringAsFixed(6)}");
  
  if (radioEspectral < 1) {
    print("✅ Radio espectral < 1 - Convergencia garantizada");
  } else {
    print("⚠️  Radio espectral ≥ 1 - Convergencia no garantizada");
  }
  
  // Obtener información del sistema
  print("\n--- Información del Sistema ---");
  Map<String, dynamic> infoSistema = fixedPoint.obtenerInfoSistema();
  
  for (var entry in infoSistema.entries) {
    if (entry.key != 'error') {
      if (entry.value is Map) {
        print("• ${entry.key}:");
        for (var subEntry in (entry.value as Map).entries) {
          print("    ${subEntry.key}: ${subEntry.value}");
        }
      } else {
        print("• ${entry.key}: ${entry.value}");
      }
    }
  }
}

/// Función auxiliar para imprimir tabla de resultados
void printTablaResultados(List<List<String>> tabla) {
  if (tabla.isEmpty) {
    print("No hay iteraciones que mostrar");
    return;
  }
  
  // Imprimir encabezado
  String header = " Iteración │      x      │      y      │   Error x   │   Error y   │ Error Máximo";
  print(header);
  print("-" * header.length);
  
  // Imprimir todas las filas
  for (int i = 0; i < tabla.length; i++) {
    String row = " ${tabla[i][0].padLeft(8)} │ ";
    row += "${tabla[i][1].padLeft(11)} │ ";
    row += "${tabla[i][2].padLeft(11)} │ ";
    row += "${tabla[i][3].padLeft(11)} │ ";
    row += "${tabla[i][4].padLeft(11)} │ ";
    row += "${tabla[i][5].padLeft(12)}";
    print(row);
  }
}

/// Función auxiliar para imprimir las últimas N iteraciones
void printUltimasIteraciones(List<List<String>> tabla, int n) {
  if (tabla.isEmpty) {
    print("No hay iteraciones que mostrar");
    return;
  }
  
  int startIndex = (tabla.length > n) ? tabla.length - n : 0;
  
  // Imprimir encabezado
  String header = " Iteración │      x      │      y      │   Error x   │   Error y   │ Error Máximo";
  print(header);
  print("-" * header.length);
  
  // Imprimir últimas N filas
  for (int i = startIndex; i < tabla.length; i++) {
    String row = " ${tabla[i][0].padLeft(8)} │ ";
    row += "${tabla[i][1].padLeft(11)} │ ";
    row += "${tabla[i][2].padLeft(11)} │ ";
    row += "${tabla[i][3].padLeft(11)} │ ";
    row += "${tabla[i][4].padLeft(11)} │ ";
    row += "${tabla[i][5].padLeft(12)}";
    print(row);
  }
}

/// Prueba de funciones para graficación
void testFuncionesGraficacion() {
  print("\n" + "="*70);
  print("PRUEBA DE FUNCIONES PARA GRAFICACIÓN");
  print("="*70);
  
  var fixedPoint = FixedPoint2VariablesClass(
    function1: "sqrt(y + 1)",
    function2: "sqrt(x + 1)",
    x: 1.0,
    y: 1.0,
    tol: 0.0001,
    n: 20,
    dn: 4,
  );
  
  print("Función g1(x,y): ${fixedPoint.function1}");
  print("Función g2(x,y): ${fixedPoint.function2}");
  print("Punto inicial: (${fixedPoint.x}, ${fixedPoint.y})");
  
  // Obtener puntos para graficar la función 1
  print("\n--- Puntos para graficar la función g1(x,y) ---");
  List<Map<String, double>> puntosFuncion1 = fixedPoint.obtenerPuntosFuncion1(numPuntos: 10);
  print("Se generaron ${puntosFuncion1.length} puntos");
  print("Primeros 5 puntos:");
  for (int i = 0; i < 5 && i < puntosFuncion1.length; i++) {
    var punto = puntosFuncion1[i];
    print("  x = ${punto['x']!.toStringAsFixed(2)}, y = ${punto['y']!.toStringAsFixed(4)}, tipo = ${punto['tipo']}");
  }
  
  // Obtener puntos para graficar la función 2
  print("\n--- Puntos para graficar la función g2(x,y) ---");
  List<Map<String, double>> puntosFuncion2 = fixedPoint.obtenerPuntosFuncion2(numPuntos: 10);
  print("Se generaron ${puntosFuncion2.length} puntos");
  print("Primeros 5 puntos:");
  for (int i = 0; i < 5 && i < puntosFuncion2.length; i++) {
    var punto = puntosFuncion2[i];
    print("  x = ${punto['x']!.toStringAsFixed(2)}, y = ${punto['y']!.toStringAsFixed(4)}, tipo = ${punto['tipo']}");
  }
  
  // Ejecutar método
  print("\n--- Ejecución del Método ---");
  fixedPoint.fixedPoint2VariablesMethod();
  
  if (fixedPoint.success) {
    print("✅ Solución encontrada: (${fixedPoint.x}, ${fixedPoint.y})");
  }
}
