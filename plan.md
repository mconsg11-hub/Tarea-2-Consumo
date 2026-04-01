# Plan de Trabajo - Tarea 2: Consumo, Macroeconomía 2

Este plan detalla los pasos para completar los ejercicios 5, 6 y 7 de la Tarea 2 sobre Consumo, utilizando archivos descargados manualmente de INEGI y BANXICO.

---

## 5. Ejercicio 5: Comportamiento reciente del consumo en México

### 1. Investigación y Teoría

* **Paso 1.0:** Teoría de los determinantes del consumo y filtros de series. (Completado en `Teoria_Consumo.md`). [Contexto General]

### 2. Obtención de Datos (Manual)

* **Paso 1.1:** [x] El usuario descargó las series trimestrales de INEGI. Artefacto: `input/inegi_consumo.csv`.
* **Paso 1.2:** [x] El usuario descargó las series de BANXICO. Artefactos: `input/inflacion.csv`, `input/tasas_nominal.csv`, `input/tc_fix.csv`.
* **Paso 1.3:** [x] Crear el script `05_01_limpieza_consumo.R` para leer de la DB SQLite y exportar un dataset limpio. Artefactos: `05_01_limpieza_consumo.R`, `output/consumo_limpio.csv`.
* **Paso 1.4:** [x] Crear el script `05_02_analisis_ciclico.R` para generar gráficas y calcular la matriz de varianza-covarianza. Artefactos: `05_02_analisis_ciclico.R`, `output/grafica_ciclos_consumo.png`, `output/grafica_consumo_vs_tasa.png`, `output/matriz_correlacion.csv`, `output/resumen_estadistico.csv`.

### 4. Reporte de Resultados

* **Paso 1.5:** Documentar en `Resultados.Rmd` la interpretación del impacto de las variables financieras. **[Inciso 5e]**

---

## 6. Ejercicio 6: Riqueza neta de los hogares (ENFIH-2019)

### 1. Investigación y Teoría

* **Paso 2.0:** Explicación técnica sobre la ENFIH y la definición de Riqueza Neta. [Contexto General]

### 2. Obtención de Datos (Manual)

* **Paso 2.1:** El usuario descarga los microdatos de la **ENFIH 2019** del sitio del INEGI y los guarda en `inputs/`. **[Inciso 6a]**

### 3. Procesamiento de Microdatos

* **Paso 2.2:** Crear el script `06_01_procesar_enfih.R` para leer de `inputs/`, unir tablas y calcular riqueza neta. Exportar a `output/`. **[Incisos 6b, 6c, 6d]**

### 4. Reporte de Resultados

* **Paso 2.3:** Actualizar `Resultados.Rmd` con la interpretación micro vs macro. **[Incisos 6e, 6f]**

---

## 7. Ejercicio 7: Acertijo del premio al riesgo

### 1. Investigación y Teoría

* **Paso 3.0:** Teoría del Equity Premium Puzzle y utilidad CRRA. [Contexto General]

### 2. Obtención de Datos (Manual/Script)

* **Paso 3.1:** Obtener los índices IPyC (MX), NASDAQ (US) y TSX (CA) desde 1990 y tasas libres de riesgo. Guardar en `inputs/`. **[Incisos 7a, 7b, 7c]**

### 3. Procesamiento y Análisis

* **Paso 3.2:** Crear el script `07_01_calculo_rra.R` para calcular covarianzas y el coeficiente de aversión al riesgo. Resultados en `output/`. **[Incisos 7d a 7i]**

### 4. Reporte de Resultados

* **Paso 3.3:** Finalizar `Resultados.Rmd` con la comparativa internacional. **[Inciso 7j]**
