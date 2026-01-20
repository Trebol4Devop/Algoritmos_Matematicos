import 'dart:math' as math;
import 'MethodClass.Dart';
import 'ComplexOperationClass.Dart';

/// Implementación del método de Müller para encontrar raíces reales y complejas
class MullerClass extends MethodClass {
  List<double> coefs;
  double x0;
  double x1;
  double x2;
  double tol;
  int n;
  int dn;
  List<Map<String, dynamic>> resultTable;
  
  MullerClass({
    this.coefs = const [],
    this.x0 = 0.0,
    this.x1 = 0.0,
    this.x2 = 0.0,
    this.tol = 0.0,
    this.n = 0,
    this.dn = 0,
    List<Map<String, dynamic>>? resultTable,
    int id = 8,
    String title = "Método de Müller",
    String subtitle = "Encuentra raíces reales y complejas de polinomios",
    String index = "MUL",
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

  double _evaluarPolinomioReal(double x) {
    double resultado = coefs[0];
    for (int i = 1; i < coefs.length; i++) {
      resultado = resultado * x + coefs[i];
    }
    return resultado;
  }

  Map<String, dynamic> analizarPolinomio() {
    Map<String, dynamic> analisis = {};
    
    try {
      analisis['grado'] = coefs.length - 1;
      analisis['coeficientes'] = coefs;
      analisis['coeficiente_principal'] = coefs[0];

      if (coefs.length == 2) {
        double raiz = -coefs[1] / coefs[0];
        analisis['tipo'] = 'Lineal';
        analisis['raices_reales'] = [raiz];
        analisis['raices_complejas'] = [];
      } else if (coefs.length == 3) {
        double a = coefs[0];
        double b = coefs[1];
        double c = coefs[2];
        double discriminante = b * b - 4 * a * c;
        
        if (discriminante >= 0) {
          double raiz1 = (-b + math.sqrt(discriminante)) / (2 * a);
          double raiz2 = (-b - math.sqrt(discriminante)) / (2 * a);
          analisis['tipo'] = 'Cuadrático';
          analisis['raices_reales'] = [raiz1, raiz2];
          analisis['raices_complejas'] = [];
        } else {
          double realPart = -b / (2 * a);
          double imagPart = math.sqrt(-discriminante) / (2 * a);
          analisis['tipo'] = 'Cuadrático';
          analisis['raices_reales'] = [];
          analisis['raices_complejas'] = [
            {'real': realPart, 'imag': imagPart},
            {'real': realPart, 'imag': -imagPart}
          ];
        }
      } else {
        analisis['tipo'] = 'Polinomio de grado superior';
        analisis['raices_reales'] = [];
        analisis['raices_complejas'] = [];
      }
      
      analisis['puntos_iniciales'] = {
        'x0': x0,
        'x1': x1,
        'x2': x2
      };
      
    } catch (e) {
      analisis['error'] = e.toString();
    }
    
    return analisis;
  }
  List<Map<String, double>> obtenerPuntosPolinomio(double inicio, double fin, int numPuntos) {
    List<Map<String, double>> puntos = [];
    double paso = (fin - inicio) / numPuntos;
    
    for (int i = 0; i <= numPuntos; i++) {
      double x = inicio + i * paso;
      double y = _evaluarPolinomioReal(x);
      puntos.add({'x': x, 'y': y});
    }
    
    return puntos;
  }
  bool _validarEntrada() {
    try {
      if (coefs.isEmpty) {
        message = "Error: debe proporcionar coeficientes del polinomio";
        return false;
      }
      if (coefs[0] == 0.0) {
        message = "Error: el coeficiente principal no puede ser cero";
        return false;
      }
      if (tol <= 0) {
        message = "Error: la tolerancia debe ser mayor que 0";
        return false;
      }
      if (n <= 0) {
        message = "Error: el número máximo de iteraciones debe ser mayor que 0";
        return false;
      }
      if (coefs.length == 2) {
        double raiz = -coefs[1] / coefs[0];
        message = "El polinomio es lineal. Raíz: ${_redondear(raiz)}";
        result = raiz;
        success = true;
        return false;
      }
      return true;
    } catch (e) {
      message = "Error en validación: ${e.toString()}";
      return false;
    }
  }
  void mullerMethod() {
    initialize();
    resultTable.clear();
    try {
      if (!_validarEntrada()) {
        return;
      }
      List<double> X = [x0, x1, x2, 0.0];
      List<double> F = [0.0, 0.0, 0.0, 0.0];
      List<double> H = [0.0, 0.0, 0.0];
      List<double> DEL1 = [0.0, 0.0];
      List<double> ZR = [0.0, 0.0, 0.0, 0.0];
      List<double> ZI = [0.0, 0.0, 0.0, 0.0];
      List<double> GR = [0.0, 0.0, 0.0, 0.0];
      List<double> GI = [0.0, 0.0, 0.0, 0.0];
      List<double> CDEL1R = [0.0, 0.0];
      List<double> CDEL1I = [0.0, 0.0];
      List<double> CH1R = [0.0, 0.0, 0.0];
      List<double> CH1I = [0.0, 0.0, 0.0];
      double CDELR = 0.0, CDELI = 0.0;
      
      int ISW = 0;
      bool hd = false;
      for (int i = 0; i < 3; i++) {
        F[i] = _evaluarPolinomioReal(X[i]);
      }
      
      H[0] = X[1] - X[0];
      H[1] = X[2] - X[1];
      DEL1[0] = (F[1] - F[0]) / H[0];
      DEL1[1] = (F[2] - F[1]) / H[1];
      double DEL = (DEL1[1] - DEL1[0]) / (H[1] + H[0]);
      
      int I = 3;
      bool converged = false;
      bool OK = true;
      
      while (I <= n && OK && !converged) {
        if (ISW == 0) {
          double B = DEL1[1] + H[1] * DEL;
          double D = B * B - 4.0 * F[2] * DEL;
          
          if (D >= 0.0) {
            if (DEL.abs() <= 1e-20) {
              if (DEL1[1].abs() <= 1e-20) {
                OK = false;
                message = "Error: división por cero en caso real";
              } else {
                X[3] = (F[2] - DEL1[1] * X[2]) / DEL1[1];
                H[2] = X[3] - X[2];
              }
            } else {
              D = math.sqrt(D);
              double E = B + D;
              if ((B - D).abs() > E.abs()) {
                E = B - D;
              }
              H[2] = -2.0 * F[2] / E;
              X[3] = X[2] + H[2];
            }
            
            if (OK) {
              F[3] = _evaluarPolinomioReal(X[3]);
              double error = H[2].abs();
              
              Map<String, dynamic> iteracion = {
                "i": I,
                "x0": _redondear(X[0]),
                "x1": _redondear(X[1]),
                "x2": _redondear(X[2]),
                "x3": _redondear(X[3]),
                "error": _redondear(error)
              };
              resultTable.add(iteracion);
              
              if (error < tol) {
                success = true;
                result = _redondear(X[3]);
                message = "Solución real encontrada en iteración $I\n"
                          "Raíz: ${_redondear(X[3])}\n"
                          "Error final: ${_redondear(error)}";
                iterations = I;
                converged = true;
              } else {
                for (int J = 0; J < 2; J++) {
                  H[J] = H[J + 1];
                  X[J] = X[J + 1];
                  F[J] = F[J + 1];
                }
                X[2] = X[3];
                F[2] = F[3];
                DEL1[0] = DEL1[1];
                DEL1[1] = (F[2] - F[1]) / H[1];
                DEL = (DEL1[1] - DEL1[0]) / (H[1] + H[0]);
                I++;
              }
            }
          } else {
            ISW = 1;
            hd = true;
            for (int J = 0; J < 3; J++) {
              ZR[J] = X[J];
              ZI[J] = 0.0;
              GR[J] = F[J];
              GI[J] = 0.0;
            }
            for (int J = 0; J < 2; J++) {
              CDEL1R[J] = DEL1[J];
              CDEL1I[J] = 0.0;
              CH1R[J] = H[J];
              CH1I[J] = 0.0;
            }
            CDELR = DEL;
            CDELI = 0.0;
          }
        }
        
        if (ISW == 1 && OK && !converged) {
          if (hd) {
            resultTable.clear();
            message = "El algoritmo puede dar soluciones complejas";
            hd = false;
          }
          
          if (ComplexOperations.abs(CDELR, CDELI) <= 1e-20) {
            if (ComplexOperations.abs(CDEL1R[1], CDEL1I[1]) <= 1e-20) {
              OK = false;
              message = "Error: división por cero en caso complejo";
            } else {
              var multResult = ComplexOperations.mult(CDEL1R[1], CDEL1I[1], ZR[2], ZI[2]);
              var subResult = ComplexOperations.sub(GR[2], GI[2], multResult['real']!, multResult['imag']!);
              var divResult = ComplexOperations.div(
                subResult['real']!, subResult['imag']!, 
                CDEL1R[1], CDEL1I[1]
              );
              ZR[3] = divResult['real']!;
              ZI[3] = divResult['imag']!;
              
              var subFinal = ComplexOperations.sub(ZR[3], ZI[3], ZR[2], ZI[2]);
              CH1R[2] = subFinal['real']!;
              CH1I[2] = subFinal['imag']!;
            }
          } else {
            var mult1 = ComplexOperations.mult(CH1R[1], CH1I[1], CDELR, CDELI);
            var add1 = ComplexOperations.add(CDEL1R[1], CDEL1I[1], mult1['real']!, mult1['imag']!);
            double CBR = add1['real']!;
            double CBI = add1['imag']!;
            
            var mult2 = ComplexOperations.mult(GR[2], GI[2], CDELR, CDELI);
            var mult3 = ComplexOperations.mult(mult2['real']!, mult2['imag']!, 4.0, 0.0);
            double FR = mult3['real']!;
            double FI = mult3['imag']!;
            
            var mult4 = ComplexOperations.mult(CBR, CBI, CBR, CBI);
            var sub1 = ComplexOperations.sub(mult4['real']!, mult4['imag']!, FR, FI);
            var sqrtResult = ComplexOperations.complexSqrt(sub1['real']!, sub1['imag']!);
            
            FR = sqrtResult['real']!;
            FI = sqrtResult['imag']!;
            
            var add2 = ComplexOperations.add(CBR, CBI, FR, FI);
            double CER = add2['real']!;
            double CEI = add2['imag']!;
            
            var sub2 = ComplexOperations.sub(CBR, CBI, FR, FI);
            FR = sub2['real']!;
            FI = sub2['imag']!;
            
            if (ComplexOperations.abs(FR, FI) > ComplexOperations.abs(CER, CEI)) {
              var sub3 = ComplexOperations.sub(CBR, CBI, FR, FI);
              CER = sub3['real']!;
              CEI = sub3['imag']!;
            }
            
            var div1 = ComplexOperations.div(GR[2], GI[2], CER, CEI);
            var mult5 = ComplexOperations.mult(div1['real']!, div1['imag']!, -2.0, 0.0);
            CH1R[2] = mult5['real']!;
            CH1I[2] = mult5['imag']!;
            
            var add3 = ComplexOperations.add(ZR[2], ZI[2], CH1R[2], CH1I[2]);
            ZR[3] = add3['real']!;
            ZI[3] = add3['imag']!;
          }
          
          if (OK) {
            var resultado = ComplexOperations.evaluarPolinomio(coefs, ZR[3], ZI[3]);
            GR[3] = resultado['real']!;
            GI[3] = resultado['imag']!;
            double error = ComplexOperations.abs(CH1R[2], CH1I[2]);
            
            Map<String, dynamic> iteracion = {
              "i": I,
              "x_real": _redondear(ZR[3]),
              "x_imag": _redondear(ZI[3]),
              "f_real": _redondear(GR[3]),
              "f_imag": _redondear(GI[3]),
              "error": _redondear(error)
            };
            resultTable.add(iteracion);
            
            if (error < tol) {
              success = true;
              result = _redondear(ZR[3]);
              message = "Raíz: ${ComplexOperations.toComplexString(ZR[3], ZI[3], decimales: dn)}\n"
                        "Error final: ${_redondear(error)}";
              iterations = I;
              converged = true;
            } else {
              for (int J = 0; J < 2; J++) {
                CH1R[J] = CH1R[J + 1];
                CH1I[J] = CH1I[J + 1];
                ZR[J] = ZR[J + 1];
                ZI[J] = ZI[J + 1];
                GR[J] = GR[J + 1];
                GI[J] = GI[J + 1];
              }
              ZR[2] = ZR[3];
              ZI[2] = ZI[3];
              GR[2] = GR[3];
              GI[2] = GI[3];
              CDEL1R[0] = CDEL1R[1];
              CDEL1I[0] = CDEL1I[1];
              
              var sub1 = ComplexOperations.sub(GR[2], GI[2], GR[1], GI[1]);
              var div1 = ComplexOperations.div(
                sub1['real']!, sub1['imag']!, 
                CH1R[1], CH1I[1]
              );
              CDEL1R[1] = div1['real']!;
              CDEL1I[1] = div1['imag']!;
              
              var sub2 = ComplexOperations.sub(CDEL1R[1], CDEL1I[1], CDEL1R[0], CDEL1I[0]);
              var add1 = ComplexOperations.add(CH1R[1], CH1I[1], CH1R[0], CH1I[0]);
              var div2 = ComplexOperations.div(
                sub2['real']!, sub2['imag']!,
                add1['real']!, add1['imag']!
              );
              CDELR = div2['real']!;
              CDELI = div2['imag']!;
              I++;
            }
          }
        }
      }
      
      if (!converged && OK) {
        if (ISW == 0) {
          result = _redondear(X[2]);
          message = "Mejor aproximación real: $result";
        } else {
          result = _redondear(ZR[2]);
          message = "Mejor aproximación compleja: ${ComplexOperations.toComplexString(ZR[2], ZI[2], decimales: dn)}";
        }
        iterations = n;
        success = false;
      }
    } catch (e) {
      message = "Error durante la ejecución: ${e.toString()}";
      success = false;
    }
  }
  double _redondear(double valor) {
    if (dn <= 0) return valor;
    if (valor.isNaN || valor.isInfinite) return valor;
    double factor = math.pow(10, dn).toDouble();
    return (valor * factor).roundToDouble() / factor;
  }

  String getMethodDescription() {
    return '''
Propósito: Encontrar raíces de ecuaciones, especialmente raíces complejas o múltiples.

Fundamento: Generalización del método de la secante que utiliza una aproximación parabólica en lugar de lineal. Ajusta una parábola a tres puntos y encuentra sus intersecciones con el eje x.

Elementos Requeridos:

    Tres aproximaciones iniciales x_0, x_1, x_2

    La función f(x)

Proceso Básico:

    Se construye una parábola que pasa por los tres puntos (x_i, f(x_i))

    Se calculan las raíces de esta parábola usando la fórmula cuadrática

    Se selecciona la raíz más cercana a la última aproximación

    Se actualizan los tres puntos descartando el más antiguo

Fórmula Clave: Utiliza diferencias divididas para construir la parábola y la fórmula cuadrática para encontrar la intersección.

Ventajas Principales:

    Puede encontrar raíces complejas

    Converge más rápido que la secante (orden ≈ 1.84)

    No requiere el cálculo de derivadas

    Eficaz para funciones con comportamientos no lineales

Aplicación Típica: Útil cuando otros métodos fallan o cuando se buscan raíces complejas de ecuaciones.

''';
  }
}