# SAMNU

_Versión v1.0.0_

## Acerca de

SAMNU (Software de Algoritmos Matemáticos Nivel Universitario) es un programa integral orientado a la resolución de algoritmos numéricos de manera didáctica. Cuenta con diversas herramientas para realizar cálculos avanzados y crear documentos detallados, diseñado específicamente para estudiantes, en el área de matemáticas, ingeniería y ciencias.

### Características Principales

- **Amplia Gama de Métodos Numéricos**: Más de 30 algoritmos implementados cubriendo todas las áreas principales del análisis numérico
- **Interfaz Didáctica**: Diseñado para facilitar el aprendizaje con visualización paso a paso de los procedimientos
- **Generación de Documentos**: Capacidad para crear PDFs detallados con resultados, tablas y carátula.
- **Parser Matemático Avanzado**: Soporte para expresiones matemáticas complejas con notación natural
- **Precisión Controlada**: Configuración flexible de tolerancias y precisión numérica
- **Exportación de Resultados**: Opciones múltiples para guardar y compartir cálculos

## Métodos Numéricos Disponibles

### Ecuaciones No Lineales

- Método de Bisección
- Método de Punto Fijo
- Método de Newton-Raphson
- Método de la Secante
- Método de la Posición Falsa
- Método de Steffensen
- Método de Müller

### Interpolación y Aproximación

- Polinomios de Lagrange
- Método de Neville
- Diferencias Divididas de Newton

### Sistemas de Ecuaciones Lineales

- Método de Jacobi
- Método de Gauss-Seidel
- Eliminación Gaussiana con Sustitución hacia Atrás
- Factorización LU
- Factorización QR
- Factorización de Schur
- Métodos de Relajación (SOR)

### Sistemas de Ecuaciones No Lineales

- Punto Fijo para 2 y 3 Variables
- Newton para 2 y 3 Variables

### Derivación e Integración Numérica

- Derivación Numérica (diferencias finitas)
- Método de Romberg
- Cuadratura de Gauss
- Integración por Interpolación

### Ecuaciones Diferenciales Ordinarias

- Método de Euler
- Método de Runge-Kutta de 4º Orden
- Método de Adams-Bashforth-Moulton
- Runge-Kutta para Sistemas (2 y 3 Variables)

### Ecuaciones Diferenciales en Derivadas Parciales

- **Problemas de Valor en la Frontera**: Método del Disparo (Lineal y No Lineal)
- **Diferencias Finitas**: Lineal y No Lineal
- **Ecuaciones Elípticas**: Ecuación de Poisson
- **Ecuaciones Parabólicas**: Ecuación del Calor
- **Ecuaciones Hiperbólicas**: Ecuación de Onda

## Parser Matemático

SAMNU incluye un potente parser matemático que permite:

- **Notación Natural**: Escritura intuitiva de expresiones matemáticas
- **Multiplicación Implícita**: `2x`, `3sin(x)`, `(x+1)(x-2)`
- **Funciones Avanzadas**: Trigonométricas, hiperbólicas, logarítmicas, exponenciales
- **Constantes Matemáticas**: π, e
- **Múltiples Variables**: x, y, z, t, u1, u2, u3
- **Notación Científica**: `1.5e-3`, `2E5`
- **Operaciones Numéricas**: Derivadas parciales, gradientes, jacobianos

## Tecnologías

SAMNU está desarrollado utilizando:

- **Dart**: Lenguaje principal de programación
- **Flutter**: Framework para la interfaz de usuario multiplataforma
- **Algoritmos Optimizados**: Implementaciones eficientes de métodos numéricos clásicos

## Manuales

### Documentación Disponible

1. **[Algoritmos Disponibles](Algoritms.md)**: Documentación detallada de todos los métodos numéricos implementados con pseudocódigo.

2. **[Parser Matemático](MathParser.md)**: Guía completa sobre la sintaxis, funciones y capacidades del parser matemático de SAMNU.

3. **Guías de Uso**: Para cada método, SAMNU proporciona:
   - Explicación rápida del algoritmo
   - Requisitos y condiciones de convergencia
   - Tablas de resultados detalladas
   - Análisis de errores y precisión

## Contáctanos

### Información de Contacto

**Desarrollado por Trebol4Devop**: trebol4devop@proton.me

### Recursos del Proyecto

- **Repositorio GitHub de código abierto**: [github.com/Carlosdelcid05/SAMNU](https://github.com/Carlosdelcid05/SAMNU)
- **Issues y Sugerencias**: Reporte de problemas y solicitud de nuevas características
- **Documentación Técnica**: Código fuente disponible para estudio y contribución

### Contribuir

SAMNU es un proyecto educativo abierto. Si deseas contribuir:

1. **Reporte de Errores**: Ayúdanos a identificar y corregir problemas
2. **Sugerencias de Métodos**: Proponga nuevos algoritmos numéricos
3. **Mejoras Documentales**: Contribuya a mejorar la documentación

### Licencia

SAMNU cuenta con dos versiones oficiales, una de código abierto y otra privativa enfocada a la implementación del software en instituciones educativas.

---

**Versión Actual**: v1.0.0  
**Última Actualización**: 2025  
**Compatibilidad**: Windows, macOS, Linux, Android y IOS

*Para más información detallada sobre cada método numérico, consulte la documentación completa en [Algoritms.md](Algoritms.md).*
