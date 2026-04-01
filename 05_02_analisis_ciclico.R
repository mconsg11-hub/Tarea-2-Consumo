library(dplyr)
library(ggplot2)
library(mFilter)
library(reshape2)
library(tidyr)

# 1. Cargar datos
df <- read.csv("output/consumo_limpio.csv")
df$date <- as.Date(df$date)

# 2. Aplicar Filtro Hodrick-Prescott (lambda = 1600 para datos trimestrales)
# Trabajaremos con los logaritmos para obtener variaciones porcentuales aproximadas
hp_filter_cycle <- function(series) {
  l_series <- log(series)
  hp <- hpfilter(l_series, freq = 1600)
  return(as.numeric(hp$cycle))
}

df <- df %>%
  mutate(
    ciclo_total = hp_filter_cycle(total),
    ciclo_nacional = hp_filter_cycle(nacional),
    ciclo_importado = hp_filter_cycle(importado)
  )

# 3. Calcular Correlaciones
# Seleccionamos las variables de interés: ciclos de consumo, tasa real y tc_fix
var_interes <- df %>%
  select(ciclo_total, ciclo_nacional, ciclo_importado, tasa_real, tc_fix)

cor_matrix <- cor(var_interes, use = "complete.obs")
write.csv(cor_matrix, "output/matriz_correlacion.csv")

# 4. Generar Gráficas
# Gráfica 1: Componentes Cíclicos del Consumo
df_long <- df %>%
  select(date, ciclo_total, ciclo_nacional, ciclo_importado) %>%
  melt(id.vars = "date")

p1 <- ggplot(df_long, aes(x = date, y = value, color = variable)) +
  geom_line(size = 1) +
  labs(title = "Componentes Cíclicos del Consumo en México (Filtro HP)",
       subtitle = "Log-desviaciones de la tendencia (lambda = 1600)",
       x = "Año", y = "Ciclo", color = "Serie") +
  theme_minimal() +
  scale_color_manual(values = c("black", "blue", "red"))

ggsave("output/grafica_ciclos_consumo.png", p1, width = 10, height = 6)

# Gráfica 2: Consumo Total vs Tasa Real (Normalizados para visualización)
p2 <- ggplot(df, aes(x = date)) +
  geom_line(aes(y = ciclo_total, color = "Ciclo Consumo Total"), size = 1) +
  geom_line(aes(y = tasa_real / 10, color = "Tasa Real (Escala 1/10)"), linetype = "dashed") +
  labs(title = "Ciclo del Consumo vs Tasa de Interés Real",
       x = "Año", y = "Valor", color = "Variable") +
  theme_minimal()

ggsave("output/grafica_consumo_vs_tasa.png", p2, width = 10, height = 6)

# 5. Guardar resumen estadístico para Resultados.Rmd
resumen <- df %>%
  summarise(
    sd_total = sd(ciclo_total, na.rm = TRUE) * 100,
    sd_nacional = sd(ciclo_nacional, na.rm = TRUE) * 100,
    sd_importado = sd(ciclo_importado, na.rm = TRUE) * 100,
    cor_tasa = cor(ciclo_total, tasa_real, use = "pairwise.complete.obs"),
    cor_tc = cor(ciclo_total, tc_fix, use = "pairwise.complete.obs")
  )

write.csv(resumen, "output/resumen_estadistico.csv", row.names = FALSE)

cat("Análisis cíclico completado.\n")
cat("Artefactos generados en la carpeta output/:\n")
cat("- grafica_ciclos_consumo.png\n")
cat("- grafica_consumo_vs_tasa.png\n")
cat("- matriz_correlacion.csv\n")
cat("- resumen_estadistico.csv\n")
