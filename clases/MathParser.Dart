import 'dart:math';


class MathParser {
  static final MathParser _instance = MathParser._internal();
  factory MathParser() => _instance;
  MathParser._internal();

  double evaluarExpresion(String expresion, Map<String, double> variables) {
    try {
      String expr = _preprocesarExpresion(expresion, variables);
      return _evaluarTokens(_tokenizar(expr));
    } catch (e) {
      throw Exception('Error al evaluar expresión "$expresion" con variables $variables: $e');
    }
  }

  double evaluar(String expresion, String nombreVariable, dynamic valor) {
    return evaluarExpresion(expresion, {nombreVariable: valor.toDouble()});
  }

  double evaluar2Variables(String expresion, double x, double y) {
    return evaluarExpresion(expresion, {'x': x, 'y': y});
  }

  double evaluar3Variables(String expresion, double x, double y, double z) {
    return evaluarExpresion(expresion, {'x': x, 'y': y, 'z': z});
  }

  double evaluarFuncionTY(String expresion, double t, double y) {
    return evaluarExpresion(expresion, {'t': t, 'y': y});
  }

  double evaluarConVariables(String expresion, Map<String, double> variables) {
    return evaluarExpresion(expresion, variables);
  }

  bool validarExpresion(String expresion, List<String> variables) {
    try {
      Map<String, double> valoresPrueba = {};
      for (var variable in variables) {
        valoresPrueba[variable] = 1.0;
      }
      
      List<List<double>> valoresPruebaList = [
        [0.0, 0.0, 0.0],
        [1.0, 1.0, 1.0],
        [-1.0, -1.0, -1.0],
        [2.5, 3.0, 1.5],
        [-2.5, 1.0, -0.5]
      ];
      
      for (var valores in valoresPruebaList) {
        for (int i = 0; i < variables.length && i < valores.length; i++) {
          valoresPrueba[variables[i]] = valores[i];
        }
        double resultado = evaluarExpresion(expresion, valoresPrueba);
        if (resultado.isNaN || resultado.isInfinite) {
          return false;
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  bool validarExpresion2Variables(String expresion) {
    return validarExpresion(expresion, ['x', 'y']);
  }

  bool validarExpresion3Variables(String expresion) {
    return validarExpresion(expresion, ['x', 'y', 'z']);
  }

  bool validarExpresionTY(String expresion) {
    return validarExpresion(expresion, ['t', 'y']);
  }

  double parsearNotacionCientifica(String valor) {
    try {
      if (valor.contains('e') || valor.contains('E')) {
        List<String> partes = valor.toLowerCase().split('e');
        if (partes.length == 2) {
          double base = double.parse(partes[0]);
          double exponente = double.parse(partes[1]);
          return base * pow(10, exponente);
        }
      }
      return double.parse(valor);
    } catch (e) {
      throw Exception('Error al parsear notación científica: $valor');
    }
  }

  String _preprocesarExpresion(String expr, Map<String, double> variables) {
    expr = expr.toLowerCase().replaceAll(' ', '');

    expr = _reemplazarConstantes(expr);

    expr = _agregarMultiplicacionImplicita(expr);

    for (var entry in variables.entries) {
      expr = _reemplazarVariable(expr, entry.key, entry.value.toString());
    }

    expr = _normalizarSignos(expr);
    
    if (expr.startsWith('-')) {
      expr = '0' + expr;
    }

    expr = expr.replaceAll('(-', '(0-');
    expr = expr.replaceAll(',-', ',0-'); 
    
    return expr;
  }

  String _reemplazarConstantes(String expr) {
    StringBuffer result = StringBuffer();
    int i = 0;
    
    while (i < expr.length) {

      if (i <= expr.length - 2 && expr.substring(i, i + 2) == 'pi') {
        bool esInicio = i == 0 || !_esAlfanumerico(expr[i - 1]);
        bool esFin = (i + 2 >= expr.length) || !_esAlfanumerico(expr[i + 2]);
        
        if (esInicio && esFin) {
          result.write(pi.toString());
          i += 2;
          continue;
        }
      }

      if (expr[i] == 'e') {
        bool esInicio = i == 0 || !_esAlfanumerico(expr[i - 1]);
        bool esFin = (i + 1 >= expr.length) || !_esAlfanumerico(expr[i + 1]);
        
        bool esNotacionCientifica = false;
        if (i > 0 && RegExp(r'[0-9.]').hasMatch(expr[i - 1])) {
          if (i + 1 < expr.length) {
            String siguiente = expr[i + 1];
            if (siguiente == '+' || siguiente == '-' || RegExp(r'[0-9]').hasMatch(siguiente)) {
              esNotacionCientifica = true;
            }
          } else {
            esNotacionCientifica = true;
          }
        }
        
        if (esInicio && esFin && !esNotacionCientifica) {
          result.write('exp(1)');
          i++;
          continue;
        }
      }
      
      result.write(expr[i]);
      i++;
    }
    
    return result.toString();
  }

  String _reemplazarVariable(String expr, String variable, String valor) {
    StringBuffer result = StringBuffer();
    int i = 0;
    
    while (i < expr.length) {
      if (i <= expr.length - variable.length && 
          expr.substring(i, i + variable.length) == variable) {
        bool esInicio = i == 0 || !_esAlfanumerico(expr[i - 1]);
        bool esFin = (i + variable.length >= expr.length) || 
                     !_esAlfanumerico(expr[i + variable.length]);
        
        if (esInicio && esFin) {
          if (valor.startsWith('-')) {
            result.write('($valor)');
          } else {
            result.write(valor);
          }
          i += variable.length;
        } else {
          result.write(expr[i]);
          i++;
        }
      } else {
        result.write(expr[i]);
        i++;
      }
    }
    
    return result.toString();
  }

  bool _esAlfanumerico(String char) {
    return RegExp(r'[a-z0-9_]').hasMatch(char);
  }

  String _agregarMultiplicacionImplicita(String expr) {
    StringBuffer result = StringBuffer();
    
    for (int i = 0; i < expr.length; i++) {
      result.write(expr[i]);
      
      if (i < expr.length - 1) {
        String actual = expr[i];
        String siguiente = expr[i + 1];

        bool necesitaMultiplicacion = false;

        if (RegExp(r'\d').hasMatch(actual) && 
            (RegExp(r'[a-z(]').hasMatch(siguiente))) {

          bool esNotacionCientifica = false;
          if (siguiente == 'e' && i + 2 < expr.length) {
            String sigSiguiente = expr[i + 2];
            if (sigSiguiente == '+' || sigSiguiente == '-' || RegExp(r'\d').hasMatch(sigSiguiente)) {
              esNotacionCientifica = true;
            }
          }
          
          if (!esNotacionCientifica) {
            necesitaMultiplicacion = true;
          }
        }

        if (actual == ')' && RegExp(r'[0-9a-z(]').hasMatch(siguiente)) {
          necesitaMultiplicacion = true;
        }

        if (RegExp(r'[a-z]').hasMatch(actual) && siguiente == '(') {
          String palabraAnterior = _obtenerPalabraAnterior(expr, i);
          if (!_esFuncion(palabraAnterior)) {
            necesitaMultiplicacion = true;
          }
        }

        if (RegExp(r'[xyzt]').hasMatch(actual) && RegExp(r'[xyzt]').hasMatch(siguiente)) {
          necesitaMultiplicacion = true;
        }

        if (RegExp(r'\d').hasMatch(actual) && RegExp(r'[xyzt]').hasMatch(siguiente)) {
          necesitaMultiplicacion = true;
        }
        
        if (necesitaMultiplicacion) {
          result.write('*');
        }
      }
    }
    
    return result.toString();
  }

  String _obtenerPalabraAnterior(String expr, int pos) {
    StringBuffer palabra = StringBuffer();
    for (int i = pos; i >= 0 && RegExp(r'[a-z]').hasMatch(expr[i]); i--) {
      palabra.write(expr[i]);
    }
    return palabra.toString().split('').reversed.join('');
  }

  bool _esFuncion(String palabra) {
    const funciones = [
      'sin', 'cos', 'tan', 'asin', 'acos', 'atan',
      'sinh', 'cosh', 'tanh',
      'ln', 'log', 'log10', 'log2',
      'exp', 'sqrt', 'cbrt', 'abs',
      'ceil', 'floor', 'round',
      'pow', 'max', 'min'
    ];
    return funciones.contains(palabra);
  }

  String _normalizarSignos(String expr) {
    while (expr.contains('+-') || expr.contains('-+') || 
           expr.contains('--') || expr.contains('++')) {
      expr = expr.replaceAll('+-', '-');
      expr = expr.replaceAll('-+', '-');
      expr = expr.replaceAll('--', '+');
      expr = expr.replaceAll('++', '+');
    }
    return expr;
  }


  List<dynamic> _tokenizar(String expr) {
    List<dynamic> tokens = [];
    StringBuffer buffer = StringBuffer();
    
    for (int i = 0; i < expr.length; i++) {
      String char = expr[i];
      
      if (RegExp(r'[0-9.]').hasMatch(char)) {
        buffer.write(char);
      } else if ((char == 'e' || char == 'E') && buffer.isNotEmpty && _esParteDeNotacionCientifica(buffer.toString())) {
        buffer.write(char);
        if (i + 1 < expr.length && (expr[i + 1] == '+' || expr[i + 1] == '-')) {
          i++;
          buffer.write(expr[i]);
        }
        while (i + 1 < expr.length && RegExp(r'[0-9]').hasMatch(expr[i + 1])) {
          i++;
          buffer.write(expr[i]);
        }
      } else if (RegExp(r'[a-z]').hasMatch(char)) {
        if (buffer.isNotEmpty && RegExp(r'^[0-9]').hasMatch(buffer.toString())) {
          try {
            tokens.add(_parsearNumeroConNotacionCientifica(buffer.toString()));
          } catch (e) {
            throw Exception('Token inválido: ${buffer.toString()}');
          }
          buffer.clear();
        }
        buffer.write(char);
      } else {
        if (buffer.isNotEmpty) {
          String token = buffer.toString();
          if (_esFuncion(token)) {
            tokens.add(token);
          } else {
            try {
              tokens.add(_parsearNumeroConNotacionCientifica(token));
            } catch (e) {
              throw Exception('Token inválido: $token');
            }
          }
          buffer.clear();
        }

        if (char == '-' && (i == 0 || expr[i - 1] == '(' || _esOperador(expr[i - 1]))) {
          tokens.add(char);
        } else if (char == '+' && (i == 0 || expr[i - 1] == '(' || _esOperador(expr[i - 1]))) {
          continue;
        } else if (char != ' ') {
          tokens.add(char);
        }
      }
    }
    
    if (buffer.isNotEmpty) {
      String token = buffer.toString();
      if (_esFuncion(token)) {
        tokens.add(token);
      } else {
        try {
          tokens.add(_parsearNumeroConNotacionCientifica(token));
        } catch (e) {
          throw Exception('Token inválido al final: $token');
        }
      }
    }
    
    return tokens;
  }

  double _parsearNumeroConNotacionCientifica(String token) {
    if (token.contains('e') || token.contains('E')) {
      return parsearNotacionCientifica(token);
    }
    return double.parse(token);
  }

  bool _esParteDeNotacionCientifica(String buffer) {
    if (buffer.isEmpty) return false;
    
    try {
      if (buffer.contains('e') || buffer.contains('E')) {
        parsearNotacionCientifica(buffer);
        return true;
      } else {
        double.parse(buffer);
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  bool _esOperador(String char) {
    return ['+', '-', '*', '/', '^'].contains(char);
  }

  double _evaluarTokens(List<dynamic> tokens) {
    List<double> valores = [];
    List<String> operadores = [];
    
    for (var token in tokens) {
      if (token is double) {
        valores.add(token);
      } else if (token is String) {
        if (_esFuncion(token)) {
          operadores.add(token);
        } else if (token == '(') {
          operadores.add(token);
        } else if (token == ')') {
          while (operadores.isNotEmpty && operadores.last != '(') {
            _aplicarOperador(valores, operadores.removeLast());
          }
          if (operadores.isEmpty) {
            throw Exception('Paréntesis desbalanceados');
          }
          operadores.removeLast();
          
          if (operadores.isNotEmpty && _esFuncion(operadores.last)) {
            _aplicarOperador(valores, operadores.removeLast());
          }
        } else if (_esOperador(token)) {
          while (operadores.isNotEmpty && 
                 operadores.last != '(' &&
                 _precedencia(operadores.last) >= _precedencia(token)) {
            _aplicarOperador(valores, operadores.removeLast());
          }
          operadores.add(token);
        }
      }
    }
    
    while (operadores.isNotEmpty) {
      String op = operadores.removeLast();
      if (op == '(' || op == ')') {
        throw Exception('Paréntesis desbalanceados');
      }
      _aplicarOperador(valores, op);
    }
    
    if (valores.length != 1) {
      throw Exception('Expresión inválida: quedaron ${valores.length} valores');
    }
    
    return valores[0];
  }

  int _precedencia(String op) {
    switch (op) {
      case '+':
      case '-':
        return 1;
      case '*':
      case '/':
        return 2;
      case '^':
        return 3;
      default:
        if (_esFuncion(op)) return 4;
        return 0;
    }
  }

  void _aplicarOperador(List<double> valores, String operador) {
    if (_esFuncion(operador)) {
      if (operador == 'pow' || operador == 'max' || operador == 'min') {
        if (valores.length < 2) {
          throw Exception('Argumentos insuficientes para $operador');
        }
        double arg2 = valores.removeLast();
        double arg1 = valores.removeLast();
        valores.add(_aplicarFuncion2Args(operador, arg1, arg2));
      } else {
        if (valores.isEmpty) {
          throw Exception('Argumentos insuficientes para $operador');
        }
        double arg = valores.removeLast();
        valores.add(_aplicarFuncion1Arg(operador, arg));
      }
    } else {
      if (valores.length < 2) {
        throw Exception('Argumentos insuficientes para operador $operador');
      }
      double b = valores.removeLast();
      double a = valores.removeLast();
      valores.add(_calcularOperacion(a, operador, b));
    }
  }

  double _calcularOperacion(double a, String operador, double b) {
    switch (operador) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case '*':
        return a * b;
      case '/':
        if (b == 0) throw Exception('División por cero');
        return a / b;
      case '^':
        return pow(a, b).toDouble();
      default:
        throw Exception('Operador desconocido: $operador');
    }
  }

  double _aplicarFuncion1Arg(String funcion, double arg) {
    switch (funcion) {
      case 'sin':
        return sin(arg);
      case 'cos':
        return cos(arg);
      case 'tan':
        return tan(arg);
      case 'asin':
        return asin(arg);
      case 'acos':
        return acos(arg);
      case 'atan':
        return atan(arg);
      
      case 'sinh':
        return (exp(arg) - exp(-arg)) / 2;
      case 'cosh':
        return (exp(arg) + exp(-arg)) / 2;
      case 'tanh':
        double ex = exp(arg);
        double emx = exp(-arg);
        return (ex - emx) / (ex + emx);
      
      case 'ln':
      case 'log':
        if (arg <= 0) throw Exception('Logaritmo de número no positivo');
        return log(arg);
      case 'log10':
        if (arg <= 0) throw Exception('Logaritmo de número no positivo');
        return log(arg) / ln10;
      case 'log2':
        if (arg <= 0) throw Exception('Logaritmo de número no positivo');
        return log(arg) / ln2;
      
      case 'exp':
        return exp(arg);
      case 'sqrt':
        if (arg < 0) throw Exception('Raíz cuadrada de número negativo');
        return sqrt(arg);
      case 'cbrt':
        return pow(arg, 1/3).toDouble();
      
      case 'abs':
        return arg.abs();
      case 'ceil':
        return arg.ceilToDouble();
      case 'floor':
        return arg.floorToDouble();
      case 'round':
        return arg.roundToDouble();
      
      default:
        throw Exception('Función desconocida: $funcion');
    }
  }

  double _aplicarFuncion2Args(String funcion, double arg1, double arg2) {
    switch (funcion) {
      case 'pow':
        return pow(arg1, arg2).toDouble();
      case 'max':
        return max(arg1, arg2);
      case 'min':
        return min(arg1, arg2);
      default:
        throw Exception('Función de dos argumentos desconocida: $funcion');
    }
  }

  double derivadaParcialNumerica(String expresion, String variable, Map<String, double> punto, {double h = 0.0000001}) {
    Map<String, double> punto1 = Map.from(punto);
    Map<String, double> punto2 = Map.from(punto);
    
    punto1[variable] = punto[variable]! + h;
    punto2[variable] = punto[variable]! - h;
    
    double f1 = evaluarExpresion(expresion, punto1);
    double f2 = evaluarExpresion(expresion, punto2);
    
    return (f1 - f2) / (2 * h);
  }

  Map<String, double> gradienteNumerico(String expresion, Map<String, double> punto, {double h = 0.0000001}) {
    Map<String, double> gradiente = {};
    
    for (String variable in punto.keys) {
      gradiente[variable] = derivadaParcialNumerica(expresion, variable, punto, h: h);
    }
    
    return gradiente;
  }

  List<List<double>> jacobianoNumerico(List<String> funciones, Map<String, double> punto, {double h = 0.0000001}) {
    List<List<double>> jacobiano = [];
    
    for (String funcion in funciones) {
      List<double> fila = [];
      for (String variable in punto.keys) {
        fila.add(derivadaParcialNumerica(funcion, variable, punto, h: h));
      }
      jacobiano.add(fila);
    }
    
    return jacobiano;
  }

  Set<String> encontrarVariables(String expresion) {
    Set<String> variables = {};
    String expr = expresion.toLowerCase().replaceAll(' ', '');
    
    List<String> varsPosibles = ['x', 'y', 'z', 't'];
    
    for (String variable in varsPosibles) {
      if (expr.contains(variable)) {
        RegExp regex = RegExp('(^|[^a-z])$variable([^a-z]|\$)');
        if (regex.hasMatch(expr)) {
          variables.add(variable);
        }
      }
    }
    
    return variables;
  }

  String simplificarExpresion(String expresion) {
    String expr = expresion.toLowerCase().replaceAll(' ', '');
    
    // Simplificaciones básicas
    expr = expr.replaceAll('--', '');
    expr = expr.replaceAll('+-', '-');
    expr = expr.replaceAll('-+', '-');
    expr = expr.replaceAll('++', '+');
    
    expr = expr.replaceAll('*1)', ')');
    expr = expr.replaceAll('*1,', ',');
    expr = expr.replaceAll(r'*1$', '');
    
    expr = expr.replaceAll('*0)', '*0)'); 
    
    return expr;
  }

  String expandirExpresion(String expresion) {
    String expr = expresion;
    
    RegExp patron = RegExp(r'([0-9a-z]+)\*\(([^()]+)\)');
    Match? match = patron.firstMatch(expr);
    
    if (match != null) {
      String factor = match.group(1)!;
      String contenido = match.group(2)!;
      List<String> terminos = contenido.split('+');
      String expansion = terminos.map((t) => '$factor*$t').join('+');
      expr = expr.replaceFirst(patron, expansion);
    }
    
    return expr;
  }

  double evaluarFuncionEuler(String funcion, double t, double y) {
    return evaluarFuncionTY(funcion, t, y);
  }

  bool validarFuncionEuler(String funcion) {
    return validarExpresionTY(funcion);
  }

  double evaluarFuncionTU1U2(String expresion, double t, double u1, double u2) {
    return evaluarExpresion(expresion, {'t': t, 'u1': u1, 'u2': u2});
  }

  bool validarExpresionTU1U2(String expresion) {
    return validarExpresion(expresion, ['t', 'u1', 'u2']);
  }

  Set<String> encontrarVariablesSistema(String expresion) {
    Set<String> variables = {};
    String expr = expresion.toLowerCase().replaceAll(' ', '');
    
    List<String> varsPosibles = ['t', 'u1', 'u2'];
    
    for (String variable in varsPosibles) {
      if (expr.contains(variable)) {
        RegExp regex = RegExp('(^|[^a-z])$variable([^a-z]|\$)');
        if (regex.hasMatch(expr)) {
          variables.add(variable);
        }
      }
    }
    
    return variables;
  }

  double evaluarFuncionTU1U2U3(String expresion, double t, double u1, double u2, double u3) {
    return evaluarExpresion(expresion, {'t': t, 'u1': u1, 'u2': u2, 'u3': u3});
  }

  bool validarExpresionTU1U2U3(String expresion) {
    return validarExpresion(expresion, ['t', 'u1', 'u2', 'u3']);
  }

  Set<String> encontrarVariablesSistema3(String expresion) {
    Set<String> variables = {};
    String expr = expresion.toLowerCase().replaceAll(' ', '');
    
    List<String> varsPosibles = ['t', 'u1', 'u2', 'u3'];
    
    for (String variable in varsPosibles) {
      if (expr.contains(variable)) {
        RegExp regex = RegExp('(^|[^a-z])$variable([^a-z]|\$)');
        if (regex.hasMatch(expr)) {
          variables.add(variable);
        }
      }
    }
    
    return variables;
  }

  double evaluarFuncionXYZ(String expresion, double x, double y, double z) {
    return evaluarExpresion(expresion, {'x': x, 'y': y, 'z': z});
  }

  bool validarExpresionXYZ(String expresion) {
    return validarExpresion(expresion, ['x', 'y', 'z']);
  }

  Set<String> encontrarVariablesXYZ(String expresion) {
    Set<String> variables = {};
    String expr = expresion.toLowerCase().replaceAll(' ', '');
    
    List<String> varsPosibles = ['x', 'y', 'z'];
    
    for (String variable in varsPosibles) {
      if (expr.contains(variable)) {
        RegExp regex = RegExp('(^|[^a-z])$variable([^a-z]|\$)');
        if (regex.hasMatch(expr)) {
          variables.add(variable);
        }
      }
    }
    
    return variables;
  }

}