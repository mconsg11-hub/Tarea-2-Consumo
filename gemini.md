# Mandatos del Proyecto - Mercado Laboral

- **Directorio de trabajo**: El directorio de trabajo del proyecto es "C:\Users\Brenda\Documents\Tarea 2 Macroeconomia"

- **Ejecución de Código:** 
  -    Cuando hagas querys en SQL agrega alias a las columnas usando los diccionarios y catalogos disponibles en "C:\Users\Brenda\Documents\Tarea 2 Macroeconomia\data\raw\conjunto_de_datos_sdem_enoe_2024_4t".
  -    El usuario es el único encargado de ejecutar los scripts (R, SQL) en su entorno de WSL/Windows.

- **Estilo de Gráficas:** A cada grafica ponle un marco negro de grosor predeterminado.

- **Flujo de Trabajo:** 
  
  1. Gemini genera y guarda el script en el workspace.
  2. Gemini se detiene y espera a que el usuario proporcione el output de la terminal.
  3. Gemini analiza los resultados y procede con el siguiente paso del plan.

- **Resultados:** Se debe mantener un archivo `Resultados.Rmd` que se actualizará de forma incremental con cada hallazgo relevante para la tarea, procura reportar los resultados en forma de tabla o graficas cuando sea el caso y para los porcentajes especificar el calculo para llegar a ellos. En las tablas no hagas versiones resumidas (...) a menos que se te indique.

- **Idioma:** Todas las respuestas y reportes de Gemini deben ser en **español**.

- **Herramientas:** Se debe priorizar el uso de R para todos los scripts de análisis y procesamiento.

- **Persistencia:** Todos los scripts deben quedar guardados en el directorio raíz del proyecto con nombres descriptivos (ej. `01_crear_db.R`).

- **Bitácora:** Cada cambio, o creación de archivo debe registrarse en `Bitacora.md`.

- **Formato:** El formato de Resultado.Rmd debe ser el siguiente

---

output: 
  pdf_document:
    number_sections: false
    latex_engine: xelatex
header-includes:

- \usepackage{setspace}
- \onehalfspacing
- \usepackage{ragged2e}
- \AtBeginDocument{\justifying}
- \usepackage{graphicx}
- \usepackage{caption}
- \captionsetup[table]{labelformat=empty}
  editor_options: 
  markdown: 
  wrap: 72

---


