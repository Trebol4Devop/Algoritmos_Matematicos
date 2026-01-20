# Math Parser

El parser matematico para SAMNU  cuenta con la función de reconocer expresiones complejas que son ingresadas para resolver cálculos numéricos y evaluaciones de sistemas. Esta herramienta permite la entrada de notación matemática natural, soportando multiplicaciones implícitas, notación científica y una amplia gama de funciones.

## 1. Sintaxis General

El parser es flexible en cuanto al formato de entrada:
* **Espacios:** Los espacios en blanco son ignorados (se eliminan automáticamente).
* **Mayúsculas/Minúsculas:** La entrada no distingue entre mayúsculas y minúsculas (e.g., `SIN(x)` es igual a `sin(x)`).
* **Signos:** Se normalizan automáticamente secuencias de signos (e.g., `+-` se convierte en `-`, `--` se convierte en `+`).

## 2. Operadores Soportados

Se respetan las reglas estándar de precedencia de operadores (PEMDAS).

| Operador | Descripción | Prioridad | Ejemplo |
| :---: | :--- | :---: | :--- | 
| `^` | Potencia | Alta | `x^2` |
| `*` | Multiplicación | Media | `2*x` |
| `/` | División | Media | `x/2` |
| `+` | Suma | Baja | `x+5` |
| `-` | Resta | Baja | `x-5` |
| `()` | Agrupación | Máxima | `(x+1)*2` |

## 3. Funciones Disponibles

El parser soporta las siguientes funciones matemáticas. Los argumentos deben estar entre paréntesis.

### Trigonométricas
| Función | Descripción | Dominio |
| :--- | :--- | :--- |
| `sin(x)` | Seno | Todos los reales |
| `cos(x)` | Coseno | Todos los reales |
| `tan(x)` | Tangente | $x \neq \pi/2 + k\pi$ |
| `asin(x)` | Arcoseno | $[-1, 1]$ |
| `acos(x)` | Arcocoseno | $[-1, 1]$ |
| `atan(x)` | Arcotangente | Todos los reales |

### Hiperbólicas
| Función | Descripción |
| :--- | :--- |
| `sinh(x)` | Seno hiperbólico |
| `cosh(x)` | Coseno hiperbólico |
| `tanh(x)` | Tangente hiperbólica |

### Logarítmicas y Exponenciales
| Función | Descripción | Notas |
| :--- | :--- | :--- |
| `ln(x)` o `log(x)` | Logaritmo natural (Base $e$) | $x > 0$ |
| `log10(x)` | Logaritmo base 10 | $x > 0$ |
| `log2(x)` | Logaritmo base 2 | $x > 0$ |
| `exp(x)` | Exponencial ($e^x$) | |
| `sqrt(x)` | Raíz cuadrada | $x \geq 0$ |
| `cbrt(x)` | Raíz cúbica | |

### Otras Funciones
| Función | Descripción | Argumentos |
| :--- | :--- | :--- |
| `abs(x)` | Valor absoluto | 1 |
| `ceil(x)` | Redondeo hacia arriba | 1 |
| `floor(x)` | Redondeo hacia abajo | 1 |
| `round(x)` | Redondeo al entero más cercano | 1 |
| `pow(base, exp)` | Potencia explícita | 2 |
| `max(a, b)` | Máximo entre dos valores | 2 |
| `min(a, b)` | Mínimo entre dos valores | 2 |

## 4. Constantes

El parser identifica automáticamente las siguientes constantes matemáticas:

* **pi**: Número $\pi$ ($\approx 3.14159...$).
* **e**: Número de Euler ($\approx 2.71828...$).

*Nota: Estas constantes pueden usarse en combinación con números sin operador explícito (ej. `2pi`).*

## 5. Variables Soportadas

Dependiendo del contexto de la evaluación (evaluación simple, sistemas de ecuaciones, o funciones multivariables), se aceptan las siguientes variables:

* **Coordenadas:** `x`, `y`, `z`
* **Tiempo:** `t`
* **Variables de Estado:** `u1`, `u2`, `u3`

El parser permite inyectar mapas de variables personalizadas mediante el método `evaluarExpresion`.

## 6. Características Avanzadas

### Multiplicación Implícita
El parser deduce la multiplicación cuando se omite el operador `*` en los siguientes casos:

1.  **Número seguido de Variable:** `2x` $\rightarrow$ `2*x`
2.  **Número seguido de Función:** `3sin(x)` $\rightarrow$ `3*sin(x)`
3.  **Número seguido de Paréntesis:** `4(x+1)` $\rightarrow$ `4*(x+1)`
4.  **Variable seguida de Paréntesis:** `x(y+1)` $\rightarrow$ `x*(y+1)` (Siempre que la variable no sea el nombre de una función).
5.  **Paréntesis seguido de Paréntesis:** `(x+1)(x-1)` $\rightarrow$ `(x+1)*(x-1)`
6.  **Entre variables:** `xy` $\rightarrow$ `x*y`

### Notación Científica
Se soporta la entrada de números grandes o pequeños usando `e` o `E`:
* `1.5e-3` ($\rightarrow 0.0015$)
* `2E5` ($\rightarrow 200000$)

### Cálculo Numérico
El parser incluye utilidades para cálculo diferencial numérico utilizando el método de diferencias finitas con un paso $h = 1 \times 10^{-7}$:
* **Derivada Parcial:** `derivadaParcialNumerica`
* **Gradiente:** `gradienteNumerico` (Vector de derivadas parciales).
* **Jacobiano:** `jacobianoNumerico` (Matriz de derivadas para sistemas de funciones).

## 7. Limitaciones y Restricciones (Lo que NO acepta)

Para evitar errores en tiempo de ejecución, tenga en cuenta lo siguiente que **no** es soportado:

1.  **Asignación de valores:** No se pueden asignar variables dentro de la expresión (ej. `x = 5 + y` es inválido).
2.  **Estructuras de control:** No soporta `if`, `else`, bucles o lógica de programación.
3.  **Números Complejos:** Todas las operaciones resultan en números reales tipo `double`. Raíces pares de números negativos (`sqrt(-1)`) lanzarán una excepción.
4.  **Comentarios:** No se admite texto explicativo ni comentarios dentro del string de la expresión.
5.  **Funciones desconocidas:** Cualquier texto que parezca una función pero no esté en la lista blanca (sección 3) generará un error.
6.  **Paréntesis desbalanceados:** Abrir un paréntesis sin cerrarlo causará un error inmediato.

## 8. Ejemplos de Expresiones Válidas

| Entrada Usuario | Interpretación Interna |
| :--- | :--- |
| `2x + 5` | `2*x + 5` |
| `sin(x)^2 + cos(x)^2` | `pow(sin(x), 2) + pow(cos(x), 2)` |
| `3pi * e^(-t)` | `3*3.1415... * exp(-t)` |
| `(a+b)(a-b)` | `(a+b)*(a-b)` |
| `max(x, 100)` | `max(x, 100)` |
| `-5.2e-2` | `-0.052` |