# Script 05_02_analisis_ciclico.R
# Objetivo: Graficar series, filtrar ciclos y calcular matriz de covarianzas.
# Autor: Gemini CLI

# Cargar librerías
packages <- c("readr", "dplyr", "ggplot2", "tidyr", "reshape2")
for (p in packages) {
  if (!require(p, character.only = TRUE)) install.packages(p)
  library(p, character.only = TRUE)
}

# Leer datos limpios
df <- read_csv("output/consumo_limpio.csv", show_col_types = FALSE)

# Crear variable de tiempo para graficar
df <- df %>%
  mutate(fecha = as.Date(paste(year, (trimestre * 3), "01", sep = "-")))

# --- 1. INCISO 5c: GRÁFICAS EN NIVELES Y LOGARITMOS ---

# Preparar datos para niveles (Variables positivas)
df_niveles <- df %>%
  select(fecha, c_total, c_nacional, c_importado, tc_fix) %>%
  pivot_longer(-fecha, names_to = "variable", values_to = "valor")

plot_niveles <- ggplot(df_niveles, aes(x = fecha, y = valor, color = variable)) +
  geom_line(size = 1) +
  facet_wrap(~variable, scales = "free_y") +
  theme_bw() +
  labs(title = "Series de Tiempo en Niveles", subtitle = "Consumo y Tipo de Cambio", x = "Año", y = "Valor Original") +
  theme(panel.border = element_rect(colour = "black", fill=NA, size=1))

ggsave("output/05c_niveles.png", plot_niveles, width = 10, height = 7)

# Preparar datos para logaritmos
df_logs <- df %>%
  mutate(across(c(c_total, c_nacional, c_importado, tc_fix), log)) %>%
  select(fecha, c_total, c_nacional, c_importado, tc_fix) %>%
  pivot_longer(-fecha, names_to = "variable", values_to = "valor")

plot_logs <- ggplot(df_logs, aes(x = fecha, y = valor, color = variable)) +
  geom_line(size = 1) +
  facet_wrap(~variable, scales = "free_y") +
  theme_bw() +
  labs(title = "Series de Tiempo en Logaritmos", subtitle = "Transformación logarítmica para análisis de crecimiento", x = "Año", y = "Logaritmo Natural") +
  theme(panel.border = element_rect(colour = "black", fill=NA, size=1))

ggsave("output/05c_logaritmos.png", plot_logs, width = 10, height = 7)

# --- 2. INCISO 5d: FILTRADO (TASA DE CRECIMIENTO ANUAL) ---

# Filtrar para obtener el componente cíclico (Variación vs mismo trimestre año anterior)
df_ciclo <- df %>%
  arrange(fecha) %>%
  mutate(across(c(c_total, c_nacional, c_importado, tc_fix, tasa_real), 
                ~ (. - lag(., 4)) / lag(., 4) * 100, 
                .names = "ciclo_{.col}")) %>%
  filter(!is.na(ciclo_c_total))

# Graficar series filtradas juntas
df_ciclo_long <- df_ciclo %>%
  select(fecha, starts_with("ciclo_")) %>%
  pivot_longer(-fecha, names_to = "variable", values_to = "valor")

plot_ciclos <- ggplot(df_ciclo_long, aes(x = fecha, y = valor, color = variable)) +
  geom_line(size = 0.8) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray50") +
  theme_minimal() +
  labs(title = "Componentes Cíclicos (Tasa de Crecimiento Anual)", 
       subtitle = "Remoción de tendencia mediante diferencias estacionales",
       x = "Año", y = "Variación Porcentual Anual (%)") +
  theme(legend.position = "bottom",
        panel.border = element_rect(colour = "black", fill=NA, size=1))

ggsave("output/05d_ciclos.png", plot_ciclos, width = 10, height = 6)

# --- 3. INCISO 5d: MATRIZ DE VARIANZA-COVARIANZA ---

matriz_cov <- df_ciclo %>%
  select(ciclo_c_total, ciclo_c_nacional, ciclo_c_importado, ciclo_tc_fix, ciclo_tasa_real) %>%
  rename(C_Total = ciclo_c_total, C_Nacional = ciclo_c_nacional, 
         C_Importado = ciclo_c_importado, TC_Fix = ciclo_tc_fix, Tasa_Real = ciclo_tasa_real) %>%
  cov()

# Guardar matriz en CSV
write.csv(matriz_cov, "output/05d_matriz_covarianza.csv")

print("--- RESULTADOS DEL EJERCICIO 5 ---")
print("1. Gráficas guardadas en la carpeta 'output/'.")
print("2. Matriz de Varianza-Covarianza de los ciclos:")
print(matriz_cov)
