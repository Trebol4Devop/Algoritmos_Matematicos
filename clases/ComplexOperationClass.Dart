import 'dart:math' as math;

class ComplexOperations {
  static Map<String, double> add(double aReal, double aImag, double bReal, double bImag) {
    return {
      'real': aReal + bReal,
      'imag': aImag + bImag
    };
  }
  
  static Map<String, double> sub(double aReal, double aImag, double bReal, double bImag) {
    return {
      'real': aReal - bReal,
      'imag': aImag - bImag
    };
  }
  
  static Map<String, double> mult(double aReal, double aImag, double bReal, double bImag) {
    return {
      'real': aReal * bReal - aImag * bImag,
      'imag': aReal * bImag + aImag * bReal
    };
  }
  
  static Map<String, double> div(double aReal, double aImag, double bReal, double bImag) {
    double denominador = bReal * bReal + bImag * bImag;
    return {
      'real': (aReal * bReal + aImag * bImag) / denominador,
      'imag': (aImag * bReal - aReal * bImag) / denominador
    };
  }
  
  static double abs(double real, double imag) {
    return math.sqrt(real * real + imag * imag);
  }
  
  static Map<String, double> complexSqrt(double real, double imag) {
    double angulo = 0.0;
    double piMedios = math.pi / 2;
    double modulo, argumento;
    
    if (real.abs() <= 1e-20) {
      if (imag.abs() <= 1e-20) {
        modulo = 0.0;
        argumento = 0.0;
      } else {
        argumento = piMedios;
        if (imag < 0.0) argumento = -argumento;
        modulo = imag.abs();
      }
    } else {
      modulo = math.sqrt(real * real + imag * imag);
      if (imag.abs() < 1e-20) {
        argumento = 0.0;
        if (real < 0.0) argumento = math.pi;
      } else {
        argumento = math.atan2(imag, real);
        if (real < 0.0) argumento += math.pi;
      }
    }
    
    double raizModulo = math.sqrt(modulo);
    double mitadAngulo = argumento / 2;
    
    return {
      'real': raizModulo * math.cos(mitadAngulo),
      'imag': raizModulo * math.sin(mitadAngulo)
    };
  }
  
  static Map<String, double> evaluarPolinomio(List<double> coefs, double real, double imag) {
    double resultadoReal = coefs[0];
    double resultadoImag = 0.0;
    
    for (int i = 1; i < coefs.length; i++) {
      double tempReal = resultadoReal * real - resultadoImag * imag;
      double tempImag = resultadoReal * imag + resultadoImag * real;
      resultadoReal = tempReal + coefs[i];
      resultadoImag = tempImag;
    }
    
    return {'real': resultadoReal, 'imag': resultadoImag};
  }
  
  static String toComplexString(double real, double imag, {int decimales = 6}) {
    if (imag.abs() < 1e-10) {
      return _redondear(real, decimales).toString();
    }
    
    String signo = imag >= 0 ? '+' : '-';
    return '${_redondear(real, decimales)} $signo ${_redondear(imag.abs(), decimales)}i';
  }
  
  static double _redondear(double valor, int decimales) {
    if (decimales <= 0) return valor;
    if (valor.isNaN || valor.isInfinite) return valor;
    double factor = math.pow(10, decimales).toDouble();
    return (valor * factor).roundToDouble() / factor;
  }
}