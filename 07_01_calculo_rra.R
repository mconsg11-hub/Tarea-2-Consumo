# Ejercicio 7: Acertijo del Premio al Riesgo (Desglosado)
library(dplyr)
library(ggplot2)
library(reshape2)

# 1. Cargar datos
df <- read.csv("input/datos_ejercicio_7.csv")

# 2. Función de cálculo extendida
calcular_gamma_full <- function(ret, rf, gc, gd, gs, pais_name) {
  excess_ret <- ret - rf
  mean_excess <- mean(excess_ret, na.rm = TRUE)
  
  # Covarianzas
  cov_total <- cov(excess_ret, gc, use = "complete.obs")
  cov_dur <- cov(excess_ret, gd, use = "complete.obs")
  cov_ser <- cov(excess_ret, gs, use = "complete.obs")
  
  # Gammas
  gamma_total <- mean_excess / cov_total
  gamma_dur <- mean_excess / cov_dur
  gamma_ser <- mean_excess / cov_ser
  
  return(data.frame(
    Pais = pais_name,
    Premio_Riesgo = mean_excess,
    Gamma_Total = gamma_total,
    Gamma_Durables = gamma_dur,
    Gamma_Servicios = gamma_ser
  ))
}

# 3. Aplicar para los tres países
res_mx <- calcular_gamma_full(df$ret_mx, df$rf_mx, df$gc_mx, df$gd_mx, df$gs_mx, "México")
res_us <- calcular_gamma_full(df$ret_us, df$rf_us, df$gc_us, df$gd_us, df$gs_us, "Estados Unidos")
res_ca <- calcular_gamma_full(df$ret_ca, df$rf_ca, df$gc_ca, df$gd_ca, df$gs_ca, "Canadá")

resultados_finales <- rbind(res_mx, res_us, res_ca)
write.csv(resultados_finales, "output/resultados_ejercicio_7.csv", row.names = FALSE)

# 4. Gráfica Comparativa de Gammas
res_long <- resultados_finales %>%
  select(Pais, Gamma_Total, Gamma_Durables, Gamma_Servicios) %>%
  melt(id.vars = "Pais")

# Filtrar outliers (como el de US) para la gráfica si es necesario, 
# pero aquí los mantendremos para ver la magnitud del acertijo.
p_gammas <- ggplot(res_long, aes(x = Pais, y = value, fill = variable)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Coeficientes Gamma (Aversión al Riesgo) por Tipo de Consumo",
       subtitle = "Valores altos confirman el Equity Premium Puzzle",
       x = "País", y = "Gamma Estimado", fill = "Tipo de Consumo") +
  theme_minimal()

ggsave("output/grafica_7e_gammas.png", p_gammas, width = 10, height = 6)

cat("Cálculo desglosado del Equity Premium Puzzle completado.\n")
print(resultados_finales)
