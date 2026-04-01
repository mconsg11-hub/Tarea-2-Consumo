# Script para crear base de datos SQLite a partir de archivos CSV en la carpeta input
library(RSQLite)
library(readr)
library(dplyr)
library(stringr)

# Configuración de rutas
input_dir <- "input"
db_path <- file.path(input_dir, "database.sqlite")

# Listar archivos CSV en la carpeta input
archivos <- list.files(input_dir, pattern = "\\.csv$", full.names = TRUE)

# Conectar a la base de datos (se crea si no existe)
con <- dbConnect(SQLite(), db_path)

# Función para procesar y cargar cada archivo
cargar_archivo <- function(ruta_archivo, conexion) {
  # Nombre de la tabla basado en el nombre del archivo (sin extensión)
  nombre_tabla <- tools::file_path_sans_ext(basename(ruta_archivo))
  
  # Leer el archivo CSV
  # Se usa guess_max para mejorar la detección de tipos de datos
  datos <- read_csv(ruta_archivo, show_col_types = FALSE)
  
  # Escribir en la base de datos
  dbWriteTable(conexion, nombre_tabla, datos, overwrite = TRUE)
  
  message(paste("Tabla cargada:", nombre_tabla))
}

# Ejecutar la carga para todos los archivos
lapply(archivos, cargar_archivo, conexion = con)

# Cerrar la conexión
dbDisconnect(con)

message("\nBase de datos SQLite creada exitosamente en: ", db_path)
