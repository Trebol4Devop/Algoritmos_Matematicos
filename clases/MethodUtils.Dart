import 'dart:math';
import 'MathParser.Dart';

class MethodUtils {
  static final MathParser _parser = MathParser();

  static double evaluarFuncion(String funcion, String variable, double valor) {
    return _parser.evaluar(funcion, variable, valor);
  }

  static double redondear(double valor, int decimales) {
    if (decimales <= 0) return valor;
    if (valor.isNaN || valor.isInfinite) return valor;
    
    double factor = pow(10, decimales).toDouble();
    return (valor * factor).roundToDouble() / factor;
  }

  static bool validarFuncion(String funcion, String variable, List<double> puntosPrueba) {
    try {
      for (double val in puntosPrueba) {
        double resultado = evaluarFuncion(funcion, variable, val);
        if (resultado.isNaN || resultado.isInfinite) {
          return false;
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  static bool validarFuncionEnPunto(String funcion, String variable, double punto) {
    try {
      double resultado = evaluarFuncion(funcion, variable, punto);
      return !resultado.isNaN && !resultado.isInfinite;
    } catch (e) {
      return false;
    }
  }

  static List<Map<String, double>> obtenerPuntosFuncion(
    String funcion, 
    String variable, 
    double inicio, 
    double fin, 
    {int numPuntos = 100}
  ) {
    List<Map<String, double>> puntos = [];
    double paso = (fin - inicio) / numPuntos;
    
    for (int i = 0; i <= numPuntos; i++) {
      double x = inicio + i * paso;
      try {
        double y = evaluarFuncion(funcion, variable, x);
        if (!y.isNaN && !y.isInfinite) {
          puntos.add({'x': x, 'y': y});
        }
      } catch (e) {
      }
    }
    
    return puntos;
  }

  static List<Map<String, double>> obtenerPuntosIdentidad(
    double inicio, 
    double fin, 
    {int numPuntos = 100}
  ) {
    List<Map<String, double>> puntos = [];
    double paso = (fin - inicio) / numPuntos;
    
    for (int i = 0; i <= numPuntos; i++) {
      double x = inicio + i * paso;
      puntos.add({'x': x, 'y': x});
    }
    
    return puntos;
  }

  static double calcularDerivadaNumerica(
    String funcion, 
    String variable, 
    double x, 
    {double h = 0.0001}
  ) {
    double fxh = evaluarFuncion(funcion, variable, x + h);
    double fxmh = evaluarFuncion(funcion, variable, x - h);
    return (fxh - fxmh) / (2 * h);
  }

  static double calcularSegundaDerivadaNumerica(
    String funcion, 
    String variable, 
    double x, 
    {double h = 0.000000000000001}
  ) {
    double fx = evaluarFuncion(funcion, variable, x);
    double fxh = evaluarFuncion(funcion, variable, x + h);
    double fxmh = evaluarFuncion(funcion, variable, x - h);
    return (fxh - 2 * fx + fxmh) / (h * h);
  }

  static bool verificarBolzano(String funcion, String variable, double a, double b) {
    try {
      double fa = evaluarFuncion(funcion, variable, a);
      double fb = evaluarFuncion(funcion, variable, b);
      return fa * fb < 0;
    } catch (e) {
      return false;
    }
  }

  static Map<String, dynamic> analizarConvergenciaBasica(
    String funcion, 
    String variable, 
    double puntoInicial, 
    double tolerancia
  ) {
    Map<String, dynamic> analisis = {};
    
    try {
      double f0 = evaluarFuncion(funcion, variable, puntoInicial);
      
      analisis['f(punto_inicial)'] = redondear(f0, 6);
      analisis['punto_inicial'] = redondear(puntoInicial, 6);
      
      if (f0.abs() < tolerancia) {
        analisis['converge'] = true;
        analisis['motivo'] = "Punto inicial ya es solución";
      } else {
        analisis['converge'] = true;
        analisis['motivo'] = "Condiciones aparentemente favorables";
      }
      
      try {
        double derivada = calcularDerivadaNumerica(funcion, variable, puntoInicial);
        analisis['f\'(punto_inicial)'] = redondear(derivada, 6);
        analisis['|f\'(punto_inicial)|'] = redondear(derivada.abs(), 6);
        
        if (derivada.abs() < 1) {
          analisis['tipo_convergencia'] = "Convergencia rápida esperada";
        } else {
          analisis['tipo_convergencia'] = "Convergencia lineal esperada";
        }
      } catch (e) {
        analisis['f\'(punto_inicial)'] = 'No calculable';
        analisis['tipo_convergencia'] = 'No se pudo determinar';
      }
      
    } catch (e) {
      analisis['error'] = e.toString();
    }
    
    return analisis;
  }

  static String? validarParametros(
    String funcion,
    double tolerancia,
    int iteracionesMaximas,
    List<double> puntosIniciales,
    String variable
  ) {
    if (funcion.isEmpty) {
      return "Error: debe proporcionar una función";
    }

    if (tolerancia <= 0) {
      return "Error: la tolerancia debe ser mayor que 0";
    }

    if (iteracionesMaximas <= 0) {
      return "Error: el número máximo de iteraciones debe ser mayor que 0";
    }

    for (double punto in puntosIniciales) {
      if (!validarFuncionEnPunto(funcion, variable, punto)) {
        return "Error: la función produce valores no válidos en el punto $punto";
      }
    }

    return null; 
  }

  static String formatoComplejo(double real, double imag, {int decimales = 6}) {
    if (imag.abs() < 1e-10) {
      return redondear(real, decimales).toString();
    }
    
    String signo = imag >= 0 ? '+' : '-';
    return '${redondear(real, decimales)} $signo ${redondear(imag.abs(), decimales)}i';
  }

static double evaluarFuncion3Variables(String funcion, double var1, double var2, double var3) {
  return _parser.evaluarExpresion(funcion, {'t': var1, 'u1': var2, 'u2': var3});
}

static bool validarFuncion3Variables(String funcion, List<double> puntosPrueba) {
  try {
    for (int i = 0; i < puntosPrueba.length - 2; i += 3) {
      double t = puntosPrueba[i];
      double u1 = puntosPrueba[i + 1];
      double u2 = puntosPrueba[i + 2];
      double resultado = evaluarFuncion3Variables(funcion, t, u1, u2);
      if (resultado.isNaN || resultado.isInfinite) {
        return false;
      }
    }
    return true;
  } catch (e) {
    return false;
  }
}

  static String? validarParametrosSistema(
    List<String> funciones,
    double tolerancia,
    int iteracionesMaximas,
    List<double> puntosIniciales,
  ) {
    if (funciones.any((f) => f.isEmpty)) {
      return "Error: todas las funciones deben ser proporcionadas";
    }

    if (tolerancia <= 0) {
      return "Error: la tolerancia debe ser mayor que 0";
    }

    if (iteracionesMaximas <= 0) {
      return "Error: el número máximo de iteraciones debe ser mayor que 0";
    }

    for (String funcion in funciones) {
      if (!validarFuncion3Variables(funcion, puntosIniciales)) {
        return "Error: la función '$funcion' produce valores no válidos";
      }
    }

    return null;
  }


static double evaluarFuncion4Variables(String funcion, double var1, double var2, double var3, double var4) {
  return _parser.evaluarExpresion(funcion, {'t': var1, 'u1': var2, 'u2': var3, 'u3': var4});
}

static bool validarFuncion4Variables(String funcion, List<double> puntosPrueba) {
  try {
    for (int i = 0; i < puntosPrueba.length - 3; i += 4) {
      double t = puntosPrueba[i];
      double u1 = puntosPrueba[i + 1];
      double u2 = puntosPrueba[i + 2];
      double u3 = puntosPrueba[i + 3];
      double resultado = evaluarFuncion4Variables(funcion, t, u1, u2, u3);
      if (resultado.isNaN || resultado.isInfinite) {
        return false;
      }
    }
    return true;
  } catch (e) {
    return false;
  }
}

  static String? validarParametrosSistema3(
    List<String> funciones,
    double tolerancia,
    int iteracionesMaximas,
    List<double> puntosIniciales,
  ) {
    if (funciones.any((f) => f.isEmpty)) {
      return "Error: todas las funciones deben ser proporcionadas";
    }

    if (tolerancia <= 0) {
      return "Error: la tolerancia debe ser mayor que 0";
    }

    if (iteracionesMaximas <= 0) {
      return "Error: el número máximo de iteraciones debe ser mayor que 0";
    }

    for (String funcion in funciones) {
      if (!validarFuncion4Variables(funcion, puntosIniciales)) {
        return "Error: la función '$funcion' produce valores no válidos";
      }
    }

    return null;
  }

  static double evaluarExpresion(String expresion, Map<String, double> variables) {
    return _parser.evaluarExpresion(expresion, variables);
  }

  static bool validarExpresion(String expresion, List<String> variables) {
    try {
      Map<String, double> valoresPrueba = {};
      for (String variable in variables) {
        valoresPrueba[variable] = 1.0;
      }
      
      double resultado = _parser.evaluarExpresion(expresion, valoresPrueba);
      return !resultado.isNaN && !resultado.isInfinite;
    } catch (e) {
      return false;
    }
  }

  static double evaluarFuncionX(String expresion, double x) {
    return evaluarExpresion(expresion, {'x': x});
  }

  static bool validarFuncionX(String expresion, List<double> puntosPrueba) {
    try {
      for (double x in puntosPrueba) {
        double resultado = evaluarFuncionX(expresion, x);
        if (resultado.isNaN || resultado.isInfinite) {
          return false;
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }
  
static double evaluarFuncionXYZ(String funcion, double x, double y, double z) {
  return _parser.evaluarFuncionXYZ(funcion, x, y, z);
}

static bool validarFuncionXYZ(String funcion, List<double> puntosPrueba) {
  try {
    for (int i = 0; i < puntosPrueba.length - 2; i += 3) {
      double x = puntosPrueba[i];
      double y = puntosPrueba[i + 1];
      double z = puntosPrueba[i + 2];
      double resultado = evaluarFuncionXYZ(funcion, x, y, z);
      if (resultado.isNaN || resultado.isInfinite) {
        return false;
      }
    }
    return true;
  } catch (e) {
    return false;
  }
}

  static String? validarParametrosNoLineales(
    List<String> funciones,
    double tolerancia,
    int iteracionesMaximas,
    List<double> puntosIniciales,
  ) {
    if (funciones.any((f) => f.isEmpty)) {
      return "Error: todas las funciones deben ser proporcionadas";
    }

    if (tolerancia <= 0) {
      return "Error: la tolerancia debe ser mayor que 0";
    }

    if (iteracionesMaximas <= 0) {
      return "Error: el número máximo de iteraciones debe ser mayor que 0";
    }

    for (String funcion in funciones) {
      if (!validarFuncionXYZ(funcion, puntosIniciales)) {
        return "Error: la función '$funcion' produce valores no válidos";
      }
    }

    return null;
  }

}
