import 'dart:io';
import 'GaussSeidelRelaxationClass.Dart';

void main() {
  print('=== Prueba del Método de Gauss-Seidel con Relajación (SOR) ===\n');
  
  // Caso de prueba 1: Sistema simple 3x3
  print('Caso de prueba 1: Sistema 3x3 diagonalmente dominante');
  print('Matriz aumentada:');
  print('[4, -1, 0 | 3]');
  print('[-1, 4, -1 | 3]');
  print('[0, -1, 4 | 3]');
  print('');
  
  GaussSeidelRelaxationClass gsr1 = GaussSeidelRelaxationClass();
  gsr1.n = 3;
  gsr1.tol = 0.0001;
  gsr1.n_pol = 50;
  gsr1.dn = 6;
  gsr1.omega = 1.1; // Sobre-relajación
  
  // Crear matriz
  gsr1.crearMatrizVacia();
  gsr1.matrix[0] = [4, -1, 0, 3];
  gsr1.matrix[1] = [-1, 4, -1, 3];
  gsr1.matrix[2] = [0, -1, 4, 3];
  
  // Establecer vector inicial
  gsr1.establecerVectorInicial("0,0,0");
  
  // Ejecutar método
  gsr1.gaussSeidelRelaxationMethod();
  
  print('Resultados:');
  print(gsr1.message);
  print('Iteraciones: ${gsr1.iterations}');
  print('Éxito: ${gsr1.success}');
  
  List<String> solucion1 = gsr1.obtenerSolucion();
  print('Solución encontrada:');
  for (String sol in solucion1) {
    print('  $sol');
  }
  
  List<double> erroresResiduales1 = gsr1.calcularErroresResiduales();
  print('Errores residuales:');
  for (int i = 0; i < erroresResiduales1.length; i++) {
    print('  Ecuación ${i+1}: ${erroresResiduales1[i]}');
  }
  
  print('\n' + '='*60 + '\n');
  
  // Caso de prueba 2: Comparación con diferentes valores de omega
  print('Caso de prueba 2: Comparación con diferentes valores de ω');
  print('Mismo sistema con diferentes factores de relajación:');
  print('');
  
  List<double> omegas = [0.8, 1.0, 1.2, 1.5];
  
  for (double omega in omegas) {
    GaussSeidelRelaxationClass gsr = GaussSeidelRelaxationClass();
    gsr.n = 3;
    gsr.tol = 0.0001;
    gsr.n_pol = 50;
    gsr.dn = 6;
    gsr.omega = omega;
    
    // Misma matriz
    gsr.crearMatrizVacia();
    gsr.matrix[0] = [4, -1, 0, 3];
    gsr.matrix[1] = [-1, 4, -1, 3];
    gsr.matrix[2] = [0, -1, 4, 3];
    gsr.establecerVectorInicial("0,0,0");
    
    gsr.gaussSeidelRelaxationMethod();
    
    String tipoRelajacion = omega == 1.0 ? "Gauss-Seidel estándar" : 
                           (omega < 1.0 ? "Sub-relajación" : "Sobre-relajación");
    
    print('ω = ${omega.toStringAsFixed(1)} ($tipoRelajacion):');
    print('  Iteraciones: ${gsr.iterations}, Éxito: ${gsr.success}');
    if (gsr.success) {
      List<String> sol = gsr.obtenerSolucion();
      print('  Solución: ${sol.map((s) => s.split('=')[1].trim()).join(', ')}');
    }
    print('');
  }
  
  print('='*60 + '\n');
  
  // Caso de prueba 3: Sistema 2x2
  print('Caso de prueba 3: Sistema 2x2');
  print('Matriz aumentada:');
  print('[5, 2 | 17]');
  print('[3, 8 | 26]');
  print('');
  
  GaussSeidelRelaxationClass gsr2 = GaussSeidelRelaxationClass();
  gsr2.n = 2;
  gsr2.tol = 0.00001;
  gsr2.n_pol = 30;
  gsr2.dn = 6;
  gsr2.omega = 1.25;
  
  gsr2.crearMatrizVacia();
  gsr2.matrix[0] = [5, 2, 17];
  gsr2.matrix[1] = [3, 8, 26];
  gsr2.establecerVectorInicial("0,0");
  
  gsr2.gaussSeidelRelaxationMethod();
  
  print('Resultados:');
  print(gsr2.message);
  print('Iteraciones: ${gsr2.iterations}');
  print('Éxito: ${gsr2.success}');
  
  List<String> solucion2 = gsr2.obtenerSolucion();
  print('Solución encontrada:');
  for (String sol in solucion2) {
    print('  $sol');
  }
  
  // Análisis de convergencia
  print('\nAnálisis de convergencia:');
  Map<String, dynamic> analisis = gsr2.analizarConvergencia();
  analisis.forEach((key, value) {
    print('  $key: $value');
  });
  
  print('\n' + '='*60 + '\n');
  
  // Caso de prueba 4: Validación de parámetros
  print('Caso de prueba 4: Validación de parámetros');
  
  // Probar omega inválido
  GaussSeidelRelaxationClass gsr3 = GaussSeidelRelaxationClass();
  gsr3.n = 2;
  gsr3.tol = 0.001;
  gsr3.n_pol = 10;
  gsr3.omega = 2.5; // Omega inválido
  
  gsr3.crearMatrizVacia();
  gsr3.matrix[0] = [1, 0, 1];
  gsr3.matrix[1] = [0, 1, 1];
  gsr3.establecerVectorInicial("0,0");
  
  gsr3.gaussSeidelRelaxationMethod();
  
  print('Prueba con ω = 2.5 (inválido):');
  print('Mensaje: ${gsr3.message}');
  print('Éxito: ${gsr3.success}');
  
  // Probar omega = 0
  gsr3.omega = 0.0;
  gsr3.gaussSeidelRelaxationMethod();
  
  print('\nPrueba con ω = 0.0 (inválido):');
  print('Mensaje: ${gsr3.message}');
  print('Éxito: ${gsr3.success}');
  
  print('\n' + '='*60);
  print('=== Pruebas completadas ===');
}
