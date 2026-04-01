library(dplyr)
library(ggplot2)
library(tidyr)

# 1. Cargar datos (solo columnas necesarias para ahorrar memoria)
path_concentradora <- "input/conjunto_de_datos_tconcentradora_enfih_2019/conjunto_de_datos/conjunto_de_datos_tconcentradora_enfih_2019.csv"
path_modulo <- "input/conjunto_de_datos_tmodulo_enfih_2019/conjunto_de_datos/conjunto_de_datos_tmodulo_enfih_2019.csv"

concentradora <- read.csv(path_concentradora) %>%
  mutate(across(c(FAC_HOG, RIQ_NET, VAL_ACTIV, MTO_CTOT, ING_TOTAL), as.numeric))

modulo <- read.csv(path_modulo) %>%
  filter(N_REN == 1 | N_REN == "01")

# 2. Identificar formas de pago de imprevistos de manera eficiente
# Buscamos en todas las columnas P10_2_... si aparece el código 1 (Ahorros) o 3 (Familiares)
cols_p10 <- grep("^P10_2", names(modulo), value = TRUE)

modulo$Usa_Ahorros <- apply(modulo[cols_p10], 1, function(x) any(x %in% c(1, "1")))
modulo$Usa_Familiares <- apply(modulo[cols_p10], 1, function(x) any(x %in% c(3, "3")))
modulo$Usa_Prestamo <- apply(modulo[cols_p10], 1, function(x) any(x %in% c(4, "4")))

modulo_clean <- modulo %>%
  select(FOLIO, VIV_SEL, HOGAR, TLOC, Usa_Ahorros, Usa_Familiares, Usa_Prestamo)

df_enfih <- concentradora %>%
  left_join(modulo_clean, by = c("FOLIO", "VIV_SEL", "HOGAR"))

# 3. [Inciso 6b] Tabular Riqueza Neta por TLOC
resumen_tloc <- df_enfih %>%
  group_by(TLOC) %>%
  summarise(
    Hogares_Estimados = sum(FAC_HOG, na.rm = TRUE),
    Riqueza_Media = weighted.mean(RIQ_NET, FAC_HOG, na.rm = TRUE),
    Activos_Medios = weighted.mean(VAL_ACTIV, FAC_HOG, na.rm = TRUE),
    Deuda_Media = weighted.mean(MTO_CTOT, FAC_HOG, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(Localidad = case_when(
    TLOC == 1 ~ "100,000 y más hab",
    TLOC == 2 ~ "15,000 a 99,999 hab",
    TLOC == 3 ~ "2,500 a 14,999 hab",
    TLOC == 4 ~ "Menos de 2,500 hab",
    TRUE ~ "Desconocido"
  ))

write.csv(resumen_tloc, "output/tabla_6b_riqueza_tloc.csv", row.names = FALSE)

# 4. [Inciso 6c] Gráfico de Dispersión
p_dispersion <- ggplot(df_enfih %>% filter(ING_TOTAL > 1, RIQ_NET > 1), aes(x = ING_TOTAL, y = RIQ_NET)) +
  geom_point(alpha = 0.05, color = "blue") +
  scale_x_log10(labels = scales::comma) +
  scale_y_log10(labels = scales::comma) +
  geom_smooth(method = "lm", color = "red") +
  labs(title = "Relación entre Ingreso Corriente y Riqueza Neta",
       subtitle = "ENFIH 2019 (Escala Logarítmica)",
       x = "Ingreso Total Mensual (Log)", y = "Riqueza Neta (Log)") +
  theme_minimal()

ggsave("output/grafica_6c_dispersion.png", p_dispersion, width = 10, height = 6)

# 5. [Inciso 6d] Formas de atender imprevistos
imprevistos_tloc <- df_enfih %>%
  group_by(TLOC) %>%
  summarise(
    Pct_Ahorros = sum(FAC_HOG[Usa_Ahorros == TRUE], na.rm = TRUE) / sum(FAC_HOG, na.rm = TRUE) * 100,
    Pct_Familiares = sum(FAC_HOG[Usa_Familiares == TRUE], na.rm = TRUE) / sum(FAC_HOG, na.rm = TRUE) * 100,
    Pct_Prestamo = sum(FAC_HOG[Usa_Prestamo == TRUE], na.rm = TRUE) / sum(FAC_HOG, na.rm = TRUE) * 100,
    .groups = "drop"
  ) %>%
  mutate(Localidad = resumen_tloc$Localidad)

write.csv(imprevistos_tloc, "output/tabla_6d_imprevistos_tloc.csv", row.names = FALSE)

cat("Procesamiento de ENFIH completado con éxito.\n")
