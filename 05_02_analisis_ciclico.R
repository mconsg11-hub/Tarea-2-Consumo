library(dplyr)
library(ggplot2)
library(mFilter)
library(reshape2)
library(tidyr)

# 1. Cargar datos
df <- read.csv("output/consumo_limpio.csv")
df$date <- as.Date(df$date)

# 2. [Inciso 5c] Graficar series de tiempo juntas (Niveles)
df_niveles <- df %>%
  select(date, total, nacional, importado) %>%
  melt(id.vars = "date")

p_niveles <- ggplot(df_niveles, aes(x = date, y = value / 1e6, color = variable)) +
  geom_line(linewidth = 1) +
  labs(title = "Consumo Privado en México (Niveles)",
       subtitle = "Millones de pesos a precios constantes de 2018",
       x = "Año", y = "Millones de Pesos", color = "Serie") +
  theme_minimal() +
  scale_color_manual(values = c("black", "blue", "red"))

ggsave("output/grafica_5c_niveles.png", p_niveles, width = 10, height = 6)

# 3. [Inciso 5d] Filtrado por Tasa de Cambio Anual (Growth Rates)
# La tasa anual se calcula como (y_t / y_{t-4}) - 1
df_growth <- df %>%
  arrange(date) %>%
  mutate(
    growth_total = (total / lag(total, 4)) - 1,
    growth_nacional = (nacional / lag(nacional, 4)) - 1,
    growth_importado = (importado / lag(importado, 4)) - 1
  ) %>%
  filter(!is.na(growth_total))

# Graficar tasas de crecimiento anual juntas
df_growth_long <- df_growth %>%
  select(date, growth_total, growth_nacional, growth_importado) %>%
  melt(id.vars = "date")

p_growth <- ggplot(df_growth_long, aes(x = date, y = value, color = variable)) +
  geom_line(linewidth = 1) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  labs(title = "Tasas de Crecimiento Anual del Consumo",
       subtitle = "Variación porcentual respecto al mismo trimestre del año anterior",
       x = "Año", y = "Tasa de Crecimiento", color = "Serie") +
  scale_y_continuous(labels = scales::percent) +
  theme_minimal() +
  scale_color_manual(values = c("black", "blue", "red"))

ggsave("output/grafica_5d_growth.png", p_growth, width = 10, height = 6)

# Matriz de Varianza-Covarianza de las tasas de crecimiento
var_cov_growth <- cov(df_growth %>% select(growth_total, growth_nacional, growth_importado))
write.csv(var_cov_growth, "output/matriz_var_cov_growth.csv")

# 4. Mantener análisis de Filtro HP (ya realizado pero consolidado)
hp_filter_cycle <- function(series) {
  l_series <- log(series)
  hp <- hpfilter(l_series, freq = 1600)
  return(as.numeric(hp$cycle))
}

df_hp <- df %>%
  mutate(
    ciclo_total = hp_filter_cycle(total),
    ciclo_nacional = hp_filter_cycle(nacional),
    ciclo_importado = hp_filter_cycle(importado)
  )

# Resumen estadístico consolidado
resumen <- data.frame(
  Variable = c("Total", "Nacional", "Importado"),
  Volatilidad_HP = c(sd(df_hp$ciclo_total) * 100, sd(df_hp$ciclo_nacional) * 100, sd(df_hp$ciclo_importado) * 100),
  Volatilidad_Growth = c(sd(df_growth$growth_total) * 100, sd(df_growth$growth_nacional) * 100, sd(df_growth$growth_importado) * 100),
  Cor_TasaReal_HP = c(cor(df_hp$ciclo_total, df_hp$tasa_real, use="pairwise"), NA, NA),
  Cor_TCFix_HP = c(cor(df_hp$ciclo_total, df_hp$tc_fix, use="pairwise"), NA, NA)
)

write.csv(resumen, "output/resumen_ejercicio_5.csv", row.names = FALSE)

cat("Análisis del Ejercicio 5 (Incisos c y d) completado.\n")
