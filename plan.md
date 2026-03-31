# Plan de Trabajo - Tarea 2: Consumo, Macroeconomía 2

Este plan detalla los pasos para completar los ejercicios 5, 6 y 7 de la Tarea 2 sobre Consumo, utilizando datos de INEGI, Banco de México y Yahoo Finance.

---

## 5. Ejercicio 5: Comportamiento reciente del consumo en México

### 1. Investigación y Teoría
*   **Paso 1.0:** Explícame la relación teórica entre el consumo agregado, la tasa de interés real y el tipo de cambio y qué son los filtros de series de tiempo. [Contexto General]
*   **Paso 1.1:** Obtener datos trimestrales de "C", bienes nacionales e importados. **[Inciso 5a]**
*   **Paso 1.2:** Obtener datos de tipo de cambio y tasa de interés REAL. **[Inciso 5b]**

### 2. Procesamiento y Análisis en R
*   **Paso 1.3:** Crear el script `05_01_datos_consumo.R` para descarga y limpieza. **[Incisos 5a, 5b]**
*   **Paso 1.4:** Crear el script `05_02_analisis_ciclico.R`.
    *   Graficar series para compararlas visualmente. **[Inciso 5c]**
    *   Filtrar series para remover tendencia (tasa de cambio anual). **[Inciso 5d]**
    *   Obtener matriz de varianzas y covarianzas. **[Inciso 5d]**

### 3. Reporte de Resultados
*   **Paso 1.5:** Redactar conclusión sobre el impacto de la tasa de interés y tipo de cambio en el consumo. **[Inciso 5e]**

---

## 6. Ejercicio 6: Riqueza neta de los hogares (ENFIH-2019)

### 1. Investigación y Teoría
*   **Paso 2.0:** Explícame qué es la ENFIH y cómo se define técnicamente la "Riqueza Neta". [Contexto General]
*   **Paso 2.1:** Obtener los microdatos de la ENFIH-2019. **[Inciso 6a]**

### 2. Procesamiento de Microdatos
*   **Paso 2.2:** Crear el script `06_01_procesar_enfih.R`.
    *   Tabular el nivel de riqueza neta por tamaño de localidad. **[Inciso 6b]**
    *   Generar gráfica de dispersión entre ingreso corriente efectivo y riqueza neta. **[Inciso 6c]**
    *   Tabular respuestas sobre formas de atender gastos imprevistos. **[Inciso 6d]**

### 3. Reporte de Resultados
*   **Paso 2.4:** Interpretar la gráfica, el tabulado y los resultados a la luz de las variables agregadas. **[Inciso 6e, 6f]**

---

## 7. Ejercicio 7: Acertijo del premio al riesgo

### 1. Investigación y Teoría
*   **Paso 3.0:** Explícame en qué consiste el "Equity Premium Puzzle" y la teoría de la utilidad CRRA. [Contexto General]
*   **Paso 3.1:** Obtener valores anuales de IPC, IPyC (MX), NASDAQ (US) y TSX (Canadá) e identificar tasas libres de riesgo. **[Incisos 7a, 7b, 7c]**

### 2. Cálculo de Aversión al Riesgo
*   **Paso 3.2:** Crear el script `07_01_calculo_rra.R`.
    *   Calcular covarianzas entre diferencias (retornos) y crecimiento del consumo. **[Incisos 7d, 7e, 7f]**
    *   Calcular valor de aversión relativa al riesgo ($\gamma$). **[Inciso 7g]**
    *   Caso México: Calcular covarianzas por tipo de consumo (durables, servicios, importados). **[Inciso 7h, 7i]**

### 3. Reporte de Resultados
*   **Paso 3.3:** Interpretar los resultados internacionales y por tipo de consumo. **[Inciso 7j]**
