# Plan de Trabajo - Tarea 2: Macroeconomía (Consumo)

Este plan detalla los pasos para completar los ejercicios 5, 6 y 7 de la Tarea 2, utilizando datos de INEGI, Banxico y fuentes financieras.

## Ejercicio 5: Comportamiento reciente del consumo en México y sus determinantes

### 1. Investigación y Obtención de Datos
*   **Paso 1.0:** Explícame la relación teórica entre el consumo agregado, la tasa de interés real y el tipo de cambio en un formato de diálogo y al final guarda el resultado en un archivo `Teoria_Consumo.md`.
*   **Paso 1.1:** Investigar en el BIE (INEGI) los identificadores de las series de Consumo privado total, de bienes nacionales e importados.
*   **Paso 1.2:** Investigar en el SIE (Banxico) los identificadores para el Tipo de Cambio FIX y la Tasa de Interés Real (o nominal e inflación para calcularla).
*   **Paso 1.3:** Crear el script `05_01_descarga_datos.R` para obtener y alinear las series trimestrales.

### 2. Procesamiento y Análisis
*   **Paso 2.1:** Crear el script `05_02_analisis_ciclico.R` para:
    *   Graficar series en niveles y logaritmos con marcos negros según el mandato.
    *   Calcular la tasa de crecimiento anual para eliminar la tendencia.
    *   Graficar las series filtradas y calcular la matriz de varianza-covarianza.
*   **Paso 2.2:** Realizar el análisis cualitativo sobre el impacto del tipo de cambio y las tasas en el consumo.

### 3. Reporte de Resultados
*   **Paso 3.1:** Actualizar `Resultados.Rmd` con las gráficas, la matriz de covarianza y la conclusión redactada (Inciso e).

---

## Ejercicio 6: Nivel de riqueza neta de los hogares (ENFIH-2019)

### 1. Investigación y Obtención de Datos
*   **Paso 1.0:** Explícame qué es la ENFIH, cuál es su objetivo y cómo se define técnicamente la "Riqueza Neta" en sus microdatos en un formato de diálogo y guarda el resultado en `Info_ENFIH.md`.
*   **Paso 1.1:** Localizar los microdatos de la ENFIH 2019 en el sitio del INEGI y verificar la estructura de las tablas de activos y pasivos.

### 2. Procesamiento y Análisis
*   **Paso 2.1:** Crear el script `06_01_procesar_enfih.R` para:
    *   Cargar y limpiar los microdatos.
    *   Calcular la riqueza neta por hogar y tabularla por tamaño de localidad (Inciso b).
    *   Generar el gráfico de dispersión Ingreso vs Riqueza (Inciso c).
    *   Tabular las estrategias ante gastos imprevistos (Inciso d).

### 3. Reporte de Resultados
*   **Paso 3.1:** Documentar los tabulados y gráficas en `Resultados.Rmd`, asegurando que los porcentajes incluyan su método de cálculo.

---

## Ejercicio 7: Acertijo del premio al riesgo

### 1. Investigación y Obtención de Datos
*   **Paso 1.0:** Explícame en qué consiste el "Equity Premium Puzzle" (Acertijo del premio al riesgo) y por qué es relevante para la macroeconomía en un formato de diálogo y guarda el resultado en `Acertijo_Riesgo.md`.
*   **Paso 1.1:** Obtener series anuales desde 1990 de IPC, IPyC (México), NASDAQ (EE.UU.) y TSX (Canadá) usando APIs financieras.
*   **Paso 1.2:** Obtener las tasas libres de riesgo correspondientes para cada país.

### 2. Procesamiento y Análisis
*   **Paso 2.1:** Crear el script `07_01_calculo_rra.R` para:
    *   Calcular retornos reales y premios por riesgo.
    *   Calcular la covarianza entre el premio al riesgo y el crecimiento del consumo (agregado y por componentes en México).
    *   Estimar el coeficiente de aversión relativa al riesgo (RRA).

### 3. Reporte de Resultados
*   **Paso 3.1:** Documentar los coeficientes RRA encontrados en `Resultados.Rmd` y discutir si los valores son "razonables" o confirman el acertijo.
