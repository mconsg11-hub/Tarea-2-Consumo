library(RSQLite)
library(dplyr)
library(tidyr)
library(lubridate)

# Conexión a la base de datos
db_path <- "output/macroeconomia_consumo.sqlite"
con <- dbConnect(SQLite(), db_path)

# 1. Cargar y limpiar inegi_consumo
consumo_raw <- dbReadTable(con, "inegi_consumo")

# Identificar columnas por posición ya que los nombres son muy largos
# Col 1: Periodo, Col 2: Total, Col 3: Nacional, Col 4: Importado
consumo <- consumo_raw %>%
  rename(periodo_raw = 1, total = 2, nacional = 3, importado = 4) %>%
  mutate(
    year = as.numeric(substr(periodo_raw, 1, 4)),
    quarter = as.numeric(substr(periodo_raw, 6, 7)),
    date = ymd(paste(year, (quarter - 1) * 3 + 1, "01", sep = "-")),
    across(c(total, nacional, importado), as.numeric)
  ) %>%
  filter(!is.na(year), year >= 2000) %>%
  select(date, year, quarter, total, nacional, importado)

# 2. Cargar y limpiar inflacion (Mensual)
inflacion_raw <- dbReadTable(con, "inflacion")
# Omitir las primeras filas de metadatos
inflacion <- inflacion_raw %>%
  rename(periodo_raw = 1, indice = 2) %>%
  mutate(indice = as.numeric(indice)) %>%
  filter(!is.na(indice)) %>%
  mutate(
    date_val = dmy(periodo_raw),
    year = year(date_val),
    month = month(date_val),
    quarter = (month - 1) %/% 3 + 1
  ) %>%
  filter(year >= 1999) %>% # Necesitamos 1999 para calcular la inflación de inicios de 2000
  arrange(date_val) %>%
  mutate(infl_mensual = (indice / lag(indice) - 1))

# Trimestralizar inflación (promedio del trimestre o fin de trimestre)
# Usaremos el promedio de la inflación mensual en el trimestre para una tasa trimestral
inflacion_q <- inflacion %>%
  group_by(year, quarter) %>%
  summarise(infl_trimestral = prod(1 + infl_mensual, na.rm = TRUE) - 1, .groups = "drop") %>%
  mutate(infl_anualizada = (1 + infl_trimestral)^4 - 1)

# 3. Cargar y limpiar tasas_nominal (Cetes 28 días)
tasas_raw <- dbReadTable(con, "tasas_nominal")
tasas <- tasas_raw %>%
  rename(periodo_raw = 1, cetes28 = 2) %>%
  mutate(cetes28 = as.numeric(cetes28)) %>%
  filter(!is.na(cetes28)) %>%
  mutate(
    date_val = dmy(periodo_raw),
    year = year(date_val),
    quarter = quarter(date_val)
  ) %>%
  filter(year >= 2000) %>%
  group_by(year, quarter) %>%
  summarise(tasa_nominal = mean(cetes28, na.rm = TRUE) / 100, .groups = "drop")

# 4. Cargar y limpiar tc_fix
tc_raw <- dbReadTable(con, "tc_fix")
tc <- tc_raw %>%
  rename(periodo_raw = 1, tc = 2) %>%
  mutate(tc = as.numeric(tc)) %>%
  filter(!is.na(tc)) %>%
  mutate(
    date_val = dmy(periodo_raw),
    year = year(date_val),
    quarter = quarter(date_val)
  ) %>%
  filter(year >= 2000) %>%
  group_by(year, quarter) %>%
  summarise(tc_fix = mean(tc, na.rm = TRUE), .groups = "drop")

# 5. Unir y calcular Tasa Real
df_final <- consumo %>%
  left_join(inflacion_q, by = c("year", "quarter")) %>%
  left_join(tasas, by = c("year", "quarter")) %>%
  left_join(tc, by = c("year", "quarter")) %>%
  mutate(
    tasa_real = (1 + tasa_nominal) / (1 + infl_anualizada) - 1
  ) %>%
  filter(!is.na(total))

# Guardar resultado
write.csv(df_final, "output/consumo_limpio.csv", row.names = FALSE)
dbDisconnect(con)

cat("Dataset limpio generado en output/consumo_limpio.csv\n")
print(head(df_final))
