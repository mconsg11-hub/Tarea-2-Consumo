# Bitácora de Trabajo

- [2026-03-31] Paso 1.0 completado: Se generó `Teoria_Consumo.md` (estilo libro).
- [2026-03-31] Se modificó el `plan.md` para cambiar el flujo de descarga de API a archivos locales manuales por falta de tokens.
- [2026-03-31] Se detectaron los 4 archivos CSV en la carpeta `input/`.
- [2026-03-31] Paso 1.3 completado: Se procesaron los datos con éxito y se generó `output/consumo_limpio.csv`.
- [2026-03-31] Paso 1.4 iniciado: Se creó el script `05_02_analisis_ciclico.R` para análisis gráfico y estadístico.
- Se creó el script `01_crear_db.R` para generar una base de datos SQLite (`input/database.sqlite`) a partir de los archivos CSV en la carpeta `input`.
- [2026-04-01] Paso 1.5 completado: Se ejecutó el script `scripts/02_crear_sqlite.py` para generar una base de datos relacional SQLite (`output/macroeconomia_consumo.sqlite`) a partir de los archivos CSV de la carpeta `input/`. Cada archivo se importó en una tabla independiente con su codificación adecuada.
- [2026-04-01] Se cargaron con éxito las tablas: `inegi_consumo` (106 registros), `inflacion` (152), `tasas_nominal` (1380) y `tc_fix` (6613).
