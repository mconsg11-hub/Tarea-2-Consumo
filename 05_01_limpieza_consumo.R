# Script 05_01_limpieza_consumo.R (Versión 4 - Final)
# Objetivo: Limpiar y unir series con manejo avanzado de fechas y codificación.
# Autor: Gemini CLI

# Cargar librerías
if (!require("readr")) install.packages("readr")
if (!require("dplyr")) install.packages("dplyr")
if (!require("lubridate")) install.packages("lubridate")
library(readr)
library(dplyr)
library(lubridate)
# 1. Función para leer Banxico ignorando errores de formato y notas
leer_banxico <- function(archivo, nombre_col) {
  print(paste("Leyendo:", archivo))
  # Leer todo el archivo como texto primero
  lineas <- read_lines(archivo, locale = locale(encoding = "ISO-8859-1"))
  # Buscar la línea donde empiezan los datos (donde está el encabezado "Fecha")
  inicio <- which(lineas == '"Fecha","SF43718"' | lineas == '"Fecha","SF43936"' | lineas == '"Fecha","SP30562"' | grepl("Fecha", lineas))[1]
  # Leer desde ahí
  datos <- read_csv(archivo, skip = inicio - 1, show_col_types = FALSE, locale = locale(encoding = "ISO-8859-1"))
  colnames(datos) <- c("fecha_raw", "valor_raw")
  # Limpiar datos: Convertir fecha y valor, tirar lo que no sirva
  datos_limpios <- datos %>%
    mutate(
      # Extraer solo números y diagonales de la fecha
      fecha_limpia = gsub("[^0-9/]", "", as.character(fecha_raw)),
      fecha = dmy(fecha_limpia),
      # Convertir valor a número (maneja N/E o espacios)
      valor = as.numeric(as.character(valor_raw))
    ) %>%
    filter(!is.na(fecha), !is.na(valor)) %>%
    select(fecha, valor)
  colnames(datos_limpios) <- c("fecha", nombre_col)
  return(datos_limpios)
}
# 2. Ejecutar Limpieza
try({
  # Leer archivos de Banxico
  df_fix <- leer_banxico("input/tc_fix.csv", "tc_fix")
  df_tasa <- leer_banxico("input/tasa_nominal.csv", "tasa_nom")
  df_inpc <- leer_banxico("input/inflacion.csv", "inpc")
  # Calcular Tasa Real
  banxico <- df_inpc %>%
    mutate(fecha = floor_date(fecha, "month")) %>%
    arrange(fecha) %>%
    mutate(inf_mensual = (inpc / lag(inpc) - 1) * 100) %>%
    inner_join(mutate(df_tasa, fecha = floor_date(fecha, "month")), by = "fecha") %>%
    inner_join(mutate(df_fix, fecha = floor_date(fecha, "month")), by = "fecha") %>%
    mutate(
      inf_anual = ((1 + inf_mensual/100)^12 - 1) * 100,
      tasa_real = tasa_nom - inf_anual
    ) %>%
    mutate(year = year(fecha), trimestre = quarter(fecha)) %>%
    group_by(year, trimestre) %>%
    summarise(tc_fix = mean(tc_fix), tasa_real = mean(tasa_real), .groups = "drop")
  # Leer INEGI (Codificación UTF-16LE)
  print("Leyendo: input/inegi_consumo.csv")
  lineas_inegi <- read_lines("input/inegi_consumo.csv", locale = locale(encoding = "UTF-16LE"))
  inicio_inegi <- which(grepl("Periodo", lineas_inegi))[1]
  df_inegi <- read_csv("input/inegi_consumo.csv", skip = inicio_inegi - 1, 
                       locale = locale(encoding = "UTF-16LE"), show_col_types = FALSE)
  colnames(df_inegi)[1:4] <- c("periodo", "c_total", "c_nacional", "c_importado")
  df_inegi <- df_inegi %>%
    filter(!is.na(c_total)) %>%
    mutate(year = as.numeric(substr(periodo, 1, 4)), trimestre = as.numeric(substr(periodo, 6, 7)))
  # Unión Final
  df_final <- df_inegi %>%
    inner_join(banxico, by = c("year", "trimestre")) %>%
    select(year, trimestre, periodo, c_total, c_nacional, c_importado, tc_fix, tasa_real)
  if(!dir.exists("output")) dir.create("output")
  write_csv(df_final, "output/consumo_limpio.csv")
  print("¡LOGRADO! Archivo 'output/consumo_limpio.csv' generado con éxito.")
  print(head(df_final))
})