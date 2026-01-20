import 'NumericIntegrationByInterpolationClass.Dart';

void main() {
  print("=== Prueba de Métodos de Integración Numérica ===\n");
  
  // Caso de prueba 1: Integral de x^2 de 0 a 2 = 8/3 ≈ 2.6667
  testIntegral("x^2", 0.0, 2.0, 10, 4, "Integral de x^2 de 0 a 2");
  
  // Caso de prueba 2: Integral de sin(x) de 0 a π = 2
  testIntegral("sin(x)", 0.0, 3.14159265359, 20, 6, "Integral de sin(x) de 0 a π");
  
  // Caso de prueba 3: Integral de e^x de 0 a 1 = e - 1 ≈ 1.7183
  testIntegral("exp(x)", 0.0, 1.0, 15, 6, "Integral de e^x de 0 a 1");
  
  // Caso de prueba 4: Integral de 1/x de 1 a 2 = ln(2) ≈ 0.6931
  testIntegral("1/x", 1.0, 2.0, 12, 6, "Integral de 1/x de 1 a 2");
  
  print("=== Pruebas completadas ===");
  
  // Ejecutar pruebas de validación
  testValidation();
}

void testIntegral(String function, double lowerLimit, double upperLimit, int n, int dn, String description) {
  print("\n" + "="*60);
  print("$description");
  print("="*60);
  
  NumericInterpolationByInterpolationClass integration = NumericInterpolationByInterpolationClass(
    function: function,
    lowerLimit: lowerLimit,
    upperLimit: upperLimit,
    n: n,
    dn: dn,
  );
  
  // Calcular todos los métodos
  integration.calculateAllMethods();
  
  if (integration.success) {
    print(integration.getFormattedResults());
    print(integration.compareResults());
  } else {
    print("Error: ${integration.message}");
  }
  
  // Probar métodos individuales
  print("\n--- Prueba de métodos individuales ---");
  
  try {
    integration.trapezoidalRuleMethod();
    print("Trapecio simple: ${integration.trapezoidalRule.toStringAsFixed(dn)}");
  } catch (e) {
    print("Error en trapecio simple: $e");
  }
  
  try {
    integration.simpsonRuleMethod();
    print("Simpson (1/3): ${integration.simpsonRule.toStringAsFixed(dn)}");
  } catch (e) {
    print("Error en Simpson: $e");
  }
  
  try {
    integration.compositeSimpsonRuleMethod();
    print("Simpson compuesto: ${integration.compositeSimpsonRule.toStringAsFixed(dn)}");
  } catch (e) {
    print("Error en Simpson compuesto: $e");
  }
  
  try {
    integration.midPointRuleMethod();
    print("Punto medio: ${integration.midPointRule.toStringAsFixed(dn)}");
  } catch (e) {
    print("Error en punto medio: $e");
  }
  
  try {
    integration.compositeTrapezoidalRuleMethod();
    print("Trapecio compuesto: ${integration.trapezoidalRule.toStringAsFixed(dn)}");
  } catch (e) {
    print("Error en trapecio compuesto: $e");
  }
}

void testValidation() {
  print("\n=== Pruebas de Validación ===");
  
  // Caso 1: Función vacía
  var integration1 = NumericInterpolationByInterpolationClass(
    function: "",
    lowerLimit: 0.0,
    upperLimit: 1.0,
    n: 10,
    dn: 4,
  );
  integration1.calculateAllMethods();
  print("Función vacía: ${integration1.message}");
  
  // Caso 2: Límite inferior mayor que superior
  var integration2 = NumericInterpolationByInterpolationClass(
    function: "x^2",
    lowerLimit: 2.0,
    upperLimit: 1.0,
    n: 10,
    dn: 4,
  );
  integration2.calculateAllMethods();
  print("Límites invertidos: ${integration2.message}");
  
  // Caso 3: n negativo
  var integration3 = NumericInterpolationByInterpolationClass(
    function: "x^2",
    lowerLimit: 0.0,
    upperLimit: 1.0,
    n: -5,
    dn: 4,
  );
  integration3.calculateAllMethods();
  print("n negativo: ${integration3.message}");
  
  // Caso 4: Función inválida
  var integration4 = NumericInterpolationByInterpolationClass(
    function: "sqrt(x-5)", // Inválida en [0,1]
    lowerLimit: 0.0,
    upperLimit: 1.0,
    n: 10,
    dn: 4,
  );
  integration4.calculateAllMethods();
  print("Función inválida: ${integration4.message}");
}
