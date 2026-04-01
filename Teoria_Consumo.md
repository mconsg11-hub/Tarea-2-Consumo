# Determinantes del Consumo y Análisis de Ciclos Económicos

## 1. Determinantes Macroeconómicos del Consumo Privado

El consumo privado es el componente más estable y significativo del Producto Interno Bruto (PIB). Su comportamiento responde no solo al ingreso disponible, sino a variables financieras que alteran las decisiones intertemporales de los hogares.

### 1.1. La Tasa de Interés Real
Desde la perspectiva de la teoría del ciclo de vida y la hipótesis del ingreso permanente, la tasa de interés real ($r$) representa el precio relativo del consumo presente frente al consumo futuro. Un cambio en la tasa de interés real genera dos efectos principales:

*   **Efecto Sustitución:** Un aumento en $r$ eleva el costo de oportunidad del consumo actual, incentivando el ahorro y posponiendo el gasto hacia periodos futuros. Este efecto tiende a reducir el consumo presente.
*   **Efecto Ingreso:** Para los hogares que son acreedores netos, un incremento en $r$ aumenta su riqueza financiera total, lo que les permite incrementar su consumo en todos los periodos. Para los deudores netos, el efecto es el opuesto.

En economías emergentes como México, la evidencia empírica sugiere que el efecto sustitución predomina, estableciendo una relación inversa entre la tasa de interés real y el consumo agregado.

### 1.2. El Tipo de Cambio Real
En una economía abierta, el tipo de cambio afecta el consumo a través de la composición de la canasta de gasto:

*   **Precios Relativos:** Una depreciación de la moneda nacional encarece los bienes importados en relación con los nacionales. Esto induce una sustitución en el consumo hacia bienes de origen interno.
*   **Efecto Riqueza y Balance:** Si los hogares poseen pasivos denominados en moneda extranjera, una depreciación reduce su riqueza neta, contrayendo el consumo total debido a restricciones presupuestarias más estrictas.

---

## 2. Tratamiento de Series de Tiempo: Tendencia y Ciclo

Las variables macroeconómicas suelen presentar una trayectoria de crecimiento de largo plazo denominada **tendencia**, sobre la cual se superponen fluctuaciones transitorias conocidas como **ciclo económico**. Para el análisis de corto plazo, es imperativo separar ambos componentes.

### 2.1. Métodos de Filtrado y Descomposición

#### A. Filtro Hodrick-Prescott (HP)
Es un algoritmo que descompone una serie $y_t$ en una tendencia suavizada $\tau_t$ y un componente cíclico $c_t$, minimizando la varianza del ciclo y la curvatura de la tendencia. El parámetro de suavización ($\lambda$) determina la sensibilidad de la tendencia a las fluctuaciones; para datos trimestrales, el valor estándar es $\lambda = 1600$.

#### B. Tasas de Crecimiento Anual
Constituye uno de los métodos más directos para remover la tendencia de una serie con fuerte componente estacional o tendencial. Al calcular la variación porcentual respecto al mismo periodo del año anterior:
$$\Delta\% y_t = \frac{y_t - y_{t-4}}{y_{t-4}}$$
se elimina la tendencia lineal y la estacionalidad de cuarto orden, aislando la dinámica de crecimiento de corto plazo.

#### C. Filtros de Banda (Band-Pass)
Estos filtros (como el de Christiano-Fitzgerald) aíslan frecuencias específicas de la serie original. En macroeconomía, se configuran para capturar frecuencias asociadas a ciclos de negocios (típicamente entre 6 y 32 trimestres), eliminando tanto el ruido de muy alta frecuencia como la tendencia de baja frecuencia.
