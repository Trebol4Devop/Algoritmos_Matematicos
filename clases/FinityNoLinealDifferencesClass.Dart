import 'dart:math';
import 'MathParser.Dart';
import 'MethodClass.Dart';
import 'MethodUtils.Dart';

/// Implementación del método de diferencias finitas para ecuaciones diferenciales no lineales
class FinityNoLinealDifferencesClass extends MethodClass {
  String function;
  String df1dy;
  String df2dy;
  int n;
  int m;
  double alpha;
  double beta;
  double lowerLimit;
  double upperLimit;
  int dn;
  double tol;
  List<List<dynamic>> resultTable;
  
  FinityNoLinealDifferencesClass({
    this.function = "",
    this.df1dy = "",
    this.df2dy = "",
    this.n = 0,
    this.m = 0,
    this.alpha = 0.0,
    this.beta = 0.0,
    this.lowerLimit = 0.0,
    this.upperLimit = 0.0,
    this.dn = 6,
    this.tol = 1e-6,
    List<List<dynamic>>? resultTable,
    int id = 1,
    String title = "Método de Diferencias Finitas No Lineales",
    String subtitle = "Resuelve EDOs no lineales con condiciones de frontera usando Newton",
    String index = "FINITE_DIFF_NL",
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

  void finityNoLinealDifferencesMethod() {
    initialize();
    resultTable.clear();

    try {
      if (function.isEmpty || df1dy.isEmpty || df2dy.isEmpty) {
        message = "Error: debe proporcionar la función y sus derivadas parciales";
        return;
      }

      if (lowerLimit >= upperLimit) {
        message = "Error: el límite inferior debe ser menor que el superior";
        return;
      }

      if (n <= 0) {
        message = "Error: el número de particiones debe ser mayor que 0";
        return;
      }

      if (m <= 0) {
        message = "Error: el número máximo de iteraciones debe ser mayor que 0";
        return;
      }

      if (tol <= 0) {
        message = "Error: la tolerancia debe ser mayor que 0";
        return;
      }

      List<double> puntosPrueba = [lowerLimit, alpha, (alpha+beta)/2, upperLimit, beta, (beta-alpha)/(upperLimit-lowerLimit)];
      if (!MethodUtils.validarFuncionXYZ(function, puntosPrueba) ||
          !MethodUtils.validarFuncionXYZ(df1dy, puntosPrueba) ||
          !MethodUtils.validarFuncionXYZ(df2dy, puntosPrueba)) {
        message = "Error: alguna función produce valores no válidos en el dominio";
        return;
      }

      double h = (upperLimit - lowerLimit) / (n + 1);

      List<double> w = List.filled(n, 0.0);
      List<double> v = List.filled(n, 0.0);
      List<double> a = List.filled(n, 0.0);
      List<double> b = List.filled(n, 0.0);
      List<double> c = List.filled(n, 0.0);
      List<double> d = List.filled(n, 0.0);
      List<double> l = List.filled(n, 0.0);
      List<double> u = List.filled(n, 0.0);
      List<double> z = List.filled(n, 0.0);

      for (int i = 0; i < n; i++) {
        double x = lowerLimit + (i + 1) * h;
        w[i] = alpha + (x - lowerLimit) * (beta - alpha) / (upperLimit - lowerLimit);
      }

      bool ok = true;
      int k = 1;

      while (k <= m && ok) {
        // Punto x1
        double x = lowerLimit + h;
        double t = (w[0] - alpha) / (2 * h);
        a[0] = 2.0 + h * h * _evaluarFuncionXYZ(df1dy, x, w[0], t);
        b[0] = -1.0 + (h / 2) * _evaluarFuncionXYZ(df2dy, x, w[0], t);
        d[0] = -(2.0 * w[0] - w[1] - alpha + h * h * _evaluarFuncionXYZ(function, x, w[0], t));

        for (int j = 2; j <= n - 1; j++) {
          x = lowerLimit + j * h;
          t = (w[j - 1] - w[j - 3]) / (2 * h);
          a[j - 1] = 2.0 + h * h * _evaluarFuncionXYZ(df1dy, x, w[j - 1], t);
          b[j - 1] = -1.0 + (h / 2) * _evaluarFuncionXYZ(df2dy, x, w[j - 1], t);
          c[j - 1] = -1.0 - (h / 2) * _evaluarFuncionXYZ(df2dy, x, w[j - 1], t);
          d[j - 1] = -(2.0 * w[j - 1] - w[j] - w[j - 2] + h * h * _evaluarFuncionXYZ(function, x, w[j - 1], t));
        }

        x = upperLimit - h;
        t = (beta - w[n - 2]) / (2 * h);
        a[n - 1] = 2.0 + h * h * _evaluarFuncionXYZ(df1dy, x, w[n - 1], t);
        c[n - 1] = -1.0 - (h / 2) * _evaluarFuncionXYZ(df2dy, x, w[n - 1], t);
        d[n - 1] = -(2.0 * w[n - 1] - w[n - 2] - beta + h * h * _evaluarFuncionXYZ(function, x, w[n - 1], t));

        l[0] = a[0];
        u[0] = b[0] / a[0];
        z[0] = d[0] / l[0];

        for (int i = 2; i <= n - 1; i++) {
          l[i - 1] = a[i - 1] - c[i - 1] * u[i - 2];
          u[i - 1] = b[i - 1] / l[i - 1];
          z[i - 1] = (d[i - 1] - c[i - 1] * z[i - 2]) / l[i - 1];
        }

        l[n - 1] = a[n - 1] - c[n - 1] * u[n - 2];
        z[n - 1] = (d[n - 1] - c[n - 1] * z[n - 2]) / l[n - 1];

        v[n - 1] = z[n - 1];
        double vmax = v[n - 1].abs();
        w[n - 1] += v[n - 1];

        for (int j = 1; j <= n - 1; j++) {
          int index = n - j - 1;
          v[index] = z[index] - u[index] * v[index + 1];
          w[index] += v[index];
          if (v[index].abs() > vmax) {
            vmax = v[index].abs();
          }
        }

        if (vmax <= tol) {
          resultTable.add([
            "0",
            MethodUtils.redondear(lowerLimit, dn),
            MethodUtils.redondear(alpha, dn)
          ]);

          for (int i = 1; i <= n; i++) {
            x = lowerLimit + i * h;
            resultTable.add([
              i.toString(),
              MethodUtils.redondear(x, dn),
              MethodUtils.redondear(w[i - 1], dn)
            ]);
          }

          resultTable.add([
            (n + 1).toString(),
            MethodUtils.redondear(upperLimit, dn),
            MethodUtils.redondear(beta, dn)
          ]);

          success = true;
          iterations = k;
          result = MethodUtils.redondear(w[n ~/ 2], dn);
          message = "Solución completada exitosamente en $k iteraciones\n"
                    "Paso h = ${MethodUtils.redondear(h, dn)}\n"
                    "Error máximo: ${MethodUtils.redondear(vmax, dn)}";
          ok = false;
        } else {
          k++;
        }
      }

      if (k > m) {
        message = "No hubo convergencia en $m iteraciones\n"
                  "Último error máximo: ${_calcularErrorMaximo(v)}";
        success = false;
      }

    } catch (e) {
      message = "Error durante la ejecución: ${e.toString()}";
      success = false;
    }
  }

  double _evaluarFuncionXYZ(String funcion, double x, double y, double z) {
    return MethodUtils.evaluarFuncionXYZ(funcion, x, y, z);
  }

  double _calcularErrorMaximo(List<double> vector) {
    double maxError = 0.0;
    for (double valor in vector) {
      if (valor.abs() > maxError) {
        maxError = valor.abs();
      }
    }
    return maxError;
  }

  Map<String, dynamic> analizarEcuacion() {
    Map<String, dynamic> analisis = {};
    
    try {
      double h = (upperLimit - lowerLimit) / (n + 1);
      
      analisis['paso_h'] = MethodUtils.redondear(h, dn);
      analisis['rango_x'] = '[${MethodUtils.redondear(lowerLimit, dn)}, ${MethodUtils.redondear(upperLimit, dn)}]';
      analisis['puntos_interiores'] = n;
      analisis['condiciones_frontera'] = 'y($lowerLimit) = $alpha, y($upperLimit) = $beta';
      analisis['tolerancia'] = tol;
      analisis['max_iteraciones'] = m;

      double x_medio = (lowerLimit + upperLimit) / 2;
      double y_medio = (alpha + beta) / 2;
      double z_medio = (beta - alpha) / (upperLimit - lowerLimit);
      
      analisis['f(x_medio, y_medio, z_medio)'] = MethodUtils.redondear(_evaluarFuncionXYZ(function, x_medio, y_medio, z_medio), dn);
      analisis['df/dy(x_medio, y_medio, z_medio)'] = MethodUtils.redondear(_evaluarFuncionXYZ(df1dy, x_medio, y_medio, z_medio), dn);
      analisis['df/dz(x_medio, y_medio, z_medio)'] = MethodUtils.redondear(_evaluarFuncionXYZ(df2dy, x_medio, y_medio, z_medio), dn);

      analisis['metodo'] = 'Newton para sistemas no lineales';
      analisis['sistema'] = '${n}x$n (tridiagonal)';
      analisis['ecuacion'] = 'y\'\' = f(x, y, y\')';

      MathParser parser = MathParser();
      Set<String> varsF = parser.encontrarVariablesXYZ(function);
      Set<String> varsFy = parser.encontrarVariablesXYZ(df1dy);
      Set<String> varsFz = parser.encontrarVariablesXYZ(df2dy);
      
      analisis['variables_f'] = varsF.toList();
      analisis['variables_df/dy'] = varsFy.toList();
      analisis['variables_df/dz'] = varsFz.toList();
      
    } catch (e) {
      analisis['error'] = e.toString();
    }
    
    return analisis;
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json.addAll({
      'function': function,
      'df1dy': df1dy,
      'df2dy': df2dy,
      'n': n,
      'm': m,
      'alpha': alpha,
      'beta': beta,
      'lowerLimit': lowerLimit,
      'upperLimit': upperLimit,
      'dn': dn,
      'tol': tol,
      'resultTable': resultTable,
    });
    return json;
  }

  @override
  String getResultSummary() {
    if (resultTable.isEmpty) return super.getResultSummary();
    
    return '${super.getResultSummary()}\n'
           'Ecuación: y\'\' = f(x, y, y\')\n'
           'f(x,y,z) = $function\n'
           'df/dy = $df1dy\n'
           'df/dz = $df2dy\n'
           'Condiciones: y($lowerLimit) = $alpha, y($upperLimit) = $beta\n'
           'Particiones: $n puntos interiores\n'
           'Iteraciones de Newton: $iterations';
  }

  List<Map<String, double>> obtenerPuntosGrafica() {
    List<Map<String, double>> puntos = [];
    
    for (List<dynamic> fila in resultTable) {
      double x = (fila[1] as double);
      double y = (fila[2] as double);
      
      puntos.add({'x': x, 'y': y});
    }
    
    return puntos;
  }

  List<Map<String, double>> obtenerHistoriaConvergencia() {
    List<Map<String, double>> historia = [];
    
    if (resultTable.length >= 3) {
      for (int i = 1; i < resultTable.length - 1; i++) {
        double x = (resultTable[i][1] as double);
        double y = (resultTable[i][2] as double);
        
        double error = 0.0;
        if (i > 1 && i < resultTable.length - 2) {
          double y_prev = (resultTable[i-1][2] as double);
          double y_next = (resultTable[i+1][2] as double);
          error = (y_next - 2*y + y_prev).abs();
        }
        
        historia.add({
          'x': MethodUtils.redondear(x, dn),
          'y': MethodUtils.redondear(y, dn),
          'error_estimado': MethodUtils.redondear(error, dn)
        });
      }
    }
    
    return historia;
  }

  String getMethodDescription() {
    return '''
Propósito: Resolver problemas de valor en la frontera para ecuaciones diferenciales no lineales mediante discretización del dominio y aproximación de derivadas.

Fundamento: Sustituye las derivadas por operadores en diferencias finitas, transformando la ecuación diferencial no lineal en un sistema de ecuaciones algebraicas no lineales.

Características:

  Discretiza el dominio en una malla de puntos.

  Genera un sistema de ecuaciones no lineales (no matricial directo).

  Requiere métodos iterativos para su resolución.

  Las aproximaciones pueden usar diferencias centradas de alto orden.

Ventajas:

  Aplicable a problemas fuertemente no lineales.

  Mayor precisión que métodos de disparo en algunos casos.

  Estabilidad numérica controlable mediante refinamiento de malla.

  Estructura esparcida en el sistema Jacobiano para eficiencia computacional.
''';
  }
}