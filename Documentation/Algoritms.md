# Métodos numéricos SAMNU

## Índice

### Métodos para Ecuaciones No Lineales

- [Método de Bisección](#método-de-bisección)
- [Método de Punto Fijo](#método-de-punto-fijo)
- [Método de Newton-Raphson](#método-de-newton-raphson)
- [Método de la Secante](#método-de-la-secante)
- [Método de la Posición Falsa](#método-de-la-posición-falsa)
- [Método de Steffensen](#método-de-steffensen)
- [Método de Müller](#método-de-müller)

### Métodos de Interpolación

- [Polinomios de Lagrange](#método-de-polinomios-de-lagrange)
- [Método de Neville](#método-de-neville)
- [Diferencias Divididas de Newton](#método-de-diferencias-divididas-de-newton)

### Métodos para Sistemas Lineales

- [Método de Jacobi](#método-de-jacobi)
- [Método de Gauss-Seidel](#método-de-gauss-seidel)

### Métodos para Sistemas No Lineales

- [Punto Fijo para 2 Variables](#método-punto-fijo-para-2-variables)
- [Punto Fijo para 3 Variables](#método-de-punto-fijo-3-variables)
- [Newton para 2 Variables](#método-de-newton-para-2-variables)
- [Newton para 3 Variables](#método-de-newton-para-3-variables)

### Métodos de Derivación Numérica

- [Método de Derivación Numérica](#método-de-derivación-numérica)

### Métodos de Integración Numérica

- [Método de Romberg](#método-de-romberg)
- [Método de la Cuadratura de Gauss](#método-de-la-cuadratura-de-gauss)
- [Método de Integración por Interpolación](#método-de-integración-por-interpolación)

### Métodos para Ecuaciones Diferenciales Ordinarias

- [Método de Euler](#método-de-euler)
- [Método de Runge-Kutta de Cuarto Orden](#método-de-runge-kutta-de-cuarto-orden)
- [Método de Adams-Bashforth-Moulton de Cuarto Orden](#método-de-adams-bashforth-moulton-de-cuarto-orden)
- [Método de Runge-Kutta para Dos Variables](#método-de-runge-kutta-para-dos-variables)
- [Método de Runge-Kutta para Tres Variables](#método-de-runge-kutta-para-tres-variables)

### Métodos para Ecuaciones Diferenciales en Derivadas Parciales

#### Problemas de Valor en la Frontera

- [Método del Disparo Lineal](#método-del-disparo-lineal)
- [Método del Disparo No Lineal](#método-del-disparo-no-lineal)

#### Diferencias Finitas

- [Método de Diferencias Finitas Lineal](#método-de-diferencias-finitas-lineal)
- [Método de Diferencias Finitas No Lineales](#método-de-diferencias-finitas-no-lineales)

#### Ecuaciones Elípticas

- [Método de Ecuación Elíptica (Poisson)](#método-de-ecuación-elíptica-poisson)

#### Ecuaciones Parabólicas

- [Método de Ecuación Parabólica (Calor)](#método-de-ecuación-parabólica-calor)

#### Ecuaciones Hiperbólicas

- [Método de Ecuación Hiperbólica (Onda)](#método-de-ecuación-hiperbólica-onda)

### Métodos Adicionales para Sistemas Lineales

- [Método de Eliminación Gaussiana con Sustitución hacia Atrás](#método-de-eliminación-gaussiana-con-sustitución-hacia-atrás)
- [Método de Factorización de Schur](#método-de-factorización-de-schur)

### Métodos de Relajación para Sistemas Lineales

- [Método de Jacobi con Relajación](#método-de-jacobi-con-relajación)
- [Método de Gauss-Seidel con Relajación (SOR)](#método-de-gauss-seidel-con-relación-sor)

---

## Método de Bisección

```pseudocode
INICIO MétodoBisección
  ENTRADAS:
    función: cadena (expresión matemática)
    a: real (límite inferior del intervalo)
    b: real (límite superior del intervalo)
    tol: real (tolerancia de error)
    n: entero (número máximo de iteraciones)
    dn: entero (dígitos para redondeo)

  SALIDAS:
    resultado: real (raíz aproximada)
    mensaje: cadena (estado del cálculo)
    tablaResultados: lista de iteraciones

  PASOS:
    1. INICIALIZAR
        - Limpiar tabla de resultados
        - Validar entradas básicas (función no vacía, a < b, tol > 0, n > 0)

    2. VALIDAR FUNCIÓN Y PARÁMETROS
        - Verificar que la función sea evaluable en puntos de prueba
        - Calcular f(a) y f(b)
        - Si f(a)*f(b) ≥ 0 Y ningún extremo es cero → ERROR (no hay cambio de signo)

    3. CASOS ESPECIALES
        - Si f(a) = 0 → Raíz exacta en x = a
        - Si f(b) = 0 → Raíz exacta en x = b

    4. ALGORITMO PRINCIPAL
        PARA i = 1 HASTA n HACER:
            a. Calcular punto medio: p = (a + b) / 2
            b. Evaluar f(p)
            c. Calcular error: error = |b - a| / 2

            d. Registrar iteración en tabla:
                [i, a, b, p, f(a), f(b), f(p), f(a)*f(p), error]

            e. CRITERIOS DE PARADA:
               - Si |f(p)| ≈ 0 → Raíz exacta encontrada (TERMINAR)
               - Si error < tol → Solución aproximada (TERMINAR)

            f. ACTUALIZAR INTERVALO:
               - Si f(a)*f(p) > 0 → a = p (raíz en [p, b])
               - Sino → b = p (raíz en [a, p])

        FIN PARA

    5. RESULTADO FINAL
        - Si se alcanzó n iteraciones → Devolver mejor aproximación
        - Si hubo error → Mensaje descriptivo

    6. ANÁLISIS ADICIONAL (Opcional)
        - Evaluar función en extremos y punto medio
        - Calcular derivada numérica
        - Determinar monotonicidad

FIN MétodoBisección
```

---

## Método de Punto Fijo

```pseudocode
INICIO MétodoPuntoFijo
  ENTRADAS:
    función: cadena (función g(x) para iteración)
    x0: real (valor inicial)
    tol: real (tolerancia de error)
    n: entero (número máximo de iteraciones)
    dn: entero (dígitos para redondeo)

  SALIDAS:
    resultado: real (raíz aproximada)
    mensaje: cadena (estado del cálculo)
    tablaResultados: lista de iteraciones
    éxito: booleano (indicador de convergencia)

  PASOS:
    1. INICIALIZAR
        - Limpiar tabla de resultados
        - Validar entradas básicas (función no vacía, tol > 0, n > 0)

    2. VALIDAR FUNCIÓN EN PUNTO INICIAL
        - Evaluar g(x0)
        - Si g(x0) no es un número finito → ERROR

    3. ALGORITMO PRINCIPAL
        - p0 = x0
        - i = 1
        - convergido = falso

        MIENTRAS i ≤ n Y NO convergido HACER:
            a. Calcular p = g(p0)
            b. Si p no es finito → ERROR

            c. Calcular error = |p - p0|

            d. Registrar iteración en tabla:
                [i, p0, p, error]

            e. CRITERIO DE PARADA:
               - Si error < tol → Solución aproximada (TERMINAR)

            f. ACTUALIZAR:
               - p0 = p
               - i = i + 1

        FIN MIENTRAS

    4. RESULTADO FINAL
        - Si convergió → Devolver aproximación exitosa
        - Si no convergió → Devolver mejor aproximación con advertencia

    5. ANÁLISIS DE CONVERGENCIA (Opcional)
        - Calcular derivada numérica: g'(x0)
        - Verificar condición |g'(x0)| < 1
        - Determinar probabilidad de convergencia

FIN MétodoPuntoFijo
```

---

## Método de Newton-Raphson

```pseudocode
INICIO MétodoNewtonRaphson
  ENTRADAS:
    función: cadena (f(x) - función objetivo)
    funciónDer: cadena (f'(x) - derivada de la función)
    x0: real (valor inicial)
    tol: real (tolerancia de error)
    n: entero (número máximo de iteraciones)
    dn: entero (dígitos para redondeo)

  SALIDAS:
    resultado: real (raíz aproximada)
    mensaje: cadena (estado del cálculo)
    tablaResultados: lista de iteraciones
    éxito: booleano (indicador de convergencia)

  PASOS:
    1. INICIALIZAR
        - Limpiar tabla de resultados
        - Validar entradas básicas (funciones no vacías, tol > 0, n > 0)

    2. VALIDAR FUNCIONES EN PUNTO INICIAL
        - Evaluar f(x0) y f'(x0)
        - Si f'(x0) = 0 → ERROR (división por cero)
        - Si valores no son finitos → ERROR

    3. ALGORITMO PRINCIPAL
        - xn1 = x0
        - fxn1 = f(x0)
        - i = 1
        - convergido = falso

        MIENTRAS i ≤ n Y NO convergido HACER:
            a. Evaluar f'(xn1)
            b. Si f'(xn1) = 0 → ERROR (derivada cero)

            c. Calcular corrección: d = f(xn1) / f'(xn1)
            d. Calcular nuevo punto: xn1 = xn1 - d
            e. Evaluar f(xn1) en nuevo punto

            f. Calcular error = |d|

            g. Registrar iteración en tabla:
                [i, xn_anterior, f(xn1), f'(xn1), xn1, error]

            h. CRITERIO DE PARADA:
               - Si error < tol → Solución aproximada (TERMINAR)

            i. Incrementar contador: i = i + 1

        FIN MIENTRAS

    4. RESULTADO FINAL
        - Si convergió → Devolver aproximación exitosa
        - Si no convergió → Devolver mejor aproximación con advertencia

FIN MétodoNewtonRaphson
```

---

## Método De La Secante

```pseudocode
INICIO MétodoSecante
  ENTRADAS:
    función: cadena (f(x) - función objetivo)
    xn_1: real (primer punto inicial)
    xn: real (segundo punto inicial)
    tol: real (tolerancia de error)
    n: entero (número máximo de iteraciones)
    dn: entero (dígitos para redondeo)

  SALIDAS:
    resultado: real (raíz aproximada)
    mensaje: cadena (estado del cálculo)
    tablaResultados: lista de iteraciones
    éxito: booleano (indicador de convergencia)

  PASOS:
    1. INICIALIZAR
        - Limpiar tabla de resultados
        - Validar entradas básicas (función no vacía, tol > 0, n > 0, xn_1 ≠ xn)

    2. VALIDAR FUNCIÓN EN PUNTOS INICIALES
        - Evaluar f(xn_1) y f(xn)
        - Si los valores no son finitos → ERROR

    3. ALGORITMO PRINCIPAL
        - x0 = xn_1, x1 = xn
        - fx0 = f(x0), fx1 = f(x1)
        - i = 1
        - convergido = falso

        # Registrar iteración inicial (i=0)
        - Agregar [0, x0, fx0, x1, fx1, "-", "-"] a tablaResultados

        MIENTRAS i ≤ n Y NO convergido HACER:
            a. Si (fx1 - fx0) = 0 → ERROR (división por cero)

            b. Calcular nuevo punto: 
                 x2 = x1 - fx1 * (x1 - x0) / (fx1 - fx0)

            c. Evaluar f(x2)

            d. Si f(x2) no es finito → ERROR

            e. Calcular error = |x2 - x1|

            f. Registrar iteración i en tabla:
                 [i, x0, fx0, x1, fx1, x2, error]

            g. CRITERIO DE PARADA:
                 - Si error < tol → Solución aproximada (TERMINAR)

            h. ACTUALIZAR PUNTOS:
                 - x0 = x1, fx0 = fx1
                 - x1 = x2, fx1 = f(x2)
                 - i = i + 1

        FIN MIENTRAS

    4. RESULTADO FINAL
        - Si convergió → Devolver aproximación exitosa
        - Si no convergió → Devolver mejor aproximación con advertencia

FIN MétodoSecante
```

---

## Método De La Posición Falsa

```pseudocode
INICIO MétodoPosicionFalsa
  ENTRADAS:
    función: cadena (f(x) - función objetivo)
    xn_1: real (extremo izquierdo del intervalo inicial)
    xn: real (extremo derecho del intervalo inicial)
    tol: real (tolerancia de error)
    n: entero (número máximo de iteraciones)
    dn: entero (dígitos para redondeo)

  SALIDAS:
    resultado: real (raíz aproximada)
    mensaje: cadena (estado del cálculo)
    tablaResultados: lista de iteraciones
    éxito: booleano (indicador de convergencia)

  PASOS:
    1. INICIALIZAR
        - Limpiar tabla de resultados
        - Validar entradas básicas (función no vacía, tol > 0, n > 0, xn_1 ≠ xn)

    2. VALIDAR FUNCIÓN Y CAMBIO DE SIGNO
        - Evaluar f(xn_1) y f(xn)
        - Si los valores no son finitos → ERROR
        - Si f(xn_1) * f(xn) ≥ 0 → ERROR (no hay cambio de signo - Teorema de Bolzano)

    3. ALGORITMO PRINCIPAL
        - a = xn_1, b = xn
        - fa = f(a), fb = f(b)
        - i = 1
        - convergido = falso

        # Registrar iteración inicial (i=0)
        - Agregar [0, a, b, fa, fb, "-", "-", "-"] a tablaResultados

        MIENTRAS i ≤ n Y NO convergido HACER:
            a. Si (fb - fa) = 0 → ERROR (división por cero)

            b. Calcular nuevo punto por interpolación lineal: 
                 c = b - fb * (b - a) / (fb - fa)

            c. Evaluar f(c)

            d. Si f(c) no es finito → ERROR

            e. Calcular error = |c - b|

            f. Registrar iteración i en tabla:
                 [i, a, b, fa, fb, c, f(c), error]

            g. CRITERIO DE PARADA:
                 - Si error < tol → Solución aproximada (TERMINAR)

            h. ACTUALIZAR INTERVALO:
                 - Si f(c) * fa < 0:
                     # La raíz está en [a, c]
                     b = c
                     fb = f(c)
                 - Sino:
                     # La raíz está en [c, b]
                     a = c
                     fa = f(c)

            i. Incrementar contador: i = i + 1

        FIN MIENTRAS

    4. RESULTADO FINAL
        - Si convergió → Devolver aproximación exitosa
        - Si no convergió → Devolver mejor aproximación con advertencia

FIN MétodoPosicionFalsa
```

---

## Método De Steffensen

```pseudocode
INICIO MétodoSteffensen
  ENTRADAS:
    función: cadena (g(x) - función de punto fijo)
    p0: real (valor inicial)
    tol: real (tolerancia de error)
    n: entero (número máximo de iteraciones)
    dn: entero (dígitos para redondeo)

  SALIDAS:
    resultado: real (raíz aproximada)
    mensaje: cadena (estado del cálculo)
    tablaResultados: lista de iteraciones
    éxito: booleano (indicador de convergencia)

  PASOS:
    1. INICIALIZAR
        - Limpiar tabla de resultados
        - Validar entradas básicas (función no vacía, tol > 0, n > 0)

    2. VALIDAR FUNCIÓN EN PUNTO INICIAL
        - Evaluar g(p0)
        - Si g(p0) no es un número finito → ERROR

    3. ALGORITMO PRINCIPAL
        - current_p0 = p0
        - i = 1
        - convergido = falso

        MIENTRAS i ≤ n Y NO convergido HACER:
            a. Calcular:
                 p1 = g(current_p0)
                 p2 = g(p1)

            b. Calcular denominador = p2 - 2·p1 + current_p0

            c. Si |denominador| < ε → ERROR (división por cero)

            d. Calcular corrección:
                 d = (p1 - current_p0)² / denominador

            e. Calcular nuevo punto:
                 p_next = current_p0 - d

            f. Evaluar g(p_next) (para verificación)

            g. Calcular error = |d|

            h. Registrar iteración en tabla:
                 [i, current_p0, p1, p2, p_next, error]

            i. CRITERIO DE PARADA:
                 - Si error < tol → Solución aproximada (TERMINAR)

            j. ACTUALIZAR:
                 - current_p0 = p_next
                 - i = i + 1

        FIN MIENTRAS

    4. RESULTADO FINAL
        - Si convergió → Devolver aproximación exitosa
        - Si no convergió → Devolver mejor aproximación con advertencia

FIN MétodoSteffensen
```

---

## Método De Müller

```pseudocode
INICIO MétodoMüller
  ENTRADAS:
    coefs: lista de reales (coeficientes del polinomio [aₙ, aₙ₋₁, ..., a₀])
    x0, x1, x2: reales (tres puntos iniciales)
    tol: real (tolerancia de error)
    n: entero (número máximo de iteraciones)
    dn: entero (dígitos para redondeo)

  SALIDAS:
    resultado: real/complejo (raíz aproximada)
    mensaje: cadena (estado del cálculo)
    tablaResultados: lista de iteraciones
    éxito: booleano (indicador de convergencia)

  PASOS:
    1. INICIALIZAR
        - Limpiar tabla de resultados
        - Validar entradas básicas (coeficientes no vacíos, coeficiente principal ≠ 0, tol > 0, n > 0)

    2. ANÁLISIS DEL POLINOMIO
        - Determinar grado del polinomio
        - Para polinomios de grado ≤ 2, calcular raíces exactas
        - Evaluar polinomio en puntos iniciales

    3. ALGORITMO PRINCIPAL
        - Inicializar variables para caso real y complejo
        - ISW = 0 (indicador: 0=real, 1=complejo)
        - I = 3 (contador de iteraciones)
        - convergido = falso

        MIENTRAS I ≤ n Y NO convergido HACER:
            SI ISW = 0 ENTONCES:  # CASO REAL
                a. Calcular diferencias:
                   h₀ = x₁ - x₀, h₁ = x₂ - x₁
                   δ₀ = (f(x₁) - f(x₀)) / h₀
                   δ₁ = (f(x₂) - f(x₁)) / h₁
                   δ = (δ₁ - δ₀) / (h₁ + h₀)

                b. Calcular coeficientes de la parábola:
                   a = δ
                   b = δ₁ + h₁·δ
                   c = f(x₂)

                c. Calcular discriminante: D = b² - 4·a·c

                d. SI D ≥ 0 ENTONCES:  # Raíces reales
                   - Calcular raíz: x₃ = x₂ - 2c / (b + signo(b)·√D)
                   - Evaluar f(x₃)
                   - error = |x₃ - x₂|

                   e. Registrar iteración real

                   f. SI error < tol ENTONCES:
                      convergido = verdadero, resultado = x₃
                   SINO:
                      # Actualizar puntos para siguiente iteración
                      x₀ = x₁, x₁ = x₂, x₂ = x₃
                      I = I + 1

                e. SI NO (D < 0):  # Cambiar a caso complejo
                   ISW = 1
                   Inicializar variables complejas con puntos reales actuales

            SI ISW = 1 ENTONCES:  # CASO COMPLEJO
                a. Calcular diferencias complejas usando operaciones con números complejos

                b. Resolver ecuación cuadrática compleja:
                   a = δ (complejo)
                   b = δ₁ + h₁·δ (complejo)  
                   c = f(z₂) (complejo)

                c. Calcular raíz compleja usando fórmula cuadrática compleja

                d. Evaluar polinomio en punto complejo z₃

                e. error = |z₃ - z₂| (magnitud compleja)

                f. Registrar iteración compleja

                g. SI error < tol ENTONCES:
                   convergido = verdadero, resultado = z₃
                SINO:
                   # Actualizar puntos complejos
                   z₀ = z₁, z₁ = z₂, z₂ = z₃
                   I = I + 1

        FIN MIENTRAS

FIN MétodoMüller
```

---

## Método de Polinomios De Lagrange

```pseudocode
INICIO InterpolacionLagrange
  ENTRADAS:
    n: entero (grado del polinomio)
    c: real (punto de evaluación)
    dn: entero (dígitos para redondeo)
    dataTable: matriz de reales [[i, xᵢ, yᵢ], ...] (tabla de datos)
    puntos: lista de puntos (xᵢ, yᵢ)

  SALIDAS:
    f_c: real (valor interpolado en c)
    polynomial: cadena (representación del polinomio)
    mensaje: cadena (estado del cálculo)
    éxito: booleano (indicador de éxito)

  PASOS:
    1. INICIALIZAR
        - Limpiar resultados anteriores
        - Validar parámetros (n > 0, n ≤ 8, tabla no vacía, tabla tiene n+1 filas)

    2. EXTRAER DATOS
        - arrayx = [x₀, x₁, ..., xₙ] desde dataTable
        - arrayy = [y₀, y₁, ..., yₙ] desde dataTable

    3. VERIFICAR RANGO DE INTERPOLACIÓN
        - minX = mínimo(arrayx), maxX = máximo(arrayx)
        - Si c < minX - 1 O c > maxX + 1 → Advertencia (extrapolación)

    4. CALCULAR INTERPOLACIÓN EN PUNTO c
        - f_c = 0.0
        - PARA i = 0 HASTA n HACER:
            numerador = 1.0
            denominador = 1.0
            
            PARA j = 0 HASTA n HACER:
                SI j ≠ i ENTONCES:
                    numerador = numerador × (c - xⱼ)
                    denominador = denominador × (xᵢ - xⱼ)
            
            f_c = f_c + (numerador / denominador) × yᵢ

    5. CONSTRUIR REPRESENTACIÓN DEL POLINOMIO
        - SI n ≤ 3 ENTONCES:
            polinomio = construcción explícita término por término
        - SINO:
            polinomio = representación compacta con notación sigma/pi

    6. GENERAR DATOS ADICIONALES
        - Puntos para graficar el polinomio interpolante
        - Puntos originales de la tabla
        - Análisis de calidad de interpolación

    7. RESULTADOS
        - Redondear f_c a dn decimales
        - Guardar representación del polinomio
        - Éxito = verdadero

FIN InterpolacionLagrange
```

---

## Método De Neville

```pseudocode
INICIO MétodoNeville
  ENTRADAS:
    n: entero (número de puntos de interpolación)
    c: real (punto de evaluación)
    dn: entero (dígitos para redondeo)
    dataTable: matriz de reales [[i, xᵢ, yᵢ], ...] (tabla de datos)

  SALIDAS:
    resultado: real (valor interpolado en c)
    nevilleTable: matriz triangular de reales (tabla de Neville)
    resultMatrix: lista de cadenas (representación de la tabla)
    mensaje: cadena (estado del cálculo)
    éxito: booleano (indicador de éxito)

  PASOS:
    1. INICIALIZAR
        - Limpiar resultados anteriores
        - Validar parámetros (n > 0, n ≤ 25, tabla no vacía, tabla tiene n filas)

    2. EXTRAER DATOS
        - xx = [x₀, x₁, ..., xₙ₋₁] desde dataTable
        - temp = [y₀, y₁, ..., yₙ₋₁] desde dataTable

    3. INICIALIZAR MATRIZ Q
        - Q = matriz de n × n, inicializada en 0
        - PARA i = 0 HASTA n-1 HACER:
            Q[i][0] = temp[i]  (valores iniciales de la función)

    4. APLICAR ALGORITMO DE NEVILLE
        - PARA i = 1 HASTA n-1 HACER:
            PARA j = 1 HASTA i HACER:
                numerador = (c - xx[i]) × Q[i-1][j-1] - (c - xx[i-j]) × Q[i][j-1]
                denominador = xx[i-j] - xx[i]
                
                SI |denominador| < ε ENTONCES:
                    ERROR: división por cero
                
                Q[i][j] = numerador / denominador

    5. CONSTRUIR TABLA DE RESULTADOS
        - nevilleTable = extraer parte triangular de Q
        - resultMatrix = construir representación textual de la tabla

    6. RESULTADO FINAL
        - resultado = Q[n-1][n-1]
        - Redondear resultado a dn decimales
        - Éxito = verdadero

    7. GENERAR DATOS ADICIONALES
        - Puntos para graficar el polinomio interpolante
        - Puntos originales de la tabla
        - Análisis de calidad de interpolación

FIN MétodoNeville
```

---

## Método De Diferencias Divididas De Newton

```pseudocode
INICIO MétodoDiferenciasDivididasNewton
  ENTRADAS:
    n: entero (número de puntos de interpolación)
    c: real (punto de evaluación)
    dn: entero (dígitos para redondeo)
    dataTable: matriz de reales [[i, xᵢ, yᵢ], ...] (tabla de datos)

  SALIDAS:
    resultado: real (valor interpolado en c)
    differencesTable: matriz triangular de reales (tabla de diferencias divididas)
    polynomial: cadena (representación del polinomio de Newton)
    coefficients: lista de reales (coeficientes del polinomio)
    mensaje: cadena (estado del cálculo)
    éxito: booleano (indicador de éxito)

  PASOS:
    1. INICIALIZAR
        - Limpiar resultados anteriores
        - Validar parámetros (n > 0, n ≤ 8, tabla no vacía, tabla tiene n filas)

    2. EXTRAER DATOS
        - xx = [x₀, x₁, ..., xₙ₋₁] desde dataTable
        - temp = [y₀, y₁, ..., yₙ₋₁] desde dataTable

    3. INICIALIZAR MATRIZ Q
        - Q = matriz de n × n, inicializada en 0
        - PARA i = 0 HASTA n-1 HACER:
            Q[i][0] = temp[i]  (valores iniciales de la función)

    4. CALCULAR DIFERENCIAS DIVIDIDAS
        - PARA i = 1 HASTA n-1 HACER:
            PARA j = 1 HASTA i HACER:
                numerador = Q[i][j-1] - Q[i-1][j-1]
                denominador = xx[i] - xx[i-j]
                
                SI |denominador| < ε ENTONCES:
                    ERROR: división por cero
                
                Q[i][j] = numerador / denominador

    5. EXTRAER COEFICIENTES Y CONSTRUIR TABLA
        - coefficients = [Q[0][0], Q[1][1], ..., Q[n-1][n-1]] (diagonales de la tabla)
        - differencesTable = parte triangular de Q

    6. CONSTRUIR POLINOMIO DE NEWTON
        - polynomial = "P(x) = " + coeficiente[0]
        - PARA i = 1 HASTA n-1 HACER:
            término = coeficiente[i] × (x - x₀) × (x - x₁) × ... × (x - xᵢ₋₁)
            Agregar término al polinomio con el signo apropiado

    7. EVALUAR POLINOMIO EN PUNTO c
        - resultado = coefficients[0]
        - PARA i = 1 HASTA n-1 HACER:
            producto = coefficients[i]
            PARA j = 0 HASTA i-1 HACER:
                producto = producto × (c - xx[j])
            resultado = resultado + producto

    8. CONVERTIR A FORMA ESTÁNDAR (Opcional)
        - Expandir productos para obtener coeficientes en forma estándar
        - Coeficientes estándar = [a₀, a₁, ..., aₙ₋₁] para P(x) = a₀ + a₁x + a₂x² + ...

    9. GENERAR DATOS ADICIONALES
        - Puntos para graficar el polinomio interpolante
        - Puntos originales de la tabla
        - Análisis de calidad de interpolación

FIN MétodoDiferenciasDivididasNewton
```

---

## Metodo de Diferencias Divididas de Newton

```pseudocode
INICIO MétodoDiferenciasDivididasNewton
  ENTRADAS:
    n: entero (número de puntos de interpolación)
    c: real (punto de evaluación)
    dn: entero (dígitos para redondeo)
    dataTable: matriz de reales [[i, xᵢ, yᵢ], ...] (tabla de datos)

  SALIDAS:
    resultado: real (valor interpolado en c)
    differencesTable: matriz triangular de reales (tabla de diferencias divididas)
    polynomial: cadena (representación del polinomio de Newton)
    coefficients: lista de reales (coeficientes del polinomio)
    mensaje: cadena (estado del cálculo)
    éxito: booleano (indicador de éxito)

  PASOS:
    1. INICIALIZAR
        - Limpiar resultados anteriores
        - Validar parámetros (n > 0, n ≤ 8, tabla no vacía, tabla tiene n filas)

    2. EXTRAER DATOS
        - xx = [x₀, x₁, ..., xₙ₋₁] desde dataTable
        - temp = [y₀, y₁, ..., yₙ₋₁] desde dataTable

    3. INICIALIZAR MATRIZ Q
        - Q = matriz de n × n, inicializada en 0
        - PARA i = 0 HASTA n-1 HACER:
            Q[i][0] = temp[i]  (valores iniciales de la función)

    4. CALCULAR DIFERENCIAS DIVIDIDAS
        - PARA i = 1 HASTA n-1 HACER:
            PARA j = 1 HASTA i HACER:
                numerador = Q[i][j-1] - Q[i-1][j-1]
                denominador = xx[i] - xx[i-j]
                
                SI |denominador| < ε ENTONCES:
                    ERROR: división por cero
                
                Q[i][j] = numerador / denominador

    5. EXTRAER COEFICIENTES Y CONSTRUIR TABLA
        - coefficients = [Q[0][0], Q[1][1], ..., Q[n-1][n-1]] (diagonales de la tabla)
        - differencesTable = parte triangular de Q

    6. CONSTRUIR POLINOMIO DE NEWTON
        - polynomial = "P(x) = " + coeficiente[0]
        - PARA i = 1 HASTA n-1 HACER:
            término = coeficiente[i] × (x - x₀) × (x - x₁) × ... × (x - xᵢ₋₁)
            Agregar término al polinomio con el signo apropiado

    7. EVALUAR POLINOMIO EN PUNTO c
        - resultado = coefficients[0]
        - PARA i = 1 HASTA n-1 HACER:
            producto = coefficients[i]
            PARA j = 0 HASTA i-1 HACER:
                producto = producto × (c - xx[j])
            resultado = resultado + producto

    8. CONVERTIR A FORMA ESTÁNDAR (Opcional)
        - Expandir productos para obtener coeficientes en forma estándar
        - Coeficientes estándar = [a₀, a₁, ..., aₙ₋₁] para P(x) = a₀ + a₁x + a₂x² + ...

    9. GENERAR DATOS ADICIONALES
        - Puntos para graficar el polinomio interpolante
        - Puntos originales de la tabla
        - Análisis de calidad de interpolación

FIN MétodoDiferenciasDivididasNewton
```

---

## Método De Jacobi

```pseudocode
INICIO MétodoJacobi
  ENTRADAS:
    n: entero (número de ecuaciones/variables)
    A: matriz de n × (n+1) [matriz aumentada: coeficientes + términos independientes]
    x0: vector de n (vector inicial)
    tol: real (tolerancia de error)
    max_iter: entero (número máximo de iteraciones)

  SALIDAS:
    x: vector de n (solución aproximada)
    tabla_resultados: tabla de iteraciones
    error_final: real (error global final)
    éxito: booleano (indicador de convergencia)

  PASOS:
    1. INICIALIZAR
        - Validar parámetros (n > 0, A no vacía, dimensiones correctas, tol > 0)
        - Verificar si A es diagonalmente dominante (advertencia si no lo es)
        - x_actual = x0 (vector actual)
        - x_siguiente = vector de n ceros (vector siguiente)
        - iteración = 1
        - convergió = falso
        - error_global = 0.0

    2. ALGORITMO ITERATIVO
        MIENTRAS iteración ≤ max_iter Y NO convergió HACER:
            error_global = 0.0
            
            PARA i = 0 HASTA n-1 HACER:
                suma = 0.0
                
                PARA j = 0 HASTA n-1 HACER:
                    SI j ≠ i ENTONCES:
                        suma = suma + A[i][j] × x_actual[j]
                
                // Fórmula de Jacobi: x_i^(k+1) = (b_i - Σ_{j≠i} a_ij × x_j^k) / a_ii
                x_siguiente[i] = (A[i][n] - suma) / A[i][i]
                
                // Calcular error para esta variable
                error_variable = |x_siguiente[i] - x_actual[i]|
                SI error_variable > error_global ENTONCES:
                    error_global = error_variable
            
            // Registrar iteración en tabla
            fila = [iteración, x_siguiente[0], ..., x_siguiente[n-1], 
                   errores_variables[0], ..., errores_variables[n-1], error_global]
            Agregar fila a tabla_resultados
            
            // Verificar convergencia
            SI error_global ≤ tol ENTONCES:
                convergió = verdadero
                éxito = verdadero
            SINO:
                // Preparar siguiente iteración
                x_actual = x_siguiente
                iteración = iteración + 1

    3. RESULTADO FINAL
        SI convergió ENTONCES:
            x = x_siguiente
            Devolver solución exitosa
        SINO:
            x = x_siguiente (mejor aproximación)
            Devolver advertencia de no convergencia
FIN MétodoJacobi
```

---

## Método De Gauss-Seidel

```pesudocode
INICIO MétodoGaussSeidel
  ENTRADAS:
    n: entero (número de ecuaciones/variables)
    A: matriz de n × (n+1) [matriz aumentada: coeficientes + términos independientes]
    x0: vector de n (vector inicial)
    tol: real (tolerancia de error)
    max_iter: entero (número máximo de iteraciones)

  SALIDAS:
    x: vector de n (solución aproximada)
    tabla_resultados: tabla de iteraciones
    error_final: real (error global final)
    éxito: booleano (indicador de convergencia)

  PASOS:
    1. INICIALIZAR
        - Validar parámetros (n > 0, A no vacía, dimensiones correctas, tol > 0, max_iter > 0)
        - Verificar que elementos diagonales ≠ 0
        - Verificar si A es diagonalmente dominante (advertencia si no lo es)
        - x_actual = x0 (vector actual)
        - x_anterior = copia de x0 (para calcular errores)
        - iteración = 1
        - convergió = falso
        - error_global = 0.0

    2. ALGORITMO ITERATIVO
        MIENTRAS iteración ≤ max_iter Y NO convergió HACER:
            // Guardar estado anterior para cálculo de errores
            x_anterior = copia de x_actual
            
            error_global = 0.0
            
            PARA i = 0 HASTA n-1 HACER:
                suma = 0.0
                
                // Suma con valores YA actualizados (j < i) - DIFERENCIA CLAVE con Jacobi
                PARA j = 0 HASTA i-1 HACER:
                    suma = suma + A[i][j] × x_actual[j]
                
                // Suma con valores NO actualizados (j > i)
                PARA j = i+1 HASTA n-1 HACER:
                    suma = suma + A[i][j] × x_anterior[j]
                
                // Fórmula de Gauss-Seidel: x_i^(k+1) = (b_i - Σ_{j≠i} a_ij × x_j) / a_ii
                // Donde para j < i usamos x_j^(k+1) y para j > i usamos x_j^(k)
                x_actual[i] = (A[i][n] - suma) / A[i][i]
                
                // Calcular error para esta variable
                error_variable = |x_actual[i] - x_anterior[i]|
                SI error_variable > error_global ENTONCES:
                    error_global = error_variable
            
            // Registrar iteración en tabla
            fila = [iteración, x_actual[0], ..., x_actual[n-1], 
                   errores_variables[0], ..., errores_variables[n-1], error_global]
            Agregar fila a tabla_resultados
            
            // Verificar convergencia
            SI error_global ≤ tol ENTONCES:
                convergió = verdadero
                éxito = verdadero
            SINO:
                iteración = iteración + 1

    3. RESULTADO FINAL
        SI convergió ENTONCES:
            x = x_actual
            Devolver solución exitosa
        SINO:
            x = x_actual (mejor aproximación)
            Devolver advertencia de no convergencia

FIN MétodoGaussSeidel
```

---

## Método Punto Fijo Para 2 Variables

```pseudocode
INICIO MétodoPuntoFijo2Variables
  ENTRADAS:
    g1: cadena (función g1(x,y) - primera ecuación del sistema)
    g2: cadena (función g2(x,y) - segunda ecuación del sistema)
    x0: real (valor inicial para x)
    y0: real (valor inicial para y)
    tol: real (tolerancia de error)
    max_iter: entero (número máximo de iteraciones)

  SALIDAS:
    x, y: reales (solución aproximada)
    tabla_resultados: tabla de iteraciones
    error_final: real (error global final)
    éxito: booleano (indicador de convergencia)

  PASOS:
    1. INICIALIZAR
        - Validar parámetros (funciones no vacías, tol > 0, max_iter > 0)
        - Verificar que funciones sean válidas y evaluables en (x0, y0)
        - iteración = 1
        - convergió = falso
        - error_global = 0.0
        - x_actual = x0, y_actual = y0

    2. ALGORITMO ITERATIVO
        - Registrar iteración inicial (0) con (x0, y0) y errores 0

        MIENTRAS iteración ≤ max_iter Y NO convergió HACER:
            // Evaluar las funciones en el punto actual
            x_siguiente = g1(x_actual, y_actual)
            y_siguiente = g2(x_actual, y_actual)

            // Calcular errores
            error_x = |x_siguiente - x_actual|
            error_y = |y_siguiente - y_actual|
            error_global = máximo(error_x, error_y)

            // Registrar iteración
            Agregar [iteración, x_siguiente, y_siguiente, error_x, error_y, error_global] a tabla_resultados

            // Verificar convergencia
            SI error_global ≤ tol ENTONCES:
                convergió = verdadero
                éxito = verdadero
                x = x_siguiente
                y = y_siguiente
            SINO:
                // Preparar siguiente iteración
                x_actual = x_siguiente
                y_actual = y_siguiente
                iteración = iteración + 1

    3. RESULTADO FINAL
        SI NO convergió ENTONCES:
            éxito = falso
            x = x_siguiente (último valor calculado)
            y = y_siguiente (último valor calculado)
            Devolver advertencia de no convergencia

FIN MétodoPuntoFijo2Variables
```

---

## Método De Punto Fijo 3 Variables

```pseudocode
ALGORITMO MétodoPuntoFijo3Variables
ENTRADAS:
    g1, g2, g3: funciones de tres variables (x, y, z)
    x0, y0, z0: valores iniciales
    tol: tolerancia del error
    n: número máximo de iteraciones
    dn: número de decimales para redondeo

SALIDAS:
    solución aproximada (x, y, z)
    tabla de iteraciones
    mensaje de estado (éxito/error)

INICIO
    // Validación inicial
    SI g1, g2, g3 están vacías O tol ≤ 0 O n ≤ 0 ENTONCES
        RETORNAR error
    FIN SI
    
    // Verificar que las funciones sean válidas
    SI no se pueden evaluar g1, g2, g3 en (x0, y0, z0) ENTONCES
        RETORNAR error
    FIN SI
    
    // Inicialización
    x_actual ← x0
    y_actual ← y0
    z_actual ← z0
    iteracion ← 1
    convergio ← FALSO
    
    // Tabla de resultados inicial
    tabla ← [[0, x0, y0, z0, 0, 0, 0, 0]]
    
    // Bucle principal
    MIENTRAS iteracion ≤ n Y NO convergio HACER
        // Evaluar funciones en punto actual
        x_siguiente ← g1(x_actual, y_actual, z_actual)
        y_siguiente ← g2(x_actual, y_actual, z_actual)
        z_siguiente ← g3(x_actual, y_actual, z_actual)
        
        // Calcular errores
        error_x ← |x_siguiente - x_actual|
        error_y ← |y_siguiente - y_actual|
        error_z ← |z_siguiente - z_actual|
        error_max ← max(error_x, error_y, error_z)
        
        // Guardar en tabla
        tabla ← tabla ∪ [[iteracion, x_siguiente, y_siguiente, z_siguiente, error_x, error_y, error_z, error_max]]
        
        // Verificar convergencia
        SI error_max ≤ tol ENTONCES
            convergio ← VERDADERO
            éxito ← VERDADERO
            mensaje ← "Convergencia alcanzada"
        SINO
            // Preparar siguiente iteración
            x_actual ← x_siguiente
            y_actual ← y_siguiente
            z_actual ← z_siguiente
            iteracion ← iteracion + 1
        FIN SI
    FIN MIENTRAS
    
    // Si no convergió
    SI NO convergio ENTONCES
        éxito ← FALSO
        mensaje ← "Máximo de iteraciones alcanzado"
    FIN SI
    
    RETORNAR tabla, (x_actual, y_actual, z_actual), mensaje, éxito
FIN

// Funciones auxiliares
FUNCIÓN AnalizarConvergencia(x0, y0, z0, g1, g2, g3)
    // Calcular derivadas parciales numéricamente
    h ← 0.0001
    
    // Para g1
    dg1/dx ← (g1(x0+h, y0, z0) - g1(x0, y0, z0)) / h
    dg1/dy ← (g1(x0, y0+h, z0) - g1(x0, y0, z0)) / h
    dg1/dz ← (g1(x0, y0, z0+h) - g1(x0, y0, z0)) / h
    
    // Para g2 y g3 (similar)
    ...
    
    // Calcular norma de la matriz jacobiana
    norma_jacobiana ← max(
        |dg1/dx| + |dg1/dy| + |dg1/dz|,
        |dg2/dx| + |dg2/dy| + |dg2/dz|,
        |dg3/dx| + |dg3/dy| + |dg3/dz|
    )
    
    SI norma_jacobiana < 1 ENTONCES
        convergencia_garantizada ← VERDADERO
    SINO
        convergencia_garantizada ← FALSO
    FIN SI
    
    RETORNAR norma_jacobiana, convergencia_garantizada
FIN FUNCIÓN

FUNCIÓN VerificarContractividad(x0, y0, z0, g1, g2, g3)
    // Calcular máximo de derivadas parciales en valor absoluto
    max_derivada ← 0
    
    PARA cada función g1, g2, g3 HACER
        PARA cada variable x, y, z HACER
            derivada ← calcular derivada parcial numérica
            SI |derivada| > max_derivada ENTONCES
                max_derivada ← |derivada|
            FIN SI
        FIN PARA
    FIN PARA
    
    SI max_derivada < 1 ENTONCES
        es_contractiva ← VERDADERO
    SINO
        es_contractiva ← FALSO
    FIN SI
    
    RETORNAR max_derivada, es_contractiva
FIN FUNCIÓN
```

---

## Método de Newton Para 2 Variables

```pseudocode
ALGORITMO MétodoNewtonSistema2Ecuaciones
ENTRADAS:
    f1, f2: funciones de dos variables (x, y)
    df1/dx, df1/dy, df2/dx, df2/dy: derivadas parciales de f1 y f2
    x0, y0: valores iniciales
    tol: tolerancia del error
    n: número máximo de iteraciones
    dn: número de decimales para redondeo

SALIDAS:
    solución aproximada (x, y)
    tabla de iteraciones
    mensaje de estado (éxito/error)

INICIO
    // Validación de parámetros
    SI f1 O f2 están vacías ENTONCES
        RETORNAR "Error: debe proporcionar ambas funciones"
    FIN SI
    
    SI alguna derivada parcial está vacía ENTONCES
        RETORNAR "Error: debe proporcionar todas las derivadas parciales"
    FIN SI
    
    SI tol ≤ 0 O n ≤ 0 ENTONCES
        RETORNAR "Error: parámetros numéricos inválidos"
    FIN SI
    
    // Verificar que funciones y derivadas sean válidas
    SI no se pueden evaluar f1, f2, derivadas en (x0, y0) ENTONCES
        RETORNAR "Error: funciones no evaluables en punto inicial"
    FIN SI

    // Inicialización
    x_actual ← x0
    y_actual ← y0
    iteracion ← 1
    convergio ← FALSO
    exito ← VERDADERO
    tabla ← []
    
    // Agregar iteración inicial
    tabla ← tabla ∪ [[0, x0, y0, 0, 0, 0]]
    
    // Bucle principal
    MIENTRAS iteracion ≤ n Y exito Y NO convergio HACER
        INTENTAR
            // Evaluar funciones en punto actual
            f1_val ← f1(x_actual, y_actual)
            f2_val ← f2(x_actual, y_actual)
            
            // Construir matriz jacobiana
            jacobiana ← [
                [df1/dx(x_actual, y_actual), df1/dy(x_actual, y_actual)],
                [df2/dx(x_actual, y_actual), df2/dy(x_actual, y_actual)]
            ]
            
            // Vector de términos independientes
            vectorB ← [-f1_val, -f2_val]
            
            // Resolver sistema lineal J * delta = -F
            delta ← ResolverSistemaLineal2x2(jacobiana, vectorB)
            dx ← delta[0]
            dy ← delta[1]
            
            // Calcular nuevo punto
            x_siguiente ← x_actual + dx
            y_siguiente ← y_actual + dy
            
            // Calcular errores
            error_x ← |dx|
            error_y ← |dy|
            error_global ← max(error_x, error_y)
            
            // Guardar iteración
            tabla ← tabla ∪ [[iteracion, x_siguiente, y_siguiente, error_x, error_y, error_global]]
            
            // Verificar convergencia
            SI error_global ≤ tol ENTONCES
                convergio ← VERDADERO
                exito ← VERDADERO
                x ← x_siguiente
                y ← y_siguiente
                mensaje ← "Convergencia alcanzada"
            SINO
                // Preparar siguiente iteración
                x_actual ← x_siguiente
                y_actual ← y_siguiente
                iteracion ← iteracion + 1
            FIN SI
            
        CAPTURAR error
            exito ← FALSO
            mensaje ← "Error en iteración " + iteracion
        FIN INTENTAR
    FIN MIENTRAS
    
    // Si no convergió pero no hubo error
    SI NO convergio Y exito ENTONCES
        exito ← FALSO
        ultima_fila ← tabla[último]
        x ← ultima_fila[1]
        y ← ultima_fila[2]
        mensaje ← "Máximo de iteraciones alcanzado"
    FIN SI
    
    RETORNAR tabla, (x, y), mensaje, exito
FIN

// Función para resolver sistema lineal 2x2
FUNCIÓN ResolverSistemaLineal2x2(A, B)
    n ← 2
    matriz ← copia de A
    vector ← copia de B
    
    // Eliminación gaussiana con pivoteo
    PARA i ← 0 HASTA n-1 HACER
        // Pivoteo parcial
        maxVal ← |matriz[i][i]|
        maxFila ← i
        PARA k ← i+1 HASTA n-1 HACER
            SI |matriz[k][i]| > maxVal ENTONCES
                maxVal ← |matriz[k][i]|
                maxFila ← k
            FIN SI
        FIN PARA
        
        // Intercambiar filas si es necesario
        SI maxFila ≠ i ENTONCES
            PARA k ← i HASTA n-1 HACER
                temp ← matriz[i][k]
                matriz[i][k] ← matriz[maxFila][k]
                matriz[maxFila][k] ← temp
            FIN PARA
            tempVec ← vector[i]
            vector[i] ← vector[maxFila]
            vector[maxFila] ← tempVec
        FIN SI
        
        // Verificar si la matriz es singular
        SI |matriz[i][i]| < 1e-12 ENTONCES
            LANZAR "Sistema lineal singular"
        FIN SI
        
        // Eliminación
        PARA k ← i+1 HASTA n-1 HACER
            factor ← matriz[k][i] / matriz[i][i]
            PARA j ← i HASTA n-1 HACER
                SI j = i ENTONCES
                    matriz[k][j] ← 0.0
                SINO
                    matriz[k][j] ← matriz[k][j] - factor * matriz[i][j]
                FIN SI
            FIN PARA
            vector[k] ← vector[k] - factor * vector[i]
        FIN PARA
    FIN PARA
    
    // Sustitución hacia atrás
    solucion ← [0.0, 0.0]
    PARA i ← n-1 HASTA 0 HACER
        solucion[i] ← vector[i]
        PARA j ← i+1 HASTA n-1 HACER
            solucion[i] ← solucion[i] - matriz[i][j] * solucion[j]
        FIN PARA
        solucion[i] ← solucion[i] / matriz[i][i]
    FIN PARA
    
    RETORNAR solucion
FIN FUNCIÓN

// Funciones auxiliares para análisis
FUNCIÓN AnalizarConvergencia(x0, y0, f1, f2, derivadas)
    // Calcular determinante jacobiano
    detJ ← df1/dx(x0,y0)*df2/dy(x0,y0) - df1/dy(x0,y0)*df2/dx(x0,y0)
    
    SI |detJ| > 1e-10 ENTONCES
        convergencia_garantizada ← VERDADERO
        tipo_convergencia ← "Cuadrática"
    SINO
        convergencia_garantizada ← FALSO
        tipo_convergencia ← "No garantizada"
    FIN SI
    
    RETORNAR detJ, convergencia_garantizada, tipo_convergencia
FIN FUNCIÓN

FUNCIÓN CalcularErrorRaiz(x, y, f1, f2)
    error ← max(|f1(x,y)|, |f2(x,y)|)
    RETORNAR error
FIN FUNCIÓN
```

---

## Método de Newton Para 3 Variables

```pseudocode
ALGORITMO MétodoNewtonSistema3Ecuaciones
ENTRADAS:
    f1, f2, f3: funciones de tres variables (x, y, z)
    df1/dx, df1/dy, df1/dz, df2/dx, df2/dy, df2/dz, df3/dx, df3/dy, df3/dz: derivadas parciales
    x0, y0, z0: valores iniciales
    tol: tolerancia del error
    n: número máximo de iteraciones
    dn: número de decimales para redondeo

SALIDAS:
    solución aproximada (x, y, z)
    tabla de iteraciones
    mensaje de estado (éxito/error)

INICIO
    // Validación de parámetros
    SI f1 O f2 O f3 están vacías ENTONCES
        RETORNAR "Error: debe proporcionar las tres funciones"
    FIN SI
    
    SI alguna derivada parcial está vacía ENTONCES
        RETORNAR "Error: debe proporcionar todas las derivadas parciales"
    FIN SI
    
    SI tol ≤ 0 O n ≤ 0 ENTONCES
        RETORNAR "Error: parámetros numéricos inválidos"
    FIN SI
    
    // Verificar que funciones y derivadas sean válidas
    SI no se pueden evaluar f1, f2, f3, derivadas en (x0, y0, z0) ENTONCES
        RETORNAR "Error: funciones no evaluables en punto inicial"
    FIN SI

    // Inicialización
    x_actual ← x0
    y_actual ← y0
    z_actual ← z0
    iteracion ← 1
    convergio ← FALSO
    exito ← VERDADERO
    tabla ← []
    
    // Agregar iteración inicial
    tabla ← tabla ∪ [[0, x0, y0, z0, 0, 0, 0, 0]]
    
    // Bucle principal
    MIENTRAS iteracion ≤ n Y exito Y NO convergio HACER
        INTENTAR
            // Evaluar funciones en punto actual
            f1_val ← f1(x_actual, y_actual, z_actual)
            f2_val ← f2(x_actual, y_actual, z_actual)
            f3_val ← f3(x_actual, y_actual, z_actual)
            
            // Construir matriz jacobiana 3x3
            jacobiana ← [
                [df1/dx(x_actual,y_actual,z_actual), df1/dy(x_actual,y_actual,z_actual), df1/dz(x_actual,y_actual,z_actual)],
                [df2/dx(x_actual,y_actual,z_actual), df2/dy(x_actual,y_actual,z_actual), df2/dz(x_actual,y_actual,z_actual)],
                [df3/dx(x_actual,y_actual,z_actual), df3/dy(x_actual,y_actual,z_actual), df3/dz(x_actual,y_actual,z_actual)]
            ]
            
            // Vector de términos independientes
            vectorB ← [-f1_val, -f2_val, -f3_val]
            
            // Resolver sistema lineal J * delta = -F
            delta ← ResolverSistemaLineal3x3(jacobiana, vectorB)
            dx ← delta[0]
            dy ← delta[1]
            dz ← delta[2]
            
            // Calcular nuevo punto
            x_siguiente ← x_actual + dx
            y_siguiente ← y_actual + dy
            z_siguiente ← z_actual + dz
            
            // Calcular errores
            error_x ← |dx|
            error_y ← |dy|
            error_z ← |dz|
            error_global ← max(error_x, error_y, error_z)
            
            // Guardar iteración
            tabla ← tabla ∪ [[iteracion, x_siguiente, y_siguiente, z_siguiente, error_x, error_y, error_z, error_global]]
            
            // Verificar convergencia
            SI error_global ≤ tol ENTONCES
                convergio ← VERDADERO
                exito ← VERDADERO
                x ← x_siguiente
                y ← y_siguiente
                z ← z_siguiente
                mensaje ← "Convergencia alcanzada"
            SINO
                // Preparar siguiente iteración
                x_actual ← x_siguiente
                y_actual ← y_siguiente
                z_actual ← z_siguiente
                iteracion ← iteracion + 1
            FIN SI
            
        CAPTURAR error
            exito ← FALSO
            mensaje ← "Error en iteración " + iteracion
        FIN INTENTAR
    FIN MIENTRAS
    
    // Si no convergió pero no hubo error
    SI NO convergio Y exito ENTONCES
        exito ← FALSO
        ultima_fila ← tabla[último]
        x ← ultima_fila[1]
        y ← ultima_fila[2]
        z ← ultima_fila[3]
        mensaje ← "Máximo de iteraciones alcanzado"
    FIN SI
    
    RETORNAR tabla, (x, y, z), mensaje, exito
FIN

// Función para resolver sistema lineal 3x3
FUNCIÓN ResolverSistemaLineal3x3(A, B)
    n ← 3
    matriz ← copia de A
    vector ← copia de B
    
    // Eliminación gaussiana con pivoteo
    PARA i ← 0 HASTA n-1 HACER
        // Pivoteo parcial
        maxVal ← |matriz[i][i]|
        maxFila ← i
        PARA k ← i+1 HASTA n-1 HACER
            SI |matriz[k][i]| > maxVal ENTONCES
                maxVal ← |matriz[k][i]|
                maxFila ← k
            FIN SI
        FIN PARA
        
        // Intercambiar filas si es necesario
        SI maxFila ≠ i ENTONCES
            PARA k ← i HASTA n-1 HACER
                temp ← matriz[i][k]
                matriz[i][k] ← matriz[maxFila][k]
                matriz[maxFila][k] ← temp
            FIN PARA
            tempVec ← vector[i]
            vector[i] ← vector[maxFila]
            vector[maxFila] ← tempVec
        FIN SI
        
        // Verificar si la matriz es singular
        SI |matriz[i][i]| < 1e-12 ENTONCES
            LANZAR "Sistema lineal singular"
        FIN SI
        
        // Eliminación
        PARA k ← i+1 HASTA n-1 HACER
            factor ← matriz[k][i] / matriz[i][i]
            PARA j ← i HASTA n-1 HACER
                SI j = i ENTONCES
                    matriz[k][j] ← 0.0
                SINO
                    matriz[k][j] ← matriz[k][j] - factor * matriz[i][j]
                FIN SI
            FIN PARA
            vector[k] ← vector[k] - factor * vector[i]
        FIN PARA
    FIN PARA
    
    // Sustitución hacia atrás
    solucion ← [0.0, 0.0, 0.0]
    PARA i ← n-1 HASTA 0 HACER
        solucion[i] ← vector[i]
        PARA j ← i+1 HASTA n-1 HACER
            solucion[i] ← solucion[i] - matriz[i][j] * solucion[j]
        FIN PARA
        solucion[i] ← solucion[i] / matriz[i][i]
    FIN PARA
    
    RETORNAR solucion
FIN FUNCIÓN

// Funciones auxiliares para análisis
FUNCIÓN CalcularDeterminanteJacobiano(x, y, z, derivadas)
    // Evaluar derivadas parciales
    d11 ← df1/dx(x,y,z)
    d12 ← df1/dy(x,y,z)
    d13 ← df1/dz(x,y,z)
    d21 ← df2/dx(x,y,z)
    d22 ← df2/dy(x,y,z)
    d23 ← df2/dz(x,y,z)
    d31 ← df3/dx(x,y,z)
    d32 ← df3/dy(x,y,z)
    d33 ← df3/dz(x,y,z)
    
    // Calcular determinante 3x3
    det ← d11*(d22*d33 - d23*d32) - d12*(d21*d33 - d23*d31) + d13*(d21*d32 - d22*d31)
    RETORNAR det
FIN FUNCIÓN

FUNCIÓN AnalizarConvergencia(x0, y0, z0, f1, f2, f3, derivadas)
    // Calcular determinante jacobiano
    detJ ← CalcularDeterminanteJacobiano(x0, y0, z0, derivadas)
    
    SI |detJ| > 1e-10 ENTONCES
        convergencia_garantizada ← VERDADERO
        tipo_convergencia ← "Cuadrática"
    SINO
        convergencia_garantizada ← FALSO
        tipo_convergencia ← "No garantizada"
    FIN SI
    
    RETORNAR detJ, convergencia_garantizada, tipo_convergencia
FIN FUNCIÓN

FUNCIÓN CalcularErrorRaiz(x, y, z, f1, f2, f3)
    error ← max(|f1(x,y,z)|, |f2(x,y,z)|, |f3(x,y,z)|)
    RETORNAR error
FIN FUNCIÓN
```

## Método de Derivación Numérica

```pseudocode
ALGORITMO MétodoDerivacionNumerica
ENTRADAS:
    n: entero (número de puntos, entre 2 y 7)
    lowerLimit: real (punto en el que se evalúa la derivada)
    h: real (tamaño del paso)
    dataTable: lista de n listas de 2 reales [x, f(x)]
    gradeDerivation: cadena (orden de derivación: "primera", "segunda", ...)
    typeDerivation: cadena (tipo: "adelante", "centrada", "atras")
    dn: entero (número de decimales para el resultado)

SALIDAS:
    resultado: real (valor de la derivada en lowerLimit)
    mensaje: cadena (descripción del resultado o error)
    éxito: booleano (indicador de si el cálculo fue exitoso)

INICIO
    // Validación inicial de parámetros
    SI n < 2 O n > 7 ENTONCES
        mensaje ← "Error: n debe estar entre 2 y 7"
        éxito ← FALSO
        RETORNAR
    FIN SI

    SI h ≤ 0 ENTONCES
        mensaje ← "Error: h debe ser mayor que 0"
        éxito ← FALSO
        RETORNAR
    FIN SI

    // Extraer datos de la tabla
    x ← lista vacía
    f ← lista vacía
    PARA i DESDE 0 HASTA n-1 HACER
        SI dataTable[i] tiene al menos 2 elementos ENTONCES
            x[i] ← dataTable[i][0]
            f[i] ← dataTable[i][1]
        SINO
            mensaje ← "Error: La tabla de datos no tiene la cantidad correcta de puntos"
            éxito ← FALSO
            RETORNAR
        FIN SI
    FIN PARA

    // Convertir parámetros textuales a numéricos
    k ← _convertirOrdenDerivacion(gradeDerivation)
    SI k < 1 O k > 4 ENTONCES
        mensaje ← "Error: El orden de derivación debe estar entre 1 y 4"
        éxito ← FALSO
        RETORNAR
    FIN SI

    t ← _convertirTipoDerivacion(typeDerivation)
    SI t < 1 O t > 3 ENTONCES
        mensaje ← "Error: El tipo de derivación debe ser 1 (adelante), 2 (centrada) o 3 (atrás)"
        éxito ← FALSO
        RETORNAR
    FIN SI

    // Calcular la derivada según el orden solicitado
    resultado ← 0.0
    c ← lowerLimit

    SEGÚN k HACER
        CASO 1:
            resultado ← _calcularPrimeraDerivada(n, t, f, h, c)
        CASO 2:
            resultado ← _calcularSegundaDerivada(n, t, f, h, c)
        CASO 3:
            resultado ← _calcularTerceraDerivada(n, t, f, h, c)
        CASO 4:
            resultado ← _calcularCuartaDerivada(n, t, f, h, c)
    FIN SEGÚN

    // Formatear resultado final
    notacion ← _obtenerNotacionPrima(k)
    mensaje ← "f" + notacion + "(" + c + ") = " + REDONDEAR(resultado, dn)
    éxito ← VERDADERO

    RETORNAR resultado, mensaje, éxito
FIN ALGORITMO

// Funciones auxiliares
FUNCIÓN _convertirOrdenDerivacion(ordenCadena)
    SEGÚN ordenCadena EN MINÚSCULAS
        CASO "primera": RETORNAR 1
        CASO "segunda": RETORNAR 2
        CASO "tercera": RETORNAR 3
        CASO "cuarta": RETORNAR 4
        DEFECTO: 
            valor ← CONVERTIR_A_ENTERO(ordenCadena)
            SI valor ES VÁLIDO ENTONCES RETORNAR valor
            SINO RETORNAR 1
    FIN SEGÚN
FIN FUNCIÓN

FUNCIÓN _convertirTipoDerivacion(tipoCadena)
    SEGÚN tipoCadena EN MINÚSCULAS
        CASO "adelante": RETORNAR 1
        CASO "centrada": RETORNAR 2
        CASO "atras": RETORNAR 3
        DEFECTO:
            valor ← CONVERTIR_A_ENTERO(tipoCadena)
            SI valor ES VÁLIDO ENTONCES RETORNAR valor
            SINO RETORNAR 1
    FIN SEGÚN
FIN FUNCIÓN

FUNCIÓN _obtenerNotacionPrima(orden)
    SEGÚN orden
        CASO 1: RETORNAR "'"
        CASO 2: RETORNAR "''"
        CASO 3: RETORNAR "'''"
        CASO 4: RETORNAR "⁽⁴⁾"
        DEFECTO: RETORNAR ""
    FIN SEGÚN
FIN FUNCIÓN

// Funciones de cálculo para cada orden de derivada
FUNCIÓN _calcularPrimeraDerivada(n, t, f, h, c)
    SEGÚN n
        CASO 3:
            SEGÚN t
                CASO 1: // Adelante
                    RETORNAR (-3.0/(2.0*h))*f[0] + (2.0/h)*f[1] - (1.0/(2.0*h))*f[2]
                CASO 2: // Centrada
                    RETORNAR (-1.0/(2.0*h))*f[0] + (1.0/(2.0*h))*f[2]
                CASO 3: // Atrás
                    hNeg ← -h
                    RETORNAR (-3.0/(2.0*hNeg))*f[2] + (2.0/hNeg)*f[1] - (1.0/(2.0*hNeg))*f[0]
            FIN SEGÚN
        CASO 4:
            SEGÚN t
                CASO 1: // Adelante
                    RETORNAR (-11.0/(6.0*h))*f[0] + (3.0/h)*f[1] - (3.0/(2.0*h))*f[2] + (1.0/(3.0*h))*f[3]
                CASO 3: // Atrás
                    hNeg ← -h
                    RETORNAR (-11.0/(6.0*hNeg))*f[3] + (3.0/hNeg)*f[2] - (3.0/(2.0*hNeg))*f[1] + (1.0/(3.0*hNeg))*f[0]
            FIN SEGÚN
        CASO 5:
            SEGÚN t
                CASO 1: // Adelante
                    RETORNAR (-25.0/(12.0*h))*f[0] + (4.0/h)*f[1] - (3.0/h)*f[2] + (4.0/(3.0*h))*f[3] - (1.0/(4.0*h))*f[4]
                CASO 2: // Centrada
                    RETORNAR (1.0/(12.0*h))*f[0] - (2.0/(3.0*h))*f[1] + (2.0/(3.0*h))*f[3] - (1.0/(12.0*h))*f[4]
                CASO 3: // Atrás
                    hNeg ← -h
                    RETORNAR (-25.0/(12.0*hNeg))*f[4] + (4.0/hNeg)*f[3] - (3.0/hNeg)*f[2] + (4.0/(3.0*hNeg))*f[1] - (1.0/(4.0*hNeg))*f[0]
            FIN SEGÚN
    FIN SEGÚN
    LANZAR ERROR "Combinación no soportada"
FIN FUNCIÓN

FUNCIÓN _calcularSegundaDerivada(n, t, f, h, c)
    SEGÚN n
        CASO 3:
            SEGÚN t
                CASO 1: // Adelante
                    RETORNAR (1.0/(h*h))*f[0] - (2.0/(h*h))*f[1] + (1.0/(h*h))*f[2]
                CASO 2: // Centrada
                    RETORNAR (1.0/(h*h))*f[0] - (2.0/(h*h))*f[1] + (1.0/(h*h))*f[2]
                CASO 3: // Atrás
                    hNeg ← -h
                    RETORNAR (1.0/(hNeg*hNeg))*f[2] - (2.0/(hNeg*hNeg))*f[1] + (1.0/(hNeg*hNeg))*f[0]
            FIN SEGÚN
        CASO 4:
            SEGÚN t
                CASO 1: // Adelante
                    RETORNAR (2.0/(h*h))*f[0] - (5.0/(h*h))*f[1] + (4.0/(h*h))*f[2] - (1.0/(h*h))*f[3]
                CASO 3: // Atrás
                    hNeg ← -h
                    RETORNAR (2.0/(hNeg*hNeg))*f[3] - (5.0/(hNeg*hNeg))*f[2] + (4.0/(hNeg*hNeg))*f[1] - (1.0/(hNeg*hNeg))*f[0]
            FIN SEGÚN
        CASO 5:
            SEGÚN t
                CASO 1: // Adelante
                    RETORNAR (35.0/(12.0*h*h))*f[0] - (26.0/(3.0*h*h))*f[1] + (19.0/(2.0*h*h))*f[2] - (14.0/(3.0*h*h))*f[3] + (11.0/(12.0*h*h))*f[4]
                CASO 2: // Centrada
                    RETORNAR (-1.0/(12.0*h*h))*f[0] + (4.0/(3.0*h*h))*f[1] - (5.0/(2.0*h*h))*f[2] + (4.0/(3.0*h*h))*f[3] - (1.0/(12.0*h*h))*f[4]
                CASO 3: // Atrás
                    hNeg ← -h
                    RETORNAR (35.0/(12.0*hNeg*hNeg))*f[4] - (26.0/(3.0*hNeg*hNeg))*f[3] + (19.0/(2.0*hNeg*hNeg))*f[2] - (14.0/(3.0*hNeg*hNeg))*f[1] + (11.0/(12.0*hNeg*hNeg))*f[0]
            FIN SEGÚN
    FIN SEGÚN
    LANZAR ERROR "Combinación no soportada"
FIN FUNCIÓN

// Funciones _calcularTerceraDerivada y _calcularCuartaDerivada siguen patrón similar
```

## Método de Romberg

```pesudocode
ALGORITMO MetodoRombergEstandar
ENTRADAS:
    funcion: cadena (función a integrar f(x))
    a: real (límite inferior de integración)
    b: real (límite superior de integración)
    n: entero (número de filas en la tabla de Romberg)
    dn: entero (número de decimales para precisión)

SALIDAS:
    resultado: real (valor numérico de la integral)
    mensaje: cadena (estado del cálculo)
    exito: booleano (indicador de éxito)
    tablaRomberg: matriz n×n (tabla completa de resultados)

INICIO
    // PASO 1: Validación de parámetros
    SI funcion = "" ENTONCES
        RETORNAR 0, "Error: función vacía", FALSO, []
    FIN SI

    SI a ≥ b ENTONCES
        RETORNAR 0, "Error: límite inferior ≥ superior", FALSO, []
    FIN SI

    SI n ≤ 0 ENTONCES
        RETORNAR 0, "Error: n debe ser positivo", FALSO, []
    FIN SI

    // PASO 2: Verificar que la función sea evaluable
    INTENTAR
        valorPrueba ← evaluarFuncion(a)
        valorPrueba ← evaluarFuncion(b)
    CAPTURAR ERROR e
        RETORNAR 0, "Error en función: " + e, FALSO, []
    FIN INTENTAR

    // PASO 3: Inicialización
    tablaRomberg ← CREAR_MATRIZ(n, n, 0.0)  // Matriz n×n llena de ceros
    h ← b - a  // Tamaño inicial del paso

    // PASO 4: Primera aproximación (Regla del Trapecio Simple)
    fa ← evaluarFuncion(a)
    fb ← evaluarFuncion(b)
    tablaRomberg[0][0] ← (fa + fb) * h / 2.0

    // PASO 5: Iteraciones principales
    PARA i DESDE 1 HASTA n-1 HACER
        // PASO 5.1: Refinar el tamaño del paso
        h ← h / 2.0
        
        // PASO 5.2: Calcular suma de puntos medios
        sumaPuntosMedios ← 0.0
        numPuntos ← 2^(i-1)  // Número de nuevos puntos medios
        
        PARA k DESDE 1 HASTA numPuntos HACER
            x ← a + (2*k - 1) * h
            sumaPuntosMedios ← sumaPuntosMedios + evaluarFuncion(x)
        FIN PARA
        
        // PASO 5.3: Aplicar Regla del Trapecio Compuesta (columna 0)
        tablaRomberg[i][0] ← 0.5 * tablaRomberg[i-1][0] + h * sumaPuntosMedios
        
        // PASO 5.4: Extrapolación de Richardson (columnas 1 a i)
        PARA j DESDE 1 HASTA i HACER
            factor ← 4.0^j  // Factor de extrapolación
            diferencia ← tablaRomberg[i][j-1] - tablaRomberg[i-1][j-1]
            tablaRomberg[i][j] ← tablaRomberg[i][j-1] + diferencia / (factor - 1.0)
        FIN PARA
    FIN PARA

    // PASO 6: Resultado final
    resultado ← tablaRomberg[n-1][n-1]
    exito ← VERDADERO
    mensaje ← "Integral ≈ " + FORMATO(resultado, dn) + 
              " en " + n + " iteraciones"

    RETORNAR resultado, mensaje, exito, tablaRomberg
FIN ALGORITMO

// Función auxiliar para evaluar la expresión matemática
FUNCIÓN evaluarFuncion(x: real): real
    // Implementación del parser matemático
    // Ejemplo: si funcion = "x^2 + sin(x)", retorna x² + sin(x)
    RETORNAR parser.evaluar(funcion, 'x', x)
FIN FUNCIÓN

// Función auxiliar para crear matriz
FUNCIÓN CREAR_MATRIZ(filas, columnas, valorInicial)
    matriz ← []
    PARA i DESDE 0 HASTA filas-1 HACER
        fila ← []
        PARA j DESDE 0 HASTA columnas-1 HACER
            fila[j] ← valorInicial
        FIN PARA
        matriz[i] ← fila
    FIN PARA
    RETORNAR matriz
FIN FUNCIÓN
```

## Método de la Cuadratura de Gauss

```pseudocode
ALGORITMO MetodoCuadraturaGauss
ENTRADAS:
    funcion: cadena (función a integrar f(x))
    a: real (límite inferior de integración)
    b: real (límite superior de integración)
    n: entero (número de puntos de Gauss)
    dn: entero (número de decimales para precisión)

SALIDAS:
    resultado: real (valor numérico de la integral)
    mensaje: cadena (estado del cálculo)
    exito: booleano (indicador de éxito)
    tablaResultados: matriz n×2 (raíces y pesos)

INICIO
    // PASO 1: Validación de parámetros
    SI a ≥ b ENTONCES
        RETORNAR 0, "Error: límite inferior ≥ superior", FALSO, []
    FIN SI

    SI n ≤ 0 ENTONCES
        RETORNAR 0, "Error: n debe ser mayor que 0", FALSO, []
    FIN SI

    SI dn < 0 ENTONCES
        RETORNAR 0, "Error: dn debe ser no negativo", FALSO, []
    FIN SI

    // PASO 2: Verificar que la función sea evaluable
    INTENTAR
        evaluarFuncion((a + b) / 2)
    CAPTURAR ERROR e
        RETORNAR 0, "Error en función: " + e, FALSO, []
    FIN INTENTAR

    // PASO 3: Inicialización de arreglos
    lcoef ← CREAR_MATRIZ(n+1, n+1, 0.0)  // Coeficientes de Legendre
    lroots ← CREAR_VECTOR(n, 0.0)        // Raíces de Legendre
    weight ← CREAR_VECTOR(n, 0.0)        // Pesos de Gauss

    // PASO 4: Calcular coeficientes de polinomios de Legendre
    lcoef[0][0] ← 1.0
    
    SI n ≥ 1 ENTONCES
        lcoef[1][1] ← 1.0
    FIN SI

    PARA k DESDE 2 HASTA n HACER
        lcoef[k][0] ← -(k - 1) * lcoef[k - 2][0] / k
        PARA i DESDE 1 HASTA k HACER
            numerador ← (2 * k - 1) * lcoef[k - 1][i - 1] - (k - 1) * lcoef[k - 2][i]
            lcoef[k][i] ← numerador / k
        FIN PARA
    FIN PARA

    // PASO 5: Calcular raíces de Legendre usando método de Newton
    PARA i DESDE 1 HASTA n HACER
        // Estimación inicial usando fórmula de aproximación
        x ← COS(π * (i - 0.25) / (n + 0.5))
        x1 ← x
        
        REPETIR
            x1 ← x
            // Método de Newton: x_nuevo = x - P(x)/P'(x)
            x ← x - legeEval(n, x) / legeDiff(n, x)
        HASTA QUE |x - x1| ≤ 1e-15

        lroots[i - 1] ← x
        
        // Calcular peso correspondiente
        derivada ← legeDiff(n, x)
        weight[i - 1] ← 2.0 / ((1.0 - x * x) * derivada * derivada)
    FIN PARA

    // PASO 6: Calcular la integral usando cuadratura de Gauss
    c1 ← (b - a) / 2.0    // Factor de escala
    c2 ← (b + a) / 2.0    // Factor de traslación
    suma ← 0.0

    PARA i DESDE 0 HASTA n-1 HACER
        // Transformar punto de [-1,1] a [a,b]
        x_transformado ← c1 * lroots[i] + c2
        fx ← evaluarFuncion(x_transformado)
        suma ← suma + weight[i] * fx
    FIN PARA

    resultado ← c1 * suma

    // PASO 7: Construir tabla de resultados
    tablaResultados ← []
    PARA i DESDE 0 HASTA n-1 HACER
        tablaResultados[i] ← [lroots[i], weight[i]]
    FIN PARA

    exito ← VERDADERO
    mensaje ← "∫[" + a + ", " + b + "] " + funcion + " dx ≈ " + FORMATO(resultado, dn)

    RETORNAR resultado, mensaje, exito, tablaResultados
FIN ALGORITMO

// Función para evaluar polinomio de Legendre de grado n en x
FUNCIÓN legeEval(n, x)
    s ← lcoef[n][n]  // Coeficiente líder
    
    // Evaluación usando método de Horner
    PARA i DESDE n HASTA 1 (decrementando) HACER
        s ← s * x + lcoef[n][i - 1]
    FIN PARA
    
    RETORNAR s
FIN FUNCIÓN

// Función para evaluar derivada del polinomio de Legendre
FUNCIÓN legeDiff(n, x)
    // Fórmula: P'_n(x) = n * [x * P_n(x) - P_{n-1}(x)] / (x² - 1)
    term1 ← x * legeEval(n, x)
    term2 ← legeEval(n - 1, x)
    RETORNAR n * (term1 - term2) / (x * x - 1.0)
FIN FUNCIÓN
```

## Método de Euler

```pseudocode
ALGORITMO MetodoEulerEDO
ENTRADAS:
    funcion: cadena (función f(t, y) de la EDO: y' = f(t, y))
    t0: real (límite inferior/tiempo inicial)
    tn: real (límite superior/tiempo final)
    n: entero (número de subintervalos)
    y0: real (condición inicial y(t0) = y0)
    dn: entero (número de decimales para precisión)

SALIDAS:
    resultado: real (solución aproximada y(tn))
    mensaje: cadena (estado del cálculo)
    exito: booleano (indicador de éxito)
    tablaResultados: matriz (n+1)×3 [i, tᵢ, yᵢ]

INICIO
    // PASO 1: Validación de parámetros
    SI funcion = "" ENTONCES
        RETORNAR 0, "Error: función vacía", FALSO, []
    FIN SI

    SI t0 ≥ tn ENTONCES
        RETORNAR 0, "Error: tiempo inicial ≥ tiempo final", FALSO, []
    FIN SI

    SI n ≤ 0 ENTONCES
        RETORNAR 0, "Error: n debe ser mayor que 0", FALSO, []
    FIN SI

    SI dn < 0 ENTONCES
        RETORNAR 0, "Error: dn debe ser no negativo", FALSO, []
    FIN SI

    // PASO 2: Verificar que la función sea válida
    INTENTAR
        SI NO validarFuncionEuler(funcion) ENTONCES
            RETORNAR 0, "Error: función f(t, y) no válida", FALSO, []
        FIN SI

        // Probar evaluación en punto inicial
        valorPrueba ← evaluarFuncionTY(funcion, t0, y0)
        SI valorPrueba ES NaN O INFINITO ENTONCES
            RETORNAR 0, "Error: función no válida en punto inicial", FALSO, []
        FIN SI
    CAPTURAR ERROR e
        RETORNAR 0, "Error al validar función: " + e, FALSO, []
    FIN INTENTAR

    // PASO 3: Inicialización
    h ← (tn - t0) / n          // Tamaño del paso
    t ← t0                     // Tiempo actual
    y ← y0                     // Solución actual
    tablaResultados ← []       // Inicializar tabla vacía

    // PASO 4: Guardar condición inicial
    filaInicial ← [0, t, y]
    tablaResultados[0] ← filaInicial

    // PASO 5: Iteraciones del método de Euler
    PARA i DESDE 1 HASTA n HACER
        // PASO 5.1: Evaluar f(t, y) en el punto actual
        f_ty ← evaluarFuncionTY(funcion, t, y)
        
        // PASO 5.2: Aplicar fórmula de Euler
        y ← y + h * f_ty      // y_{i+1} = y_i + h * f(t_i, y_i)
        t ← t0 + i * h        // t_{i+1} = t_i + h
        
        // PASO 5.3: Guardar resultado en tabla
        filaActual ← [i, t, y]
        tablaResultados[i] ← filaActual
    FIN PARA

    // PASO 6: Resultados finales
    resultado ← y
    exito ← VERDADERO
    mensaje ← "Solución: y(" + t + ") = " + FORMATO(y, dn) + 
              " (h = " + FORMATO(h, dn) + ", n = " + n + ")"

    RETORNAR resultado, mensaje, exito, tablaResultados
FIN ALGORITMO

// Función auxiliar para evaluar f(t, y)
FUNCIÓN evaluarFuncionTY(funcion, t, y)
    // Usar parser matemático para evaluar función de dos variables
    RETORNAR parser.evaluarFuncionTY(funcion, t, y)
FIN FUNCIÓN

// Función auxiliar para validar sintaxis de función
FUNCIÓN validarFuncionEuler(funcion)
    // Verificar que la función use variables t e y
    // y tenga sintaxis matemática válida
    RETORNAR parser.validarFuncionEuler(funcion)
FIN FUNCIÓN

// Función para calcular error comparativo con solución exacta
FUNCIÓN calcularError(solucionExacta, tablaResultados)
    SI tablaResultados ESTÁ VACÍA ENTONCES
        RETORNAR NaN
    FIN SI
    
    ultimaFila ← tablaResultados[ÚLTIMO]
    t_final ← ultimaFila[1]
    y_aproximado ← ultimaFila[2]
    
    INTENTAR
        y_exacto ← evaluarFuncionT(solucionExacta, t_final)
        error ← |y_aproximado - y_exacto|
        RETORNAR error
    CAPTURAR ERROR
        RETORNAR NaN
    FIN INTENTAR
FIN FUNCIÓN

// Función para análisis del método
FUNCIÓN analizarMetodo(t0, tn, n, funcion)
    analisis ← MAPA_VACÍO
    h ← (tn - t0) / n
    
    analisis['tamaño_paso'] ← h
    analisis['numero_pasos'] ← n
    analisis['error_local'] ← "O(h²)"
    analisis['error_global'] ← "O(h)"
    analisis['orden_metodo'] ← 1
    analisis['tipo_metodo'] ← "Explícito de un paso"
    
    SI h > 0.1 ENTONCES
        analisis['advertencia'] ← "Paso h grande - precisión reducida"
        analisis['recomendacion'] ← "Aumentar n para mejor precisión"
    SINO
        analisis['advertencia'] ← "Ninguna"
        analisis['recomendacion'] ← "Paso h adecuado"
    FIN SI
    
    RETORNAR analisis
FIN FUNCIÓN

// Función para generar campo de direcciones
FUNCIÓN generarCampoDirecciones(funcion, t0, tn, y_min, y_max, num_puntos)
    campo ← []
    paso_t ← (tn - t0) / num_puntos
    paso_y ← (y_max - y_min) / num_puntos
    
    PARA i DESDE 0 HASTA num_puntos HACER
        t_actual ← t0 + i * paso_t
        PARA j DESDE 0 HASTA num_puntos HACER
            y_actual ← y_min + j * paso_y
            INTENTAR
                pendiente ← evaluarFuncionTY(funcion, t_actual, y_actual)
                SI pendiente ES VÁLIDA ENTONCES
                    punto ← {
                        't': t_actual,
                        'y': y_actual,
                        'pendiente': pendiente,
                        'dx': 0.1,
                        'dy': 0.1 * pendiente
                    }
                    campo.AGREGAR(punto)
                FIN SI
            CAPTURAR ERROR
                // Ignorar punto no evaluable
            FIN INTENTAR
        FIN PARA
    FIN PARA
    
    RETORNAR campo
FIN FUNCIÓN
```

## Método de Runge-Kutta de Cuarto Orden

```pseudocode
ALGORITMO MetodoRungeKuttaCuartoOrden
ENTRADAS:
    funcion: cadena (función f(t, y) de la EDO: y' = f(t, y))
    t0: real (límite inferior/tiempo inicial)
    tn: real (límite superior/tiempo final)
    n: entero (número de subintervalos)
    y0: real (condición inicial y(t0) = y0)
    dn: entero (número de decimales para precisión)

SALIDAS:
    resultado: real (solución aproximada y(tn))
    mensaje: cadena (estado del cálculo)
    exito: booleano (indicador de éxito)
    tablaResultados: matriz (n+1)×7 [i, tᵢ, yᵢ, k1, k2, k3, k4]

INICIO
    // PASO 1: Validación de parámetros
    SI funcion = "" ENTONCES
        RETORNAR 0, "Error: función vacía", FALSO, []
    FIN SI

    SI t0 ≥ tn ENTONCES
        RETORNAR 0, "Error: tiempo inicial ≥ tiempo final", FALSO, []
    FIN SI

    SI n ≤ 0 ENTONCES
        RETORNAR 0, "Error: n debe ser mayor que 0", FALSO, []
    FIN SI

    SI dn < 0 ENTONCES
        RETORNAR 0, "Error: dn debe ser no negativo", FALSO, []
    FIN SI

    // PASO 2: Verificar que la función sea válida
    INTENTAR
        SI NO validarFuncionEuler(funcion) ENTONCES
            RETORNAR 0, "Error: función f(t, y) no válida", FALSO, []
        FIN SI

        // Probar evaluación en punto inicial
        valorPrueba ← evaluarFuncionTY(funcion, t0, y0)
        SI valorPrueba ES NaN O INFINITO ENTONCES
            RETORNAR 0, "Error: función no válida en punto inicial", FALSO, []
        FIN SI
    CAPTURAR ERROR e
        RETORNAR 0, "Error al validar función: " + e, FALSO, []
    FIN INTENTAR

    // PASO 3: Inicialización
    h ← (tn - t0) / n          // Tamaño del paso
    t ← t0                     // Tiempo actual
    y ← y0                     // Solución actual
    tablaResultados ← []       // Inicializar tabla vacía

    // PASO 4: Guardar condición inicial
    filaInicial ← [0, t, y, 0, 0, 0, 0]
    tablaResultados[0] ← filaInicial

    // PASO 5: Iteraciones del método de Runge-Kutta
    PARA i DESDE 1 HASTA n HACER
        // PASO 5.1: Calcular constantes k1, k2, k3, k4
        k1 ← h * evaluarFuncionTY(funcion, t, y)
        k2 ← h * evaluarFuncionTY(funcion, t + h/2, y + k1/2)
        k3 ← h * evaluarFuncionTY(funcion, t + h/2, y + k2/2)
        k4 ← h * evaluarFuncionTY(funcion, t + h, y + k3)
        
        // PASO 5.2: Aplicar fórmula de Runge-Kutta
        y ← y + (k1 + 2*k2 + 2*k3 + k4)/6
        t ← t0 + i * h
        
        // PASO 5.3: Guardar resultado en tabla
        filaActual ← [i, t, y, k1, k2, k3, k4]
        tablaResultados[i] ← filaActual
    FIN PARA

    // PASO 6: Resultados finales
    resultado ← y
    exito ← VERDADERO
    mensaje ← "Solución: y(" + t + ") = " + FORMATO(y, dn) + 
              " (h = " + FORMATO(h, dn) + ", n = " + n + ")"

    RETORNAR resultado, mensaje, exito, tablaResultados
FIN ALGORITMO

// Función para calcular error relativo
FUNCIÓN calcularErrorRelativo(solucionExacta, tablaResultados)
    SI tablaResultados ESTÁ VACÍA ENTONCES
        RETORNAR NaN
    FIN SI
    
    ultimaFila ← tablaResultados[ÚLTIMO]
    t_final ← ultimaFila[1]
    y_aproximado ← ultimaFila[2]
    
    INTENTAR
        y_exacto ← evaluarFuncionT(solucionExacta, t_final)
        SI y_exacto = 0 ENTONCES
            RETORNAR INFINITO
        FIN SI
        error_relativo ← (|y_aproximado - y_exacto| / |y_exacto|) * 100
        RETORNAR error_relativo
    CAPTURAR ERROR
        RETORNAR NaN
    FIN INTENTAR
FIN FUNCIÓN

// Función para obtener constantes RK de una iteración específica
FUNCIÓN obtenerConstantesRK(tablaResultados, iteracion)
    SI tablaResultados ESTÁ VACÍA O iteracion < 0 O iteracion ≥ LONGITUD(tablaResultados) ENTONCES
        RETORNAR {}
    FIN SI
    
    fila ← tablaResultados[iteracion]
    constantes ← {}
    SI LONGITUD(fila) ≥ 7 ENTONCES
        constantes['k1'] ← fila[3]
        constantes['k2'] ← fila[4]
        constantes['k3'] ← fila[5]
        constantes['k4'] ← fila[6]
    FIN SI
    
    RETORNAR constantes
FIN FUNCIÓN

// Función para generar campo de direcciones
FUNCIÓN generarCampoDirecciones(funcion, t0, tn, y_min, y_max, num_puntos)
    campo ← []
    paso_t ← (tn - t0) / num_puntos
    paso_y ← (y_max - y_min) / num_puntos
    
    PARA i DESDE 0 HASTA num_puntos HACER
        t_actual ← t0 + i * paso_t
        PARA j DESDE 0 HASTA num_puntos HACER
            y_actual ← y_min + j * paso_y
            INTENTAR
                pendiente ← evaluarFuncionTY(funcion, t_actual, y_actual)
                SI pendiente ES VÁLIDA ENTONCES
                    punto ← {
                        't': t_actual,
                        'y': y_actual,
                        'pendiente': pendiente,
                        'dx': 0.1,
                        'dy': 0.1 * pendiente
                    }
                    campo.AGREGAR(punto)
                FIN SI
            CAPTURAR ERROR
                // Ignorar punto no evaluable
            FIN INTENTAR
        FIN PARA
    FIN PARA
    
    RETORNAR campo
FIN FUNCIÓN
```

## Método de Adams-Bashforth-Moulton de Cuarto Orden

```pseudocode
ALGORITMO MetodoAdamsPredictorCorrector
ENTRADAS:
    funcion: cadena (función f(t, y) de la EDO: y' = f(t, y))
    t0: real (límite inferior/tiempo inicial)
    tn: real (límite superior/tiempo final)
    n: entero (número de subintervalos)
    y0: real (condición inicial y(t0) = y0)
    dn: entero (número de decimales para precisión)

SALIDAS:
    resultado: real (solución aproximada y(tn))
    mensaje: cadena (estado del cálculo)
    exito: booleano (indicador de éxito)
    tablaResultados: matriz (n+1)×9 [i, tᵢ, yᵢ, k1, k2, k3, k4, predictor, corrector]

INICIO
    // PASO 1: Validación de parámetros
    SI funcion = "" ENTONCES
        RETORNAR 0, "Error: función vacía", FALSO, []
    FIN SI

    SI t0 ≥ tn ENTONCES
        RETORNAR 0, "Error: tiempo inicial ≥ tiempo final", FALSO, []
    FIN SI

    SI n ≤ 0 ENTONCES
        RETORNAR 0, "Error: n debe ser mayor que 0", FALSO, []
    FIN SI

    SI n < 4 ENTONCES
        RETORNAR 0, "Error: método requiere al menos 4 subintervalos", FALSO, []
    FIN SI

    SI dn < 0 ENTONCES
        RETORNAR 0, "Error: dn debe ser no negativo", FALSO, []
    FIN SI

    // PASO 2: Verificar que la función sea válida
    INTENTAR
        SI NO validarFuncionEuler(funcion) ENTONCES
            RETORNAR 0, "Error: función f(t, y) no válida", FALSO, []
        FIN SI

        // Probar evaluación en punto inicial
        valorPrueba ← evaluarFuncionTY(funcion, t0, y0)
        SI valorPrueba ES NaN O INFINITO ENTONCES
            RETORNAR 0, "Error: función no válida en punto inicial", FALSO, []
        FIN SI
    CAPTURAR ERROR e
        RETORNAR 0, "Error al validar función: " + e, FALSO, []
    FIN INTENTAR

    // PASO 3: Inicialización
    h ← (tn - t0) / n          // Tamaño del paso
    tablaResultados ← []       // Inicializar tabla vacía

    // Arreglos para almacenar últimos 4 valores
    t_valores ← [t0, 0, 0, 0]
    y_valores ← [y0, 0, 0, 0]

    // PASO 4: Guardar condición inicial
    filaInicial ← [0, t0, y0, 0, 0, 0, 0, 0, 0]
    tablaResultados[0] ← filaInicial

    // PASO 5: Inicialización con Runge-Kutta de 4º orden (primeros 4 puntos)
    PARA i DESDE 1 HASTA 3 HACER
        t_actual ← t_valores[i-1]
        y_actual ← y_valores[i-1]

        // Calcular constantes RK4
        k1 ← h * evaluarFuncionTY(funcion, t_actual, y_actual)
        k2 ← h * evaluarFuncionTY(funcion, t_actual + h/2, y_actual + k1/2)
        k3 ← h * evaluarFuncionTY(funcion, t_actual + h/2, y_actual + k2/2)
        k4 ← h * evaluarFuncionTY(funcion, t_actual + h, y_actual + k3)
        
        // Aplicar fórmula RK4
        y_nuevo ← y_actual + (k1 + 2*k2 + 2*k3 + k4)/6
        t_nuevo ← t0 + i * h
        
        // Almacenar valores
        t_valores[i] ← t_nuevo
        y_valores[i] ← y_nuevo
        
        // Guardar en tabla
        filaRK ← [i, t_nuevo, y_nuevo, k1, k2, k3, k4, 0, 0]
        tablaResultados[i] ← filaRK
    FIN PARA

    // PASO 6: Método Adams-Bashforth-Moulton para puntos restantes
    PARA i DESDE 4 HASTA n HACER
        t_actual ← t0 + i * h
        
        // PASO 6.1: Predictor - Adams-Bashforth de 4º orden
        f3 ← evaluarFuncionTY(funcion, t_valores[3], y_valores[3])
        f2 ← evaluarFuncionTY(funcion, t_valores[2], y_valores[2])
        f1 ← evaluarFuncionTY(funcion, t_valores[1], y_valores[1])
        f0 ← evaluarFuncionTY(funcion, t_valores[0], y_valores[0])
        
        predictor ← y_valores[3] + h * (55*f3 - 59*f2 + 37*f1 - 9*f0) / 24.0
        
        // PASO 6.2: Corrector - Adams-Moulton de 4º orden
        f_pred ← evaluarFuncionTY(funcion, t_actual, predictor)
        corrector ← y_valores[3] + h * (9*f_pred + 19*f3 - 5*f2 + f1) / 24.0
        
        // PASO 6.3: Guardar resultado en tabla
        filaAdams ← [i, t_actual, corrector, 0, 0, 0, 0, predictor, corrector]
        tablaResultados[i] ← filaAdams
        
        // PASO 6.4: Actualizar arreglos para siguiente iteración
        t_valores[0] ← t_valores[1]
        t_valores[1] ← t_valores[2]
        t_valores[2] ← t_valores[3]
        t_valores[3] ← t_actual
        
        y_valores[0] ← y_valores[1]
        y_valores[1] ← y_valores[2]
        y_valores[2] ← y_valores[3]
        y_valores[3] ← corrector
    FIN PARA

    // PASO 7: Resultados finales
    resultado ← y_valores[3]
    exito ← VERDADERO
    mensaje ← "Solución: y(" + tn + ") = " + FORMATO(resultado, dn) + 
              " (h = " + FORMATO(h, dn) + ", n = " + n + ")"

    RETORNAR resultado, mensaje, exito, tablaResultados
FIN ALGORITMO

// Función para calcular error comparativo con solución exacta
FUNCIÓN calcularError(solucionExacta, tablaResultados)
    SI tablaResultados ESTÁ VACÍA ENTONCES
        RETORNAR NaN
    FIN SI
    
    ultimaFila ← tablaResultados[ÚLTIMO]
    t_final ← ultimaFila[1]
    y_aproximado ← ultimaFila[2]
    
    INTENTAR
        y_exacto ← evaluarFuncionT(solucionExacta, t_final)
        error ← |y_aproximado - y_exacto|
        RETORNAR error
    CAPTURAR ERROR
        RETORNAR NaN
    FIN INTENTAR
FIN FUNCIÓN

// Función para calcular error relativo
FUNCIÓN calcularErrorRelativo(solucionExacta, tablaResultados)
    SI tablaResultados ESTÁ VACÍA ENTONCES
        RETORNAR NaN
    FIN SI
    
    ultimaFila ← tablaResultados[ÚLTIMO]
    t_final ← ultimaFila[1]
    y_aproximado ← ultimaFila[2]
    
    INTENTAR
        y_exacto ← evaluarFuncionT(solucionExacta, t_final)
        SI y_exacto = 0 ENTONCES
            RETORNAR INFINITO
        FIN SI
        error_relativo ← (|y_aproximado - y_exacto| / |y_exacto|) * 100
        RETORNAR error_relativo
    CAPTURAR ERROR
        RETORNAR NaN
    FIN INTENTAR
FIN FUNCIÓN
```

## Método de Runge-Kutta para Dos Variables

```pseudocode
ALGORITMO MetodoRungeKuttaSistemas2EDO
ENTRADAS:
    f1: cadena (función f1(t, u1, u2) de la primera EDO: du1/dt = f1(t, u1, u2))
    f2: cadena (función f2(t, u1, u2) de la segunda EDO: du2/dt = f2(t, u1, u2))
    t0: real (límite inferior/tiempo inicial)
    tn: real (límite superior/tiempo final)
    u10: real (condición inicial u1(t0) = u10)
    u20: real (condición inicial u2(t0) = u20)
    n: entero (número de subintervalos)
    dn: entero (número de decimales para precisión)

SALIDAS:
    resultado: real (solución u1(tn) - valor principal)
    mensaje: cadena (estado del cálculo)
    exito: booleano (indicador de éxito)
    tablaResultados: matriz (n+1)×4 [i, tᵢ, u1ᵢ, u2ᵢ]

INICIO
    // PASO 1: Validación de parámetros
    SI f1 = "" O f2 = "" ENTONCES
        RETORNAR 0, "Error: deben proporcionarse ambas funciones", FALSO, []
    FIN SI

    SI t0 ≥ tn ENTONCES
        RETORNAR 0, "Error: tiempo inicial ≥ tiempo final", FALSO, []
    FIN SI

    SI n ≤ 0 ENTONCES
        RETORNAR 0, "Error: n debe ser mayor que 0", FALSO, []
    FIN SI

    SI dn < 0 ENTONCES
        RETORNAR 0, "Error: dn debe ser no negativo", FALSO, []
    FIN SI

    // PASO 2: Verificar que las funciones sean válidas
    INTENTAR
        puntosPrueba ← [t0, u10, u20, tn, u10, u20]
        SI NO validarFuncion3Variables(f1, puntosPrueba) O 
           NO validarFuncion3Variables(f2, puntosPrueba) ENTONCES
            RETORNAR 0, "Error: funciones no válidas en el dominio", FALSO, []
        FIN SI
    CAPTURAR ERROR e
        RETORNAR 0, "Error al validar funciones: " + e, FALSO, []
    FIN INTENTAR

    // PASO 3: Inicialización
    h ← (tn - t0) / n          // Tamaño del paso
    t ← t0                     // Tiempo actual
    u1 ← u10                   // Solución actual u1
    u2 ← u20                   // Solución actual u2
    tablaResultados ← []       // Inicializar tabla vacía

    // PASO 4: Guardar condiciones iniciales
    filaInicial ← ["0", t, u1, u2]
    tablaResultados[0] ← filaInicial

    // PASO 5: Iteraciones del método de Runge-Kutta para sistemas
    PARA i DESDE 1 HASTA n HACER
        // PASO 5.1: Calcular constantes k para el sistema
        // Primer conjunto de constantes (k1)
        k11 ← h * evaluarFuncion3Variables(f1, t, u1, u2)
        k12 ← h * evaluarFuncion3Variables(f2, t, u1, u2)
        
        // Segundo conjunto de constantes (k2)
        k21 ← h * evaluarFuncion3Variables(f1, t + h/2, u1 + k11/2, u2 + k12/2)
        k22 ← h * evaluarFuncion3Variables(f2, t + h/2, u1 + k11/2, u2 + k12/2)
        
        // Tercer conjunto de constantes (k3)
        k31 ← h * evaluarFuncion3Variables(f1, t + h/2, u1 + k21/2, u2 + k22/2)
        k32 ← h * evaluarFuncion3Variables(f2, t + h/2, u1 + k21/2, u2 + k22/2)
        
        // Cuarto conjunto de constantes (k4)
        k41 ← h * evaluarFuncion3Variables(f1, t + h, u1 + k31, u2 + k32)
        k42 ← h * evaluarFuncion3Variables(f2, t + h, u1 + k31, u2 + k32)
        
        // PASO 5.2: Aplicar fórmulas de Runge-Kutta
        u1 ← u1 + (k11 + 2*k21 + 2*k31 + k41) / 6
        u2 ← u2 + (k12 + 2*k22 + 2*k32 + k42) / 6
        t ← t0 + i * h
        
        // PASO 5.3: Guardar resultado en tabla
        filaActual ← [CADENA(i), t, u1, u2]
        tablaResultados[i] ← filaActual
    FIN PARA

    // PASO 6: Resultados finales
    resultado ← u1
    exito ← VERDADERO
    mensaje ← "Solución completada en " + n + " iteraciones\n" +
              "u1(" + t + ") = " + FORMATO(u1, dn) + "\n" +
              "u2(" + t + ") = " + FORMATO(u2, dn)

    RETORNAR resultado, mensaje, exito, tablaResultados
FIN ALGORITMO

```

## Método de Runge-Kutta para Tres Variables

```pseudocode
ALGORITMO MetodoRungeKuttaSistemas3EDO
ENTRADAS:
    f1: cadena (función f1(t, u1, u2, u3) de la primera EDO: du1/dt = f1(t, u1, u2, u3))
    f2: cadena (función f2(t, u1, u2, u3) de la segunda EDO: du2/dt = f2(t, u1, u2, u3))
    f3: cadena (función f3(t, u1, u2, u3) de la tercera EDO: du3/dt = f3(t, u1, u2, u3))
    t0: real (límite inferior/tiempo inicial)
    tn: real (límite superior/tiempo final)
    u10: real (condición inicial u1(t0) = u10)
    u20: real (condición inicial u2(t0) = u20)
    u30: real (condición inicial u3(t0) = u30)
    n: entero (número de subintervalos)
    dn: entero (número de decimales para precisión)

SALIDAS:
    resultado: real (solución u1(tn) - valor principal)
    mensaje: cadena (estado del cálculo)
    exito: booleano (indicador de éxito)
    tablaResultados: matriz (n+1)×5 [i, tᵢ, u1ᵢ, u2ᵢ, u3ᵢ]

INICIO
    // PASO 1: Validación de parámetros
    SI f1 = "" O f2 = "" O f3 = "" ENTONCES
        RETORNAR 0, "Error: deben proporcionarse las tres funciones", FALSO, []
    FIN SI

    SI t0 ≥ tn ENTONCES
        RETORNAR 0, "Error: tiempo inicial ≥ tiempo final", FALSO, []
    FIN SI

    SI n ≤ 0 ENTONCES
        RETORNAR 0, "Error: n debe ser mayor que 0", FALSO, []
    FIN SI

    SI dn < 0 ENTONCES
        RETORNAR 0, "Error: dn debe ser no negativo", FALSO, []
    FIN SI

    // PASO 2: Verificar que las funciones sean válidas
    INTENTAR
        puntosPrueba ← [t0, u10, u20, u30, tn, u10, u20, u30]
        SI NO validarFuncion4Variables(f1, puntosPrueba) O 
           NO validarFuncion4Variables(f2, puntosPrueba) O
           NO validarFuncion4Variables(f3, puntosPrueba) ENTONCES
            RETORNAR 0, "Error: funciones no válidas en el dominio", FALSO, []
        FIN SI
    CAPTURAR ERROR e
        RETORNAR 0, "Error al validar funciones: " + e, FALSO, []
    FIN INTENTAR

    // PASO 3: Inicialización
    h ← (tn - t0) / n          // Tamaño del paso
    t ← t0                     // Tiempo actual
    u1 ← u10                   // Solución actual u1
    u2 ← u20                   // Solución actual u2
    u3 ← u30                   // Solución actual u3
    tablaResultados ← []       // Inicializar tabla vacía

    // PASO 4: Guardar condiciones iniciales
    filaInicial ← ["0", t, u1, u2, u3]
    tablaResultados[0] ← filaInicial

    // PASO 5: Iteraciones del método de Runge-Kutta para sistemas de 3 ecuaciones
    PARA i DESDE 1 HASTA n HACER
        // PASO 5.1: Calcular constantes k para el sistema de 3 ecuaciones
        // Primer conjunto de constantes (k1)
        k11 ← h * evaluarFuncion4Variables(f1, t, u1, u2, u3)
        k12 ← h * evaluarFuncion4Variables(f2, t, u1, u2, u3)
        k13 ← h * evaluarFuncion4Variables(f3, t, u1, u2, u3)
        
        // Segundo conjunto de constantes (k2)
        k21 ← h * evaluarFuncion4Variables(f1, t + h/2, u1 + k11/2, u2 + k12/2, u3 + k13/2)
        k22 ← h * evaluarFuncion4Variables(f2, t + h/2, u1 + k11/2, u2 + k12/2, u3 + k13/2)
        k23 ← h * evaluarFuncion4Variables(f3, t + h/2, u1 + k11/2, u2 + k12/2, u3 + k13/2)
        
        // Tercer conjunto de constantes (k3)
        k31 ← h * evaluarFuncion4Variables(f1, t + h/2, u1 + k21/2, u2 + k22/2, u3 + k23/2)
        k32 ← h * evaluarFuncion4Variables(f2, t + h/2, u1 + k21/2, u2 + k22/2, u3 + k23/2)
        k33 ← h * evaluarFuncion4Variables(f3, t + h/2, u1 + k21/2, u2 + k22/2, u3 + k23/2)
        
        // Cuarto conjunto de constantes (k4)
        k41 ← h * evaluarFuncion4Variables(f1, t + h, u1 + k31, u2 + k32, u3 + k33)
        k42 ← h * evaluarFuncion4Variables(f2, t + h, u1 + k31, u2 + k32, u3 + k33)
        k43 ← h * evaluarFuncion4Variables(f3, t + h, u1 + k31, u2 + k32, u3 + k33)
        
        // PASO 5.2: Aplicar fórmulas de Runge-Kutta
        u1 ← u1 + (k11 + 2*k21 + 2*k31 + k41) / 6
        u2 ← u2 + (k12 + 2*k22 + 2*k32 + k42) / 6
        u3 ← u3 + (k13 + 2*k23 + 2*k33 + k43) / 6
        t ← t0 + i * h
        
        // PASO 5.3: Guardar resultado en tabla
        filaActual ← [CADENA(i), t, u1, u2, u3]
        tablaResultados[i] ← filaActual
    FIN PARA

    // PASO 6: Resultados finales
    resultado ← u1
    exito ← VERDADERO
    mensaje ← "Solución completada en " + n + " iteraciones\n" +
              "u1(" + t + ") = " + FORMATO(u1, dn) + "\n" +
              "u2(" + t + ") = " + FORMATO(u2, dn) + "\n" +
              "u3(" + t + ") = " + FORMATO(u3, dn)

    RETORNAR resultado, mensaje, exito, tablaResultados
FIN ALGORITMO
```

## Método del Disparo Lineal

```pseudocode
ALGORITMO MetodoDisparoLineal
ENTRADAS:
    p_x: cadena (función p(x) en el término y')
    q_x: cadena (función q(x) en el término y)
    r_x: cadena (función r(x) en el término independiente)
    a: real (límite inferior del dominio)
    b: real (límite superior del dominio)
    alpha: real (condición de frontera en a: y(a) = alpha)
    beta: real (condición de frontera en b: y(b) = beta)
    n: entero (número de subintervalos)
    dn: entero (número de decimales para precisión)

SALIDAS:
    resultado: real (solución aproximada y(b))
    mensaje: cadena (estado del cálculo)
    exito: booleano (indicador de éxito)
    tablaResultados: matriz (n+1)×4 [i, xᵢ, y(xᵢ), y'(xᵢ)]

INICIO
    // PASO 1: Validación de parámetros
    SI p_x = "" O q_x = "" O r_x = "" ENTONCES
        RETORNAR 0, "Error: Las funciones p(x), q(x) y r(x) son requeridas", FALSO, []
    FIN SI

    SI n ≤ 0 ENTONCES
        RETORNAR 0, "Error: n debe ser mayor que 0", FALSO, []
    FIN SI

    SI a ≥ b ENTONCES
        RETORNAR 0, "Error: El límite inferior debe ser menor que el superior", FALSO, []
    FIN SI

    SI dn < 0 ENTONCES
        RETORNAR 0, "Error: El número de decimales debe ser no negativo", FALSO, []
    FIN SI

    // PASO 2: Validar que las funciones sean evaluables
    INTENTAR
        puntoPrueba ← (a + b) / 2
        SI NO validarFuncionEnPunto(p_x, 'x', puntoPrueba) O 
           NO validarFuncionEnPunto(q_x, 'x', puntoPrueba) O
           NO validarFuncionEnPunto(r_x, 'x', puntoPrueba) ENTONCES
            RETORNAR 0, "Error: Las funciones no son válidas en el intervalo", FALSO, []
        FIN SI
    CAPTURAR ERROR e
        RETORNAR 0, "Error al validar las funciones: " + e, FALSO, []
    FIN INTENTAR

    // PASO 3: Inicialización
    h ← (b - a) / n
    tablaResultados ← []       // Inicializar tabla vacía

    // Matrices para almacenar soluciones U y V
    U ← CREAR_MATRIZ(2, n)     // [U, U'] para solución particular
    V ← CREAR_MATRIZ(2, n)     // [V, V'] para solución homogénea

    // Condiciones iniciales
    U_actual ← alpha           // U(a) = alpha
    U_derivada ← 0.0           // U'(a) = 0
    V_actual ← 0.0             // V(a) = 0
    V_derivada ← 1.0           // V'(a) = 1

    // PASO 4: Resolver problemas de valor inicial para U y V usando RK4
    PARA i DESDE 1 HASTA n HACER
        x_actual ← a + (i - 1) * h
        T ← x_actual + 0.5 * h

        // PASO 4.1: Runge-Kutta para U (solución particular)
        k11 ← h * U_derivada
        k12 ← h * (evaluarFuncion(p_x, x_actual) * U_derivada + 
                   evaluarFuncion(q_x, x_actual) * U_actual + 
                   evaluarFuncion(r_x, x_actual))

        k21 ← h * (U_derivada + 0.5 * k12)
        k22 ← h * (evaluarFuncion(p_x, T) * (U_derivada + 0.5 * k12) + 
                   evaluarFuncion(q_x, T) * (U_actual + 0.5 * k11) + 
                   evaluarFuncion(r_x, T))

        k31 ← h * (U_derivada + 0.5 * k22)
        k32 ← h * (evaluarFuncion(p_x, T) * (U_derivada + 0.5 * k22) + 
                   evaluarFuncion(q_x, T) * (U_actual + 0.5 * k21) + 
                   evaluarFuncion(r_x, T))

        T ← x_actual + h
        k41 ← h * (U_derivada + k32)
        k42 ← h * (evaluarFuncion(p_x, T) * (U_derivada + k32) + 
                   evaluarFuncion(q_x, T) * (U_actual + k31) + 
                   evaluarFuncion(r_x, T))

        U_actual ← U_actual + (k11 + 2*k21 + 2*k31 + k41) / 6
        U_derivada ← U_derivada + (k12 + 2*k22 + 2*k32 + k42) / 6

        // Almacenar U
        U[0][i-1] ← U_actual
        U[1][i-1] ← U_derivada

        // PASO 4.2: Runge-Kutta para V (solución homogénea)
        k11 ← h * V_derivada
        k12 ← h * (evaluarFuncion(p_x, x_actual) * V_derivada + 
                   evaluarFuncion(q_x, x_actual) * V_actual)

        T ← x_actual + 0.5 * h
        k21 ← h * (V_derivada + 0.5 * k12)
        k22 ← h * (evaluarFuncion(p_x, T) * (V_derivada + 0.5 * k12) + 
                   evaluarFuncion(q_x, T) * (V_actual + 0.5 * k11))

        k31 ← h * (V_derivada + 0.5 * k22)
        k32 ← h * (evaluarFuncion(p_x, T) * (V_derivada + 0.5 * k22) + 
                   evaluarFuncion(q_x, T) * (V_actual + 0.5 * k21))

        T ← x_actual + h
        k41 ← h * (V_derivada + k32)
        k42 ← h * (evaluarFuncion(p_x, T) * (V_derivada + k32) + 
                   evaluarFuncion(q_x, T) * (V_actual + k31))

        V_actual ← V_actual + (k11 + 2*k21 + 2*k31 + k41) / 6
        V_derivada ← V_derivada + (k12 + 2*k22 + 2*k32 + k42) / 6

        // Almacenar V
        V[0][i-1] ← V_actual
        V[1][i-1] ← V_derivada
    FIN PARA

    // PASO 5: Calcular factor de ajuste Z
    Z ← (beta - U[0][n-1]) / V[0][n-1]

    // PASO 6: Construir solución final y(x) = U(x) + Z * V(x)
    // Punto inicial
    filaInicial ← [0.0, a, alpha, 0.0 + Z * 1.0]  // y'(a) = U'(a) + Z * V'(a)
    tablaResultados[0] ← filaInicial

    // Puntos restantes
    PARA i DESDE 1 HASTA n HACER
        x ← a + i * h
        y_x ← U[0][i-1] + Z * V[0][i-1]      // y(x) = U(x) + Z * V(x)
        y_derivada ← U[1][i-1] + Z * V[1][i-1] // y'(x) = U'(x) + Z * V'(x)

        fila ← [i, x, y_x, y_derivada]
        tablaResultados[i] ← fila
    FIN PARA

    // PASO 7: Resultados finales
    resultado ← tablaResultados[n][2]  // y(b)
    exito ← VERDADERO
    mensaje ← "Método de disparo lineal completado exitosamente\n" +
              "y(" + b + ") = " + FORMATO(resultado, dn) + 
              ", Z = " + FORMATO(Z, dn)

    RETORNAR resultado, mensaje, exito, tablaResultados
FIN ALGORITMO

```

## Método del Disparo No Lineal

```pseudocode
ALGORITMO MetodoDisparoNoLineal
ENTRADAS:
    funcion: cadena (ecuación diferencial: y'' = f(x, y, y'))
    df1dy: cadena (derivada parcial df/dy - opcional)
    df2dy: cadena (derivada parcial df/dy' - opcional)
    a: real (límite inferior del dominio)
    b: real (límite superior del dominio)
    alpha: real (condición de frontera en a: y(a) = alpha)
    beta: real (condición de frontera en b: y(b) = beta)
    n: entero (número de subintervalos para RK4)
    m: entero (número máximo de iteraciones de Newton)
    dn: entero (número de decimales para precisión)
    tol: real (tolerancia para convergencia)

SALIDAS:
    resultado: real (solución aproximada y(b))
    mensaje: cadena (estado del cálculo)
    exito: booleano (indicador de éxito)
    tablaResultados: matriz (n+1)×4 [i, xᵢ, y(xᵢ), y'(xᵢ)]

INICIO
    // PASO 1: Validación de parámetros
    SI funcion = "" ENTONCES
        RETORNAR 0, "Error: La función diferencial es requerida", FALSO, []
    FIN SI

    SI n ≤ 0 ENTONCES
        RETORNAR 0, "Error: n debe ser mayor que 0", FALSO, []
    FIN SI

    SI m ≤ 0 ENTONCES
        RETORNAR 0, "Error: m debe ser mayor que 0", FALSO, []
    FIN SI

    SI a ≥ b ENTONCES
        RETORNAR 0, "Error: El límite inferior debe ser menor que el superior", FALSO, []
    FIN SI

    SI tol ≤ 0 ENTONCES
        RETORNAR 0, "Error: La tolerancia debe ser mayor que 0", FALSO, []
    FIN SI

    SI dn < 0 ENTONCES
        RETORNAR 0, "Error: El número de decimales debe ser no negativo", FALSO, []
    FIN SI

    // PASO 2: Validar que la función sea evaluable
    INTENTAR
        x_prueba ← (a + b) / 2
        y_prueba ← (alpha + beta) / 2
        yPrime_prueba ← 0.0
        
        SI NO validarFuncionEnPunto(funcion, x_prueba, y_prueba, yPrime_prueba) ENTONCES
            RETORNAR 0, "Error: La función no es válida en el intervalo", FALSO, []
        FIN SI
    CAPTURAR ERROR e
        RETORNAR 0, "Error al validar la función: " + e, FALSO, []
    FIN INTENTAR

    // PASO 3: Inicialización
    h ← (b - a) / n
    tablaResultados ← []       // Inicializar tabla vacía

    // Estimación inicial para y'(a) usando pendiente promedio
    tk ← (beta - alpha) / (b - a)
    tk1 ← 0.0
    iteraciones ← 0
    convergio ← FALSO

    // PASO 4: Método de Newton-Raphson para encontrar y'(a) correcto
    PARA k DESDE 0 HASTA m-1 HACER
        iteraciones ← k
        
        // PASO 4.1: Resolver PVI con condición actual tk
        solucion_actual ← resolverProblemaValorInicial(funcion, a, b, n, alpha, tk)
        
        // PASO 4.2: Calcular φ(tk) = y(b) - beta
        phi_tk ← solucion_actual[0][n] - beta
        
        // PASO 4.3: Verificar convergencia
        SI |phi_tk| < tol ENTONCES
            convergio ← VERDADERO
            SALIR DEL BUCLE
        FIN SI
        
        // PASO 4.4: Calcular φ'(tk) usando diferencias finitas
        h_prima ← 0.001  // Perturbación pequeña
        solucion_prima ← resolverProblemaValorInicial(funcion, a, b, n, alpha, tk + h_prima)
        phi_tk_prima ← (solucion_prima[0][n] - beta - phi_tk) / h_prima
        
        // PASO 4.5: Verificar que la derivada no sea cero
        SI |phi_tk_prima| < 1e-10 ENTONCES
            RETORNAR 0, "Error: Derivada cercana a cero en iteración " + k, FALSO, []
        FIN SI
        
        // PASO 4.6: Aplicar método de Newton
        tk1 ← tk - phi_tk / phi_tk_prima
        
        // Actualizar para siguiente iteración
        tk ← tk1
    FIN PARA

    // PASO 5: Verificar convergencia
    SI NO convergio ENTONCES
        RETORNAR 0, "El método no convergió después de " + m + " iteraciones", FALSO, []
    FIN SI

    // PASO 6: Resolver con el valor final convergido de tk
    solucion_final ← resolverProblemaValorInicial(funcion, a, b, n, alpha, tk)
    
    // PASO 7: Construir tabla de resultados
    tablaResultados ← construirTablaResultados(solucion_final, a, b, n, dn)

    // PASO 8: Resultados finales
    resultado ← solucion_final[0][n]
    exito ← VERDADERO
    mensaje ← "Método de disparo no lineal completado exitosamente\n" +
              "y(" + b + ") = " + FORMATO(resultado, dn) + 
              ", y'(" + a + ") = " + FORMATO(tk, dn) + 
              " en " + iteraciones + " iteraciones"

    RETORNAR resultado, mensaje, exito, tablaResultados
FIN ALGORITMO
```

## Método de Diferencias Finitas Lineal

```pseudocode
ALGORITMO MétodoDiferenciasFinitasLineales
ENTRADAS:
    p_x, q_x, r_x: funciones de x (strings)
    n: número de particiones (entero)
    alpha, beta: condiciones de frontera (reales)
    lowerLimit, upperLimit: límites del intervalo (reales)
    dn: número de decimales para redondeo (entero)

SALIDAS:
    tabla de resultados (lista de listas)
    mensaje de estado (éxito/error)
    éxito: booleano

INICIO
    // Validaciones iniciales
    SI p_x está vacía O q_x está vacía O r_x está vacía ENTONCES
        mensaje ← "Error: debe proporcionar las funciones p(x), q(x) y r(x)"
        RETORNAR
    FIN SI

    SI lowerLimit ≥ upperLimit ENTONCES
        mensaje ← "Error: el límite inferior debe ser menor que el superior"
        RETORNAR
    FIN SI

    SI n ≤ 0 ENTONCES
        mensaje ← "Error: el número de particiones debe ser mayor que 0"
        RETORNAR
    FIN SI

    // Validar funciones en algunos puntos
    puntosPrueba ← [lowerLimit, (lowerLimit + upperLimit) / 2, upperLimit]
    SI NO (validarFuncionX(p_x, puntosPrueba) Y validarFuncionX(q_x, puntosPrueba) Y validarFuncionX(r_x, puntosPrueba)) ENTONCES
        mensaje ← "Error: alguna función produce valores no válidos en el dominio"
        RETORNAR
    FIN SI

    // Calcular paso
    h ← (upperLimit - lowerLimit) / (n + 1)

    // Inicializar arrays para el sistema tridiagonal
    A, B, C, D, L, U, Z, W ← arrays de tamaño n, inicializados en 0.0

    // Construir el sistema tridiagonal

    // Para el primer punto interior (x1)
    x ← lowerLimit + h
    A[0] ← 2.0 + h * h * evaluarFuncion(q_x, x)
    B[0] ← -1.0 + 0.5 * h * evaluarFuncion(p_x, x)
    D[0] ← -h * h * evaluarFuncion(r_x, x) + (1.0 + 0.5 * h * evaluarFuncion(p_x, x)) * alpha

    // Para los puntos interiores x2 a x_{n-1}
    PARA j ← 2 HASTA n-1 HACER
        x ← lowerLimit + j * h
        A[j-1] ← 2.0 + h * h * evaluarFuncion(q_x, x)
        B[j-1] ← -1.0 + 0.5 * h * evaluarFuncion(p_x, x)
        C[j-1] ← -1.0 - 0.5 * h * evaluarFuncion(p_x, x)
        D[j-1] ← -h * h * evaluarFuncion(r_x, x)
    FIN PARA

    // Para el último punto interior (xn)
    x ← upperLimit - h
    A[n-1] ← 2.0 + h * h * evaluarFuncion(q_x, x)
    C[n-1] ← -1.0 - 0.5 * h * evaluarFuncion(p_x, x)
    D[n-1] ← -h * h * evaluarFuncion(r_x, x) + (1.0 - 0.5 * h * evaluarFuncion(p_x, x)) * beta

    // Resolver el sistema tridiagonal con el algoritmo de Thomas

    // Paso 1: Descomposición LU (forward)
    L[0] ← A[0]
    U[0] ← B[0] / L[0]
    Z[0] ← D[0] / L[0]

    PARA i ← 2 HASTA n-1 HACER
        L[i-1] ← A[i-1] - C[i-1] * U[i-2]
        U[i-1] ← B[i-1] / L[i-1]
        Z[i-1] ← (D[i-1] - C[i-1] * Z[i-2]) / L[i-1]
    FIN PARA

    L[n-1] ← A[n-1] - C[n-1] * U[n-2]
    Z[n-1] ← (D[n-1] - C[n-1] * Z[n-2]) / L[n-1]

    // Paso 2: Sustitución hacia atrás
    W[n-1] ← Z[n-1]

    PARA j ← 1 HASTA n-1 HACER
        k ← n - j
        W[k-1] ← Z[k-1] - U[k-1] * W[k]
    FIN PARA

    // Construir la tabla de resultados

    // Agregar condición de frontera izquierda
    tablaResultados ← [ [ "0", redondear(lowerLimit, dn), redondear(alpha, dn) ] ]

    // Agregar puntos interiores
    PARA i ← 1 HASTA n HACER
        x ← lowerLimit + i * h
        tablaResultados ← tablaResultados ∪ [ [ i.toString(), redondear(x, dn), redondear(W[i-1], dn) ] ]
    FIN PARA

    // Agregar condición de frontera derecha
    tablaResultados ← tablaResultados ∪ [ [ (n+1).toString(), redondear(upperLimit, dn), redondear(beta, dn) ] ]

    // Establecer resultados exitosos
    éxito ← VERDADERO
    iteraciones ← n
    resultado ← redondear(W[n/2], dn)  // Valor en el punto medio como referencia
    mensaje ← "Solución completada exitosamente con " + n + " puntos interiores\n" +
              "Paso h = " + redondear(h, dn) + "\n" +
              "Ecuación: y'' = p(x)y' + q(x)y + r(x)"

    // Manejo de excepciones
    SI hay excepción ENTONCES
        mensaje ← "Error durante la ejecución: " + excepción.toString()
        éxito ← FALSO
    FIN SI

FIN ALGORITMO
```

## Método de Diferencias Finitas No Lineales

```pseudocode
ALGORITMO MétodoDiferenciasFinitasNoLineales
ENTRADAS:
    function: función f(x, y, z) donde z = y'
    df1dy: derivada parcial de f respecto a y
    df2dy: derivada parcial de f respecto a z (y')
    n: número de particiones (entero)
    m: número máximo de iteraciones de Newton (entero)
    alpha, beta: condiciones de frontera (reales)
    lowerLimit, upperLimit: límites del intervalo (reales)
    dn: número de decimales para redondeo (entero)
    tol: tolerancia del error (real)

SALIDAS:
    tabla de resultados (lista de listas)
    mensaje de estado (éxito/error)
    éxito: booleano

INICIO
    // Validaciones iniciales
    SI function está vacía O df1dy está vacía O df2dy está vacía ENTONCES
        mensaje ← "Error: debe proporcionar la función y sus derivadas parciales"
        RETORNAR
    FIN SI

    SI lowerLimit ≥ upperLimit ENTONCES
        mensaje ← "Error: el límite inferior debe ser menor que el superior"
        RETORNAR
    FIN SI

    SI n ≤ 0 ENTONCES
        mensaje ← "Error: el número de particiones debe ser mayor que 0"
        RETORNAR
    FIN SI

    SI m ≤ 0 ENTONCES
        mensaje ← "Error: el número máximo de iteraciones debe ser mayor que 0"
        RETORNAR
    FIN SI

    SI tol ≤ 0 ENTONCES
        mensaje ← "Error: la tolerancia debe ser mayor que 0"
        RETORNAR
    FIN SI

    // Validar funciones usando MethodUtils
    puntosPrueba ← [lowerLimit, alpha, (alpha+beta)/2, upperLimit, beta, (beta-alpha)/(upperLimit-lowerLimit)]
    SI NO (validarFuncionXYZ(function, puntosPrueba) Y validarFuncionXYZ(df1dy, puntosPrueba) Y validarFuncionXYZ(df2dy, puntosPrueba)) ENTONCES
        mensaje ← "Error: alguna función produce valores no válidos en el dominio"
        RETORNAR
    FIN SI

    // Calcular paso
    h ← (upperLimit - lowerLimit) / (n + 1)
    
    // Inicializar arrays para el sistema
    w, v, a, b, c, d, l, u, z ← arrays de tamaño n, inicializados en 0.0

    // Inicializar w con aproximación lineal
    PARA i ← 0 HASTA n-1 HACER
        x ← lowerLimit + (i + 1) * h
        w[i] ← alpha + (x - lowerLimit) * (beta - alpha) / (upperLimit - lowerLimit)
    FIN PARA

    ok ← VERDADERO
    k ← 1

    // Iteraciones de Newton
    MIENTRAS k ≤ m Y ok HACER
        // Construir el sistema tridiagonal para la iteración actual

        // Punto x1
        x ← lowerLimit + h
        t ← (w[0] - alpha) / (2 * h)  // Aproximación de la derivada
        a[0] ← 2.0 + h * h * evaluarFuncionXYZ(df1dy, x, w[0], t)
        b[0] ← -1.0 + (h / 2) * evaluarFuncionXYZ(df2dy, x, w[0], t)
        d[0] ← -(2.0 * w[0] - w[1] - alpha + h * h * evaluarFuncionXYZ(function, x, w[0], t))

        // Puntos interiores x2 a x_{n-1}
        PARA j ← 2 HASTA n-1 HACER
            x ← lowerLimit + j * h
            t ← (w[j-1] - w[j-3]) / (2 * h)  // Aproximación de la derivada
            a[j-1] ← 2.0 + h * h * evaluarFuncionXYZ(df1dy, x, w[j-1], t)
            b[j-1] ← -1.0 + (h / 2) * evaluarFuncionXYZ(df2dy, x, w[j-1], t)
            c[j-1] ← -1.0 - (h / 2) * evaluarFuncionXYZ(df2dy, x, w[j-1], t)
            d[j-1] ← -(2.0 * w[j-1] - w[j] - w[j-2] + h * h * evaluarFuncionXYZ(function, x, w[j-1], t))
        FIN PARA

        // Punto xn
        x ← upperLimit - h
        t ← (beta - w[n-2]) / (2 * h)  // Aproximación de la derivada
        a[n-1] ← 2.0 + h * h * evaluarFuncionXYZ(df1dy, x, w[n-1], t)
        c[n-1] ← -1.0 - (h / 2) * evaluarFuncionXYZ(df2dy, x, w[n-1], t)
        d[n-1] ← -(2.0 * w[n-1] - w[n-2] - beta + h * h * evaluarFuncionXYZ(function, x, w[n-1], t))

        // Algoritmo de Thomas para sistemas tridiagonales
        l[0] ← a[0]
        u[0] ← b[0] / a[0]
        z[0] ← d[0] / l[0]

        PARA i ← 2 HASTA n-1 HACER
            l[i-1] ← a[i-1] - c[i-1] * u[i-2]
            u[i-1] ← b[i-1] / l[i-1]
            z[i-1] ← (d[i-1] - c[i-1] * z[i-2]) / l[i-1]
        FIN PARA

        l[n-1] ← a[n-1] - c[n-1] * u[n-2]
        z[n-1] ← (d[n-1] - c[n-1] * z[n-2]) / l[n-1]

        // Sustitución hacia atrás y actualización
        v[n-1] ← z[n-1]
        vmax ← |v[n-1]|
        w[n-1] ← w[n-1] + v[n-1]

        PARA j ← 1 HASTA n-1 HACER
            index ← n - j - 1
            v[index] ← z[index] - u[index] * v[index+1]
            w[index] ← w[index] + v[index]
            SI |v[index]| > vmax ENTONCES
                vmax ← |v[index]|
            FIN SI
        FIN PARA

        // Verificar convergencia
        SI vmax ≤ tol ENTONCES
            // Construir tabla de resultados
            tablaResultados ← [ [ "0", redondear(lowerLimit, dn), redondear(alpha, dn) ] ]

            PARA i ← 1 HASTA n HACER
                x ← lowerLimit + i * h
                tablaResultados ← tablaResultados ∪ [ [ i.toString(), redondear(x, dn), redondear(w[i-1], dn) ] ]
            FIN PARA

            tablaResultados ← tablaResultados ∪ [ [ (n+1).toString(), redondear(upperLimit, dn), redondear(beta, dn) ] ]

            éxito ← VERDADERO
            iteraciones ← k
            resultado ← redondear(w[n/2], dn)  // Valor en el punto medio como referencia
            mensaje ← "Solución completada exitosamente en " + k + " iteraciones\n" +
                      "Paso h = " + redondear(h, dn) + "\n" +
                      "Error máximo: " + redondear(vmax, dn)
            ok ← FALSO  // Salir del bucle
        SINO
            k ← k + 1
        FIN SI
    FIN MIENTRAS

    SI k > m ENTONCES
        mensaje ← "No hubo convergencia en " + m + " iteraciones\n" +
                  "Último error máximo: " + redondear(calcularErrorMaximo(v), dn)
        éxito ← FALSO
    FIN SI

    // Manejo de excepciones
    SI hay excepción ENTONCES
        mensaje ← "Error durante la ejecución: " + excepción.toString()
        éxito ← FALSO
    FIN SI

FIN ALGORITMO
```

## Método de Ecuación Elíptica (Poisson)

```pseudocode
ALGORITMO MétodoDiferenciasFinitasPoisson
ENTRADAS:
    function1: f(x, y) - función del lado derecho de la ecuación
    function2: g(x, y) - función de condiciones de frontera
    a, b: límites en x (reales)
    c, d: límites en y (reales)
    n, m: número de particiones en x e y (enteros)
    dn: número de decimales para redondeo (entero)
    tol: tolerancia del error (real)
    maxIterations: número máximo de iteraciones (entero)

SALIDAS:
    tabla de resultados (lista de listas)
    iteraciones: número de iteraciones realizadas
    mensaje de estado (éxito/error)

INICIO
    // Validar parámetros
    error ← _validarParametros()
    SI error ≠ NULO ENTONCES
        LANZAR Excepción(error)
    FIN SI

    // Inicializar variables según código Java
    NN ← maxIterations
    M1 ← m - 1
    M2 ← m - 2
    N1 ← n - 1
    N2 ← n - 2
    
    H ← (b - a) / n
    K ← (d - c) / m
    
    // Inicializar matrices y vectores
    W ← matriz de tamaño (n+1) x (m+1) con ceros
    X ← vector de tamaño (n+1) con ceros
    Y ← vector de tamaño (m+1) con ceros
    
    // Calcular coordenadas X
    PARA I ← 0 HASTA n HACER
        X[I] ← a + I * H
    FIN PARA
    
    // Calcular coordenadas Y
    PARA J ← 0 HASTA m HACER
        Y[J] ← c + J * K
    FIN PARA
    
    // Aplicar condiciones de frontera
    PARA I ← 1 HASTA N1 HACER
        W[I][0] ← evaluarFuncion(function2, X[I], Y[0])
        W[I][m] ← evaluarFuncion(function2, X[I], Y[m])
    FIN PARA
    
    PARA J ← 0 HASTA m HACER
        W[0][J] ← evaluarFuncion(function2, X[0], Y[J])
        W[n][J] ← evaluarFuncion(function2, X[n], Y[J])
    FIN PARA
    
    // Inicializar puntos interiores a 0
    PARA I ← 1 HASTA N1 HACER
        PARA J ← 1 HASTA M1 HACER
            W[I][J] ← 0.0
        FIN PARA
    FIN PARA
    
    // Constantes para el método iterativo
    V ← (H * H) / (K * K)
    VV ← 2.0 * (1.0 + V)
    
    L ← 1
    OK ← FALSO
    
    // Bucle principal de iteraciones
    MIENTRAS L ≤ NN Y NO OK HACER
        E ← 0.0
        
        // --- Procesar fila superior (J = M1) ---
        Z ← (-H * H * evaluarFuncion(function1, X[1], Y[M1]) + 
             evaluarFuncion(function2, a, Y[M1]) + 
             V * evaluarFuncion(function2, X[1], d) + 
             V * W[1][M2] + 
             W[2][M1]) / VV
        
        errorTemp ← |W[1][M1] - Z|
        SI errorTemp > E ENTONCES E ← errorTemp
        W[1][M1] ← Z
        
        // Puntos interiores de la fila superior
        PARA I ← 2 HASTA N2 HACER
            Z ← (-H * H * evaluarFuncion(function1, X[I], Y[M1]) + 
                 V * evaluarFuncion(function2, X[I], d) + 
                 W[I-1][M1] + 
                 W[I+1][M1] + 
                 V * W[I][M2]) / VV
            
            errorTemp ← |W[I][M1] - Z|
            SI errorTemp > E ENTONCES E ← errorTemp
            W[I][M1] ← Z
        FIN PARA
        
        // Último punto de la fila superior
        Z ← (-H * H * evaluarFuncion(function1, X[N1], Y[M1]) + 
             evaluarFuncion(function2, b, Y[M1]) + 
             V * evaluarFuncion(function2, X[N1], d) + 
             W[N2][M1] + 
             V * W[N1][M2]) / VV
        
        errorTemp ← |W[N1][M1] - Z|
        SI errorTemp > E ENTONCES E ← errorTemp
        W[N1][M1] ← Z
        
        // --- Procesar filas intermedias (en orden inverso) ---
        PARA LL ← 2 HASTA M2 HACER
            J ← M2 - LL + 2
            
            // Primer punto de la fila J
            Z ← (-H * H * evaluarFuncion(function1, X[1], Y[J]) + 
                 evaluarFuncion(function2, a, Y[J]) + 
                 V * W[1][J+1] + 
                 V * W[1][J-1] + 
                 W[2][J]) / VV
            
            errorTemp ← |W[1][J] - Z|
            SI errorTemp > E ENTONCES E ← errorTemp
            W[1][J] ← Z
            
            // Puntos interiores de la fila J
            PARA I ← 2 HASTA N2 HACER
                Z ← (-H * H * evaluarFuncion(function1, X[I], Y[J]) + 
                     W[I-1][J] + 
                     V * W[I][J+1] + 
                     V * W[I][J-1] + 
                     W[I+1][J]) / VV
                
                errorTemp ← |W[I][J] - Z|
                SI errorTemp > E ENTONCES E ← errorTemp
                W[I][J] ← Z
            FIN PARA
            
            // Último punto de la fila J
            Z ← (-H * H * evaluarFuncion(function1, X[N1], Y[J]) + 
                 evaluarFuncion(function2, b, Y[J]) + 
                 W[N2][J] + 
                 V * W[N1][J+1] + 
                 V * W[N1][J-1]) / VV
            
            errorTemp ← |W[N1][J] - Z|
            SI errorTemp > E ENTONCES E ← errorTemp
            W[N1][J] ← Z
        FIN PARA
        
        // --- Procesar fila inferior (J = 1) ---
        Z ← (-H * H * evaluarFuncion(function1, X[1], Y[1]) + 
             V * evaluarFuncion(function2, X[1], c) + 
             evaluarFuncion(function2, a, Y[1]) + 
             V * W[1][2] + 
             W[2][1]) / VV
        
        errorTemp ← |W[1][1] - Z|
        SI errorTemp > E ENTONCES E ← errorTemp
        W[1][1] ← Z
        
        // Puntos interiores de la fila inferior
        PARA I ← 2 HASTA N2 HACER
            Z ← (-H * H * evaluarFuncion(function1, X[I], Y[1]) + 
                 V * evaluarFuncion(function2, X[I], c) + 
                 W[I+1][1] + 
                 W[I-1][1] + 
                 V * W[I][2]) / VV
            
            errorTemp ← |W[I][1] - Z|
            SI errorTemp > E ENTONCES E ← errorTemp
            W[I][1] ← Z
        FIN PARA
        
        // Último punto de la fila inferior
        Z ← (-H * H * evaluarFuncion(function1, X[N1], Y[1]) + 
             V * evaluarFuncion(function2, X[N1], c) + 
             evaluarFuncion(function2, b, Y[1]) + 
             W[N2][1] + 
             V * W[N1][2]) / VV
        
        errorTemp ← |W[N1][1] - Z|
        SI errorTemp > E ENTONCES E ← errorTemp
        W[N1][1] ← Z
        
        // Verificar convergencia
        SI E ≤ tol ENTONCES
            OK ← VERDADERO
            iteraciones ← L
        SINO
            L ← L + 1
        FIN SI
    FIN MIENTRAS
    
    SI L > NN Y NO OK ENTONCES
        LANZAR Excepción("No converge después de NN iteraciones")
    FIN SI
    
    SI NO OK ENTONCES
        iteraciones ← NN
    FIN SI
    
    // Construir tabla de resultados
    _construirTablaResultados(W, X, Y)
    
    // Manejo de excepciones
    SI hay excepción ENTONCES
        LANZAR Excepción("Error durante la ejecución: " + excepción.toString())
    FIN SI

FIN ALGORITMO
```

## Método de Ecuación Parabólica (Calor)

```pseudocode
ALGORITMO MétodoDiferenciasRegresivasEcuacionCalor
ENTRADAS:
    function: f(x) - condición inicial (string)
    upperLimit: límite espacial superior (real)
    maxTime: tiempo máximo (real)
    n: número de divisiones temporales (entero)
    m: número de divisiones espaciales (entero)
    alpha: coeficiente de difusividad térmica (real)
    dn: número de decimales para redondeo (entero)

SALIDAS:
    tabla de resultados (lista de listas)
    mensaje de estado (éxito/error)
    éxito: booleano

INICIO
    // Validaciones iniciales
    SI function está vacía ENTONCES
        mensaje ← "Error: debe proporcionar la función inicial f(x)"
        RETORNAR
    FIN SI

    SI upperLimit ≤ 0 ENTONCES
        mensaje ← "Error: el límite superior debe ser mayor que 0"
        RETORNAR
    FIN SI

    SI maxTime ≤ 0 ENTONCES
        mensaje ← "Error: el tiempo máximo debe ser mayor que 0"
        RETORNAR
    FIN SI

    SI m ≤ 0 ENTONCES
        mensaje ← "Error: el número de divisiones espaciales debe ser mayor que 0"
        RETORNAR
    FIN SI

    SI n ≤ 0 ENTONCES
        mensaje ← "Error: el número de divisiones temporales debe ser mayor que 0"
        RETORNAR
    FIN SI

    SI alpha ≤ 0 ENTONCES
        mensaje ← "Error: el coeficiente alpha debe ser mayor que 0"
        RETORNAR
    FIN SI

    // Validar función en puntos de prueba
    puntosPrueba ← [0.0, upperLimit/2, upperLimit]
    SI NO validarFuncionX(function, puntosPrueba) ENTONCES
        mensaje ← "Error: la función produce valores no válidos en el dominio"
        RETORNAR
    FIN SI

    // Inicializar arrays para el sistema tridiagonal
    w, l, u, z ← arrays de tamaño (m-1) inicializados en 0.0

    // Calcular pasos
    h ← upperLimit / m
    k ← maxTime / n
    lambda ← alpha * alpha * k / (h * h)

    // Agregar primera fila (x=0, u=0)
    tablaResultados ← [ [ "0", redondear(0.0, dn), redondear(0.0, dn) ] ]

    // Inicializar w con la condición inicial f(x)
    PARA j ← 1 HASTA m-1 HACER
        x ← j * h
        w[j-1] ← evaluarFuncionX(function, x)
    FIN PARA

    // Construir matriz tridiagonal (descomposición LU)

    // Primer punto
    l[0] ← 1.0 + 2.0 * lambda
    u[0] ← -lambda / l[0]

    // Puntos interiores i=2 hasta m-2
    PARA i ← 2 HASTA m-2 HACER
        l[i-1] ← 1.0 + 2.0 * lambda + lambda * u[i-2]
        u[i-1] ← -lambda / l[i-1]
    FIN PARA

    // Último punto
    l[m-2] ← 1.0 + 2.0 * lambda + lambda * u[m-3]

    // Iteraciones temporales
    PARA j ← 1 HASTA n HACER
        // Resolver sistema tridiagonal usando algoritmo de Thomas

        // Paso forward
        z[0] ← w[0] / l[0]
        
        PARA i ← 2 HASTA m-1 HACER
            z[i-1] ← (w[i-1] + lambda * z[i-2]) / l[i-1]
        FIN PARA

        // Sustitución hacia atrás
        w[m-2] ← z[m-2]

        PARA i ← 1 HASTA m-2 HACER
            index ← m - 2 - i
            w[index] ← z[index] - u[index] * w[index+1]
        FIN PARA
    FIN PARA

    // Agregar puntos interiores a la tabla de resultados
    PARA i ← 1 HASTA m-1 HACER
        x ← i * h
        tablaResultados ← tablaResultados ∪ [ [ i.toString(), redondear(x, dn), redondear(w[i-1], dn) ] ]
    FIN PARA

    // Agregar última fila (x=l, u=0)
    tablaResultados ← tablaResultados ∪ [ [ m.toString(), redondear(upperLimit, dn), redondear(0.0, dn) ] ]

    // Establecer resultados exitosos
    éxito ← VERDADERO
    iteraciones ← n
    resultado ← redondear(w[(m-1)/2], dn)  // Valor en el punto medio como referencia
    mensaje ← "Solución completada exitosamente\n" +
              "Tiempo final: t = " + redondear(maxTime, dn) + "\n" +
              "Paso espacial h = " + redondear(h, dn) + "\n" +
              "Paso temporal k = " + redondear(k, dn) + "\n" +
              "Parámetro λ = " + redondear(lambda, dn)

    // Manejo de excepciones
    SI hay excepción ENTONCES
        mensaje ← "Error durante la ejecución: " + excepción.toString()
        éxito ← FALSO
    FIN SI

FIN ALGORITMO
```

## Método de Ecuación Hiperbólica (Onda)

```pseudocode
ALGORITMO MétodoDiferenciasFinitasEcuacionOnda
ENTRADAS:
    function1: f(x) - condición inicial de posición (string)
    function2: g(x) - condición inicial de velocidad (string)
    upperLimit: límite espacial superior (real)
    maxTime: tiempo máximo (real)
    n: número de divisiones temporales (entero)
    m: número de divisiones espaciales (entero)
    dn: número de decimales para redondeo (entero)
    alpha: velocidad de propagación de la onda (real)

SALIDAS:
    tabla de resultados (lista de listas)
    mensaje de estado (éxito/error)

INICIO
    // Validaciones iniciales
    SI function1 está vacía O function2 está vacía ENTONCES
        mensaje ← "Error: debe proporcionar ambas funciones iniciales"
        RETORNAR
    FIN SI

    SI upperLimit ≤ 0 ENTONCES
        mensaje ← "Error: el límite superior debe ser mayor que 0"
        RETORNAR
    FIN SI

    SI maxTime ≤ 0 ENTONCES
        mensaje ← "Error: el tiempo máximo debe ser mayor que 0"
        RETORNAR
    FIN SI

    SI m ≤ 0 ENTONCES
        mensaje ← "Error: el número de divisiones espaciales debe ser mayor que 0"
        RETORNAR
    FIN SI

    SI n ≤ 0 ENTONCES
        mensaje ← "Error: el número de divisiones temporales debe ser mayor que 0"
        RETORNAR
    FIN SI

    SI alpha ≤ 0 ENTONCES
        mensaje ← "Error: la velocidad de propagación debe ser mayor que 0"
        RETORNAR
    FIN SI

    // Validar funciones usando MethodUtils
    puntosPrueba ← [0.0, upperLimit/2, upperLimit]
    SI NO validarFuncionX(function1, puntosPrueba) O NO validarFuncionX(function2, puntosPrueba) ENTONCES
        mensaje ← "Error: alguna función produce valores no válidos en el dominio"
        RETORNAR
    FIN SI

    // Calcular pasos
    h ← upperLimit / m
    k ← maxTime / n
    lambda ← alpha * k / h

    // Verificar condición de estabilidad CFL
    SI lambda > 1 ENTONCES
        mensaje ← "Error: condición CFL no satisfecha (λ = " + redondear(lambda, dn) + " > 1)"
        RETORNAR
    FIN SI

    // Inicializar arrays para la solución
    u_actual ← array de tamaño (m+1) inicializado en 0.0
    u_anterior ← array de tamaño (m+1) inicializado en 0.0
    u_siguiente ← array de tamaño (m+1) inicializado en 0.0

    // Aplicar condiciones de frontera (extremos fijos)
    u_actual[0] ← 0.0
    u_actual[m] ← 0.0
    u_anterior[0] ← 0.0
    u_anterior[m] ← 0.0
    u_siguiente[0] ← 0.0
    u_siguiente[m] ← 0.0

    // Aplicar condición inicial de posición u(x,0) = f(x)
    PARA i ← 1 HASTA m-1 HACER
        x ← i * h
        u_actual[i] ← evaluarFuncionX(function1, x)
    FIN PARA

    // Calcular primer paso temporal usando condición inicial de velocidad
    PARA i ← 1 HASTA m-1 HACER
        x ← i * h
        termino_velocidad ← k * evaluarFuncionX(function2, x)
        termino_onda ← (lambda * lambda / 2) * (u_actual[i+1] - 2 * u_actual[i] + u_actual[i-1])
        u_siguiente[i] ← u_actual[i] + termino_velocidad + termino_onda
    FIN PARA

    // Inicializar tabla de resultados con tiempo t=0
    tablaResultados ← []
    PARA i ← 0 HASTA m HACER
        x ← i * h
        tablaResultados ← tablaResultados ∪ [ [ "0", i.toString(), redondear(x, dn), redondear(u_actual[i], dn) ] ]
    FIN PARA

    // Iteraciones temporales principales
    PARA j ← 1 HASTA n HACER
        // Calcular siguiente paso temporal usando el esquema de diferencias finitas
        PARA i ← 1 HASTA m-1 HACER
            u_siguiente[i] ← 2 * (1 - lambda * lambda) * u_actual[i] + 
                            lambda * lambda * (u_actual[i+1] + u_actual[i-1]) - 
                            u_anterior[i]
        FIN PARA

        // Actualizar arrays para siguiente iteración
        u_anterior ← copia de u_actual
        u_actual ← copia de u_siguiente

        // Guardar resultados en tiempos específicos (cada cierto número de iteraciones)
        SI j % (n/10) = 0 O j = n ENTONCES
            tiempo_actual ← j * k
            PARA i ← 0 HASTA m HACER
                x ← i * h
                tablaResultados ← tablaResultados ∪ [ [ j.toString(), i.toString(), redondear(x, dn), redondear(u_actual[i], dn) ] ]
            FIN PARA
        FIN SI
    FIN PARA

    éxito ← VERDADERO
    iteraciones ← n
    resultado ← redondear(u_actual[m/2], dn)  // Valor en el punto medio como referencia
    mensaje ← "Solución completada exitosamente\n" +
              "Tiempo final: t = " + redondear(maxTime, dn) + "\n" +
              "Paso espacial h = " + redondear(h, dn) + "\n" +
              "Paso temporal k = " + redondear(k, dn) + "\n" +
              "Parámetro λ = " + redondear(lambda, dn) + "\n" +
              "Condición CFL: " + redondear(lambda, dn) + " ≤ 1"

    // Manejo de excepciones
    SI hay excepción ENTONCES
        mensaje ← "Error durante la ejecución: " + excepción.toString()
        éxito ← FALSO
    FIN SI

FIN ALGORITMO
```

## Método de eliminación Gaussiana con sustitución hacia atrás

```pseudocode
ALGORITMO EliminacionGaussianaSustitucionAtras
ENTRADAS:
    augmentedMatrix: matriz aumentada del sistema (lista de listas de reales)
    n: tamaño del sistema (entero)
    dn: número de decimales para redondeo (entero)

SALIDAS:
    solución: vector solución (lista de reales)
    mensaje: estado de la ejecución (string)
    éxito: booleano indicando si el cálculo fue exitoso

INICIO
    INICIALIZAR()
    
    // Reconstruir matriz aumentada si es necesario
    SI augmentedMatrix está vacía Y dataTable no está vacía Y resultTable no está vacía ENTONCES
        augmentedMatrix ← []
        PARA i ← 0 HASTA n-1 HACER
            fila ← copia de dataTable[i]
            agregar resultTable[i] al final de fila
            augmentedMatrix[i] ← fila
        FIN PARA
    FIN SI

    SI augmentedMatrix está vacía ENTONCES
        mensaje ← "Error: No se ha configurado la matriz del sistema"
        éxito ← FALSO
        RETORNAR
    FIN SI

    n ← longitud(augmentedMatrix)
    A ← copia de augmentedMatrix
    solución ← vector de tamaño n inicializado con 0.0
    swapCount ← 0

    // Validar entrada
    errorValidacion ← _validarEntrada()
    SI errorValidacion ≠ NULO ENTONCES
        mensaje ← errorValidacion
        éxito ← FALSO
        RETORNAR
    FIN SI

    // Fase de eliminación hacia adelante
    SI NO _eliminacionAdelante(A) ENTONCES
        mensaje ← "Error: El sistema no tiene solución única (matriz singular)"
        éxito ← FALSO
        RETORNAR
    FIN SI

    // Fase de sustitución hacia atrás
    SI NO _sustitucionAtras(A) ENTONCES
        mensaje ← "Error: No se pudo resolver el sistema"
        éxito ← FALSO
        RETORNAR
    FIN SI

    // Calcular residual y actualizar resultados
    residual ← _calcularResidual()
    iteraciones ← 0  // No es método iterativo
    éxito ← VERDADERO
    mensaje ← "Sistema resuelto exitosamente con " + swapCount + " intercambio(s) de filas"

    // Manejo de excepciones
    SI hay excepción ENTONCES
        mensaje ← "Error durante el cálculo: " + excepción.toString()
        éxito ← FALSO
    FIN SI

FIN ALGORITMO

// Funciones auxiliares:

ALGORITMO _eliminacionAdelante(A)
    PARA i ← 0 HASTA n-2 HACER
        // Pivoteo parcial: encontrar fila con máximo elemento en columna actual
        maxFila ← i
        maxVal ← |A[i][i]|
        
        PARA k ← i+1 HASTA n-1 HACER
            SI |A[k][i]| > maxVal ENTONCES
                maxVal ← |A[k][i]|
                maxFila ← k
            FIN SI
        FIN PARA

        // Si elemento máximo es cero, matriz es singular
        SI maxVal < 1e-15 ENTONCES
            RETORNAR FALSO
        FIN SI

        // Intercambiar filas si es necesario
        SI maxFila ≠ i ENTONCES
            _intercambiarFilas(A, i, maxFila)
            swapCount ← swapCount + 1
        FIN SI

        // Eliminación
        PARA k ← i+1 HASTA n-1 HACER
            factor ← A[k][i] / A[i][i]
            
            PARA j ← i HASTA n HACER
                A[k][j] ← A[k][j] - factor * A[i][j]
            FIN PARA
            
            // Hacer cero el elemento por precisión numérica
            A[k][i] ← 0.0
        FIN PARA
    FIN PARA

    // Verificar que el último pivote no sea cero
    SI |A[n-1][n-1]| < 1e-15 ENTONCES
        RETORNAR FALSO
    FIN SI

    RETORNAR VERDADERO
FIN ALGORITMO

ALGORITMO _intercambiarFilas(A, fila1, fila2)
    temp ← copia de A[fila1]
    A[fila1] ← copia de A[fila2]
    A[fila2] ← temp
FIN ALGORITMO

ALGORITMO _sustitucionAtras(A)
    INTENTAR
        PARA i ← n-1 HASTA 0 HACER
            sum ← 0.0
            
            PARA j ← i+1 HASTA n-1 HACER
                sum ← sum + A[i][j] * solución[j]
            FIN PARA
            
            solución[i] ← (A[i][n] - sum) / A[i][i]
            
            // Verificar si el resultado es válido
            SI solución[i] es NaN O solución[i] es Infinito ENTONCES
                RETORNAR FALSO
            FIN SI
        FIN PARA
        RETORNAR VERDADERO
    CAPTURAR excepción
        RETORNAR FALSO
    FIN INTENTAR
FIN ALGORITMO

ALGORITMO _calcularResidual
    maxResidual ← 0.0
    
    PARA i ← 0 HASTA n-1 HACER
        sum ← 0.0
        PARA j ← 0 HASTA n-1 HACER
            sum ← sum + dataTable[i][j] * solución[j]
        FIN PARA
        residual ← |sum - resultTable[i]|
        SI residual > maxResidual ENTONCES
            maxResidual ← residual
        FIN SI
    FIN PARA
    
    RETORNAR maxResidual
FIN ALGORITMO
```

## Método de factorización de Schur

```pseudocode
ALGORITMO FactorizacionSchur
ENTRADAS:
    A: matriz cuadrada n×n (lista de listas de reales)
    maxIterations: máximo de iteraciones (entero)
    tolerance: tolerancia para convergencia (real)

SALIDAS:
    Q: matriz unitaria ortogonal
    T: matriz triangular superior de Schur
    eigenvalues: lista de autovalores (reales o complejos)
    éxito: booleano indicando si el cálculo fue exitoso

INICIO
    // Validaciones iniciales
    SI matriz A está vacía ENTONCES
        RETORNAR error "La matriz está vacía"
    FIN SI

    // Validar que la matriz sea cuadrada
    n ← longitud(A)
    PARA i ← 0 HASTA n-1 HACER
        SI longitud(A[i]) ≠ n ENTONCES
            RETORNAR error "La matriz debe ser cuadrada"
        FIN SI
    FIN PARA

    // Inicialización
    Q ← matriz_identidad(n)
    T ← copia_matriz(A)
    iter ← 0
    norm ← norma_matriz(T)

    // Algoritmo QR iterativo
    MIENTRAS iter < maxIterations Y norm > tolerance HACER
        // Calcular shift (desplazamiento)
        shift ← T[n-1][n-1]

        // Aplicar shift: A - shift*I
        T_shifted ← copia_matriz(T)
        PARA i ← 0 HASTA n-1 HACER
            T_shifted[i][i] ← T_shifted[i][i] - shift
        FIN PARA

        // Descomposición QR de T_shifted
        resultado_QR ← descomposicion_QR(T_shifted)
        Q_k ← resultado_QR.Q
        R ← resultado_QR.R

        // Reconstruir: T = R*Q_k + shift*I
        RQ ← multiplicar_matrices(R, Q_k)
        PARA i ← 0 HASTA n-1 HACER
            RQ[i][i] ← RQ[i][i] + shift
        FIN PARA

        T ← RQ
        
        // Acumular transformaciones ortogonales
        Q ← multiplicar_matrices(Q, Q_k)

        // Actualizar norma y contador
        norm ← norma_subdiagonal(T)
        iter ← iter + 1
    FIN MIENTRAS

    // Extraer autovalores de T
    eigenvalues ← extraer_autovalores(T)

    éxito ← VERDADERO
    iteraciones ← iter

FIN ALGORITMO

// Función auxiliar: Descomposición QR usando reflectores de Householder
ALGORITMO descomposicion_QR(A)
    n ← longitud(A)
    Q ← matriz_identidad(n)
    R ← copia_matriz(A)

    PARA k ← 0 HASTA n-2 HACER
        // Extraer columna k desde la diagonal hacia abajo
        x ← vector de tamaño (n-k)
        PARA i ← k HASTA n-1 HACER
            x[i-k] ← R[i][k]
        FIN PARA

        // Calcular vector de Householder
        norma_x ← norma_vector(x)
        v ← copia_vector(x)
        v[0] ← v[0] + signo(x[0]) * norma_x

        norma_v ← norma_vector(v)
        SI norma_v > tolerancia ENTONCES
            PARA i ← 0 HASTA longitud(v)-1 HACER
                v[i] ← v[i] / norma_v
            FIN PARA

            // Aplicar reflector a R
            PARA j ← k HASTA n-1 HACER
                columna ← vector de tamaño (n-k)
                PARA i ← k HASTA n-1 HACER
                    columna[i-k] ← R[i][j]
                FIN PARA

                producto_punto ← producto_punto(columna, v)
                
                PARA i ← k HASTA n-1 HACER
                    R[i][j] ← R[i][j] - 2 * v[i-k] * producto_punto
                FIN PARA
            FIN PARA

            // Aplicar reflector a Q
            PARA j ← 0 HASTA n-1 HACER
                columna ← vector de tamaño (n-k)
                PARA i ← k HASTA n-1 HACER
                    columna[i-k] ← Q[i][j]
                FIN PARA

                producto_punto ← producto_punto(columna, v)
                
                PARA i ← k HASTA n-1 HACER
                    Q[i][j] ← Q[i][j] - 2 * v[i-k] * producto_punto
                FIN PARA
            FIN PARA
        FIN SI
    FIN PARA

    RETORNAR {Q: Q, R: R}
FIN ALGORITMO

// Función auxiliar: Extraer autovalores de matriz triangular superior
ALGORITMO extraer_autovalores(T)
    n ← longitud(T)
    autovalores ← []
    i ← 0

    MIENTRAS i < n HACER
        SI i = n-1 O |T[i+1][i]| < tolerancia ENTONCES
            // Autovalor real
            autovalores ← autovalores ∪ [[T[i][i], 0.0]]
            i ← i + 1
        SINO
            // Bloque 2×2 - autovalores complejos o reales
            a ← T[i][i]
            b ← T[i][i+1]
            c ← T[i+1][i]
            d ← T[i+1][i+1]

            traza ← a + d
            determinante ← a*d - b*c

            discriminante ← traza² - 4*determinante

            SI discriminante < 0 ENTONCES
                // Autovalores complejos conjugados
                parte_real ← traza / 2
                parte_imaginaria ← sqrt(-discriminante) / 2
                autovalores ← autovalores ∪ [[parte_real, parte_imaginaria]]
                autovalores ← autovalores ∪ [[parte_real, -parte_imaginaria]]
            SINO
                // Autovalores reales
                lambda1 ← (traza + sqrt(discriminante)) / 2
                lambda2 ← (traza - sqrt(discriminante)) / 2
                autovalores ← autovalores ∪ [[lambda1, 0.0]]
                autovalores ← autovalores ∪ [[lambda2, 0.0]]
            FIN SI
            i ← i + 2
        FIN SI
    FIN MIENTRAS

    RETORNAR autovalores
FIN ALGORITMO
```

## Factorización LU con Sobrerrelajación Successive (SOR)

```pseudocode
ALGORITMO MetodoSOR
ENTRADAS:
    A: matriz de coeficientes n×n
    b: vector de términos independientes
    x0: vector inicial de aproximación
    omega: factor de relajación (0 < omega < 2)
    tol: tolerancia de error
    maxIterations: máximo número de iteraciones

SALIDAS:
    x: solución aproximada del sistema
    iterationResults: historial de iteraciones
    finalError: error final alcanzado
    éxito: indicador de convergencia

INICIO
    // Validar parámetros de entrada
    error_validacion ← _validarParametros()
    SI error_validacion ≠ NULO ENTONCES
        RETORNAR error error_validacion
    FIN SI

    // Verificar condiciones de convergencia
    SI NO _verificarConvergencia(A) ENTONCES
        MOSTRAR "Advertencia: La matriz puede no converger"
    FIN SI

    // Inicializar variables
    x ← copia de x0
    x_anterior ← copia de x0
    resultados_iteracion ← []
    error ← infinito
    iter ← 0

    // Bucle principal de iteraciones SOR
    MIENTRAS iter < maxIterations Y error > tol HACER
        // Guardar solución anterior
        x_anterior ← copia de x

        // Iterar sobre cada variable del sistema
        PARA i ← 0 HASTA n-1 HACER
            suma1 ← 0.0
            suma2 ← 0.0

            // Sumar términos con valores ya actualizados (j < i)
            PARA j ← 0 HASTA i-1 HACER
                suma1 ← suma1 + A[i][j] * x[j]
            FIN PARA

            // Sumar términos con valores de iteración anterior (j > i)
            PARA j ← i+1 HASTA n-1 HACER
                suma2 ← suma2 + A[i][j] * x_anterior[j]
            FIN PARA

            // Calcular nuevo valor con sobrerrelajación
            termino ← (b[i] - suma1 - suma2) / A[i][i]
            x[i] ← x_anterior[i] + omega * (termino - x_anterior[i])
        FIN PARA

        // Calcular error de la iteración
        error ← _calcularError(x, x_anterior)

        // Almacenar resultados de la iteración
        resultado_iteracion ← []
        resultado_iteracion ← resultado_iteracion ∪ [iter + 1]  // Número de iteración
        resultado_iteracion ← resultado_iteracion ∪ x           // Valores de x
        resultado_iteracion ← resultado_iteracion ∪ _calcularErroresAbsolutos(x, x_anterior)  // Errores por variable
        resultado_iteracion ← resultado_iteracion ∪ [error]     // Error global

        resultados_iteracion ← resultados_iteracion ∪ [resultado_iteracion]
        
        iter ← iter + 1
    FIN MIENTRAS

    // Preparar resultados finales
    solucion_final ← copia de x
    error_final ← error
    iteraciones_totales ← iter

    RETORNAR éxito VERDADERO, solucion_final, resultados_iteracion, error_final

FIN ALGORITMO
```

## Método de Jacobi con Relajación

```pseudocode
ALGORITMO RelajacionJacobi
ENTRADAS:
    A: matriz de coeficientes n×n
    b: vector de términos independientes
    x0: vector inicial de aproximación
    omega: factor de relajación (ω > 0)
    tol: tolerancia de error
    max_iter: máximo número de iteraciones

SALIDAS:
    x: solución aproximada del sistema
    tabla_resultados: historial de iteraciones
    error_final: error global alcanzado
    convergio: indicador de convergencia

INICIO
    // Validar parámetros de entrada
    SI n ≤ 0 ENTONCES
        RETORNAR error "El número de ecuaciones debe ser mayor a 0"
    FIN SI
    
    SI matriz A está vacía ENTONCES
        RETORNAR error "Debe cargar la matriz aumentada primero"
    FIN SI
    
    SI longitud(x0) ≠ n ENTONCES
        RETORNAR error "El vector inicial debe tener n componentes"
    FIN SI
    
    SI tol ≤ 0 ENTONCES
        RETORNAR error "La tolerancia debe ser mayor que 0"
    FIN SI
    
    SI omega ≤ 0 ENTONCES
        RETORNAR error "El factor de relajación omega debe ser mayor que 0"
    FIN SI

    // Verificar dominancia diagonal (advertencia)
    SI NO _esDiagonalmenteDominante(A) ENTONCES
        MOSTRAR "Advertencia: La matriz no es diagonalmente dominante"
    FIN SI

    // Inicializar variables
    x_actual ← copia de x0
    x_siguiente ← vector de tamaño n inicializado en 0.0
    tabla_resultados ← []
    iteracion ← 1
    convergio ← FALSO
    error_global ← 0.0

    // Bucle principal de iteraciones
    MIENTRAS iteracion ≤ max_iter Y NO convergio HACER
        error_global ← 0.0
        
        // Calcular nueva aproximación para cada variable
        PARA i ← 0 HASTA n-1 HACER
            suma ← 0.0
            
            // Sumar contribuciones de otras variables
            PARA j ← 0 HASTA n-1 HACER
                SI j ≠ i ENTONCES
                    suma ← suma + A[i][j] * x_actual[j]
                FIN SI
            FIN PARA
            
            // Cálculo estándar de Jacobi
            x_jacobi ← (b[i] - suma) / A[i][i]
            
            // Aplicar factor de relajación
            x_siguiente[i] ← (1 - omega) * x_actual[i] + omega * x_jacobi
            
            // Actualizar error global
            error_variable ← |x_siguiente[i] - x_actual[i]|
            SI error_variable > error_global ENTONCES
                error_global ← error_variable
            FIN SI
        FIN PARA

        // Guardar resultados de la iteración
        fila_resultado ← [iteracion]
        fila_resultado ← fila_resultado ∪ x_siguiente                    // Valores de x
        fila_resultado ← fila_resultado ∪ _calcularErroresVariables(x_siguiente, x_actual)  // Errores por variable
        fila_resultado ← fila_resultado ∪ [error_global]                // Error global
        
        tabla_resultados ← tabla_resultados ∪ [fila_resultado]

        // Verificar convergencia
        SI error_global ≤ tol ENTONCES
            convergio ← VERDADERO
        SINO
            // Preparar siguiente iteración
            x_actual ← copia de x_siguiente
            iteracion ← iteracion + 1
        FIN SI
    FIN MIENTRAS

    // Preparar resultados finales
    SI convergio ENTONCES
        mensaje ← "Convergencia alcanzada en la iteración " + iteracion
    SINO
        mensaje ← "Máximo de iteraciones alcanzado sin convergencia"
    FIN SI

    RETORNAR x_siguiente, tabla_resultados, error_global, convergio

FIN ALGORITMO

// Función auxiliar: Verificar dominancia diagonal
ALGORITMO _esDiagonalmenteDominante(A)
    PARA i ← 0 HASTA n-1 HACER
        suma ← 0.0
        PARA j ← 0 HASTA n-1 HACER
            SI j ≠ i ENTONCES
                suma ← suma + |A[i][j]|
            FIN SI
        FIN PARA
        
        SI |A[i][i]| ≤ suma ENTONCES
            RETORNAR FALSO
        FIN SI
    FIN PARA
    
    RETORNAR VERDADERO
FIN ALGORITMO

// Función auxiliar: Calcular errores por variable
ALGORITMO _calcularErroresVariables(x_nuevo, x_anterior)
    errores ← []
    PARA i ← 0 HASTA n-1 HACER
        error ← |x_nuevo[i] - x_anterior[i]|
        errores ← errores ∪ [error]
    FIN PARA
    RETORNAR errores
FIN ALGORITMO
```

## Método de Gauss-Seidel con Relación (SOR)

```pseudocode
ALGORITMO GaussSeidelRelajacion
ENTRADAS:
    A: matriz de coeficientes n×n
    b: vector de términos independientes
    x0: vector inicial de aproximación
    omega: factor de relajación (0 < ω < 2)
    tol: tolerancia de error
    max_iter: máximo número de iteraciones

SALIDAS:
    x: solución aproximada del sistema
    tabla_resultados: historial de iteraciones
    error_final: error global alcanzado
    convergio: indicador de convergencia

INICIO
    // Validar parámetros de entrada
    SI n ≤ 0 ENTONCES
        RETORNAR error "El número de ecuaciones debe ser mayor a 0"
    FIN SI
    
    SI matriz A está vacía ENTONCES
        RETORNAR error "Debe cargar la matriz aumentada primero"
    FIN SI
    
    SI longitud(x0) ≠ n ENTONCES
        RETORNAR error "El vector inicial debe tener n componentes"
    FIN SI
    
    SI tol ≤ 0 ENTONCES
        RETORNAR error "La tolerancia debe ser mayor que 0"
    FIN SI
    
    SI omega ≤ 0 O omega ≥ 2 ENTONCES
        RETORNAR error "El factor de relajación omega debe estar en (0, 2)"
    FIN SI

    // Verificar elementos diagonales no nulos
    PARA i ← 0 HASTA n-1 HACER
        SI |A[i][i]| < 1e-15 ENTONCES
            RETORNAR error "Elemento diagonal a[" + (i+1) + "][" + (i+1) + "] es cero"
        FIN SI
    FIN PARA

    // Verificar dominancia diagonal (advertencia)
    SI NO _esDiagonalmenteDominante(A) ENTONCES
        tipo_relajacion ← SI omega < 1.0 ENTONCES "sub-relajación" SINO "sobre-relajación"
        MOSTRAR "Advertencia: Matriz no diagonalmente dominante. Usando " + tipo_relajacion
    FIN SI

    // Inicializar variables
    x_actual ← copia de x0
    x_anterior ← copia de x0  // Para cálculo de errores
    tabla_resultados ← []
    iteracion ← 1
    convergio ← FALSO
    error_global ← 0.0

    // Bucle principal de iteraciones
    MIENTRAS iteracion ≤ max_iter Y NO convergio HACER
        error_global ← 0.0
        
        // Guardar estado anterior para cálculo de errores
        x_anterior ← copia de x_actual
        
        // Calcular nueva aproximación para cada variable
        PARA i ← 0 HASTA n-1 HACER
            suma ← 0.0
            
            // Sumar términos con valores ya actualizados (j < i)
            PARA j ← 0 HASTA i-1 HACER
                suma ← suma + A[i][j] * x_actual[j]
            FIN PARA
            
            // Sumar términos con valores de iteración anterior (j > i)
            PARA j ← i+1 HASTA n-1 HACER
                suma ← suma + A[i][j] * x_anterior[j]
            FIN PARA
            
            // Cálculo estándar de Gauss-Seidel
            valor_gs ← (b[i] - suma) / A[i][i]
            
            // Aplicar relajación SOR
            x_actual[i] ← (1 - omega) * x_anterior[i] + omega * valor_gs
            
            // Actualizar error global
            error_variable ← |x_actual[i] - x_anterior[i]|
            SI error_variable > error_global ENTONCES
                error_global ← error_variable
            FIN SI
        FIN PARA

        // Guardar resultados de la iteración
        fila_resultado ← [iteracion]
        fila_resultado ← fila_resultado ∪ x_actual                    // Valores de x
        fila_resultado ← fila_resultado ∪ _calcularErroresVariables(x_actual, x_anterior)  // Errores por variable
        fila_resultado ← fila_resultado ∪ [error_global]             // Error global
        
        tabla_resultados ← tabla_resultados ∪ [fila_resultado]

        // Verificar convergencia
        SI error_global ≤ tol ENTONCES
            convergio ← VERDADERO
        SINO
            iteracion ← iteracion + 1
        FIN SI
    FIN MIENTRAS

    // Preparar resultados finales
    SI convergio ENTONCES
        tipo_relajacion ← SI omega = 1.0 ENTONCES "Gauss-Seidel estándar"
                      SINO SI omega < 1.0 ENTONCES "sub-relajación"
                      SINO "sobre-relajación"
        mensaje ← "Convergencia en iteración " + iteracion + " usando " + tipo_relajacion
    SINO
        mensaje ← "Máximo de iteraciones alcanzado sin convergencia"
    FIN SI

    RETORNAR x_actual, tabla_resultados, error_global, convergio

FIN ALGORITMO

// Función auxiliar: Verificar dominancia diagonal
ALGORITMO _esDiagonalmenteDominante(A)
    PARA i ← 0 HASTA n-1 HACER
        suma ← 0.0
        PARA j ← 0 HASTA n-1 HACER
            SI j ≠ i ENTONCES
                suma ← suma + |A[i][j]|
            FIN SI
        FIN PARA
        
        SI |A[i][i]| ≤ suma ENTONCES
            RETORNAR FALSO
        FIN SI
    FIN PARA
    
    RETORNAR VERDADERO
FIN ALGORITMO

// Función auxiliar: Calcular errores por variable
ALGORITMO _calcularErroresVariables(x_nuevo, x_anterior)
    errores ← []
    PARA i ← 0 HASTA n-1 HACER
        error ← |x_nuevo[i] - x_anterior[i]|
        errores ← errores ∪ [error]
    FIN PARA
    RETORNAR errores
FIN ALGORITMO
```

## Método de Integración por interpolación

```pseudocode
ALGORITMO IntegracionNumericaPorInterpolacion
ENTRADAS:
    funcion: función a integrar (string)
    limite_inferior: límite inferior de integración (real)
    limite_superior: límite superior de integración (real)
    n: número de subdivisiones (entero)
    dn: número de decimales para redondeo (entero)

SALIDAS:
    resultado_trapecio: integral por regla del trapecio
    resultado_simpson: integral por regla de Simpson
    resultado_simpson_compuesto: integral por regla de Simpson compuesta
    resultado_punto_medio: integral por regla del punto medio
    mensaje: estado de la ejecución

INICIO
    INICIALIZAR()
    
    // Validar parámetros
    error_validacion ← validarParametros()
    SI error_validacion ≠ NULO ENTONCES
        mensaje ← error_validacion
        éxito ← FALSO
        RETORNAR
    FIN SI

    // Calcular todos los métodos de integración
    calcularReglaTrapecio()
    calcularReglaSimpson()
    calcularReglaSimpsonCompuesta()
    calcularReglaPuntoMedio()

    // Establecer resultado principal
    resultado ← resultado_trapecio
    éxito ← VERDADERO
    iteraciones ← n
    mensaje ← "Métodos de integración calculados exitosamente"

    // Manejo de excepciones
    SI hay excepción ENTONCES
        éxito ← FALSO
        mensaje ← "Error en el cálculo: " + excepción.toString()
    FIN SI

FIN ALGORITMO

ALGORITMO calcularReglaTrapecio
    a ← limite_inferior
    b ← limite_superior
    h ← b - a
    
    f_a ← evaluarFuncion(a)
    f_b ← evaluarFuncion(b)
    
    resultado_trapecio ← (f_a + f_b) * h / 2.0
FIN ALGORITMO

ALGORITMO calcularReglaSimpson
    a ← limite_inferior
    b ← limite_superior
    h ← (b - a) / 2.0
    m ← (a + b) / 2.0  // Punto medio
    
    f_a ← evaluarFuncion(a)
    f_m ← evaluarFuncion(m)
    f_b ← evaluarFuncion(b)
    
    resultado_simpson ← (f_a + 4.0 * f_m + f_b) * h / 3.0
FIN ALGORITMO

ALGORITMO calcularReglaSimpsonCompuesta
    a ← limite_inferior
    b ← limite_superior
    n_ajustado ← n
    
    // Asegurar que n sea par para Simpson compuesto
    SI n_ajustado % 2 ≠ 0 ENTONCES
        n_ajustado ← n_ajustado + 1
    FIN SI
    
    h ← (b - a) / n_ajustado
    
    // Sumar términos impares
    suma_impares ← 0.0
    PARA i ← 1 HASTA n_ajustado-1 INCREMENTO 2 HACER
        x ← a + i * h
        suma_impares ← suma_impares + evaluarFuncion(x)
    FIN PARA
    
    // Sumar términos pares
    suma_pares ← 0.0
    PARA i ← 2 HASTA n_ajustado-2 INCREMENTO 2 HACER
        x ← a + i * h
        suma_pares ← suma_pares + evaluarFuncion(x)
    FIN PARA
    
    f_a ← evaluarFuncion(a)
    f_b ← evaluarFuncion(b)
    
    resultado_simpson_compuesto ← (f_a + f_b + 4.0 * suma_impares + 2.0 * suma_pares) * h / 3.0
FIN ALGORITMO

ALGORITMO calcularReglaPuntoMedio
    a ← limite_inferior
    b ← limite_superior
    h ← (b - a) / n
    
    suma ← 0.0
    PARA i ← 0 HASTA n-1 HACER
        x ← a + (i + 0.5) * h  // Punto medio de cada subintervalo
        suma ← suma + evaluarFuncion(x)
    FIN PARA
    
    resultado_punto_medio ← suma * h
FIN ALGORITMO

ALGORITMO calcularReglaTrapecioCompuesta
    a ← limite_inferior
    b ← limite_superior
    h ← (b - a) / n
    
    suma ← evaluarFuncion(a) + evaluarFuncion(b)
    
    PARA i ← 1 HASTA n-1 HACER
        x ← a + i * h
        suma ← suma + 2.0 * evaluarFuncion(x)
    FIN PARA
    
    resultado_trapecio ← suma * h / 2.0
FIN ALGORITMO
```
