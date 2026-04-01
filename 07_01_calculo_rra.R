# Ejercicio 7: Acertijo del Premio al Riesgo
library(dplyr)

# 1. Cargar datos
df <- read.csv("input/datos_ejercicio_7.csv")

# 2. Funciones de cálculo
calcular_gamma <- function(ret, rf, gc) {
  excess_ret <- ret - rf
  mean_excess <- mean(excess_ret, na.rm = TRUE)
  covariance <- cov(excess_ret, gc, use = "complete.obs")
  gamma <- mean_excess / covariance
  return(list(mean_excess = mean_excess, cov = covariance, gamma = gamma))
}

# 3. Aplicar para los tres países
res_mx <- calcular_gamma(df$ret_mx, df$rf_mx, df$gc_mx)
res_us <- calcular_gamma(df$ret_us, df$rf_us, df$gc_us)
res_ca <- calcular_gamma(df$ret_ca, df$rf_ca, df$gc_ca)

# 4. Consolidar resultados (Inciso 7e)
resultados <- data.frame(
  Pais = c("México", "Estados Unidos", "Canadá"),
  Premio_Riesgo_Medio = c(res_mx$mean_excess, res_us$mean_excess, res_ca$mean_excess),
  Covarianza_Ret_Consumo = c(res_mx$cov, res_us$cov, res_ca$cov),
  Gamma_Estimado = c(res_mx$gamma, res_us$gamma, res_ca$gamma)
)

# 4.1 Resumen para Inciso 7d (Diferencias y Crecimiento)
resumen_7d <- df %>%
  summarise(
    Mean_GC_MX = mean(gc_mx, na.rm = TRUE),
    Mean_GC_US = mean(gc_us, na.rm = TRUE),
    Mean_GC_CA = mean(gc_ca, na.rm = TRUE)
  )

resultados_7d <- data.frame(
  Pais = c("México", "Estados Unidos", "Canadá"),
  Premio_Riesgo_Medio = resultados$Premio_Riesgo_Medio,
  Crecimiento_Consumo_Medio = c(resumen_7d$Mean_GC_MX, resumen_7d$Mean_GC_US, resumen_7d$Mean_GC_CA)
)

write.csv(resultados_7d, "output/resultados_7d.csv", row.names = FALSE)
write.csv(resultados, "output/resultados_ejercicio_7.csv", row.names = FALSE)

# 5. Generar Gráfica de Retornos Nominales (Inciso 7b)
library(ggplot2)
library(reshape2)

df_long_ret <- df %>%
  select(year, ret_mx, ret_us, ret_ca) %>%
  melt(id.vars = "year")

p_retornos <- ggplot(df_long_ret, aes(x = year, y = value, color = variable)) +
  geom_line(linewidth = 0.8) +
  geom_point() +
  geom_hline(yintercept = 0, linetype = "dashed", color = "black") +
  labs(title = "Rendimientos Nominales Anuales (1990-2024)",
       subtitle = "Comparativa: IPC (México), NASDAQ (EE. UU.) y TSX (Canadá)",
       x = "Año", y = "Rendimiento (Tasa)", color = "Índice") +
  scale_y_continuous(labels = scales::percent) +
  theme_minimal() +
  scale_color_manual(values = c("black", "blue", "red"),
                     labels = c("ret_mx" = "IPC (México)", "ret_us" = "NASDAQ (EE. UU.)", "ret_ca" = "TSX (Canadá)"))

ggsave("output/grafica_7b_retornos.png", p_retornos, width = 10, height = 6)

# 6. Generar Gráfica de Tasas Libres de Riesgo (Inciso 7c)
df_long_rf <- df %>%
  select(year, rf_mx, rf_us, rf_ca) %>%
  melt(id.vars = "year")

p_rf <- ggplot(df_long_rf, aes(x = year, y = value, color = variable)) +
  geom_line(linewidth = 1) +
  labs(title = "Tasas Libres de Riesgo (1990-2024)",
       subtitle = "Cetes 28d (México), T-Bills 3m (EE. UU. y Canadá)",
       x = "Año", y = "Tasa de Interés", color = "País") +
  scale_y_continuous(labels = scales::percent) +
  theme_minimal() +
  scale_color_manual(values = c("green", "darkblue", "darkred"),
                     labels = c("rf_mx" = "México (Cetes)", "rf_us" = "EE. UU. (T-Bill)", "rf_ca" = "Canadá (T-Bill)"))

ggsave("output/grafica_7c_rf.png", p_rf, width = 10, height = 6)

# 7. Resumen de Tasas de Interés
resumen_rf <- df %>%
  summarise(
    Mexico_Mean = mean(rf_mx),
    US_Mean = mean(rf_us),
    Canada_Mean = mean(rf_ca)
  )
write.csv(resumen_rf, "output/resumen_rf_7c.csv", row.names = FALSE)

cat("Cálculo del Equity Premium Puzzle, gráficas y resumen rf completados.\n")
print(resultados)
