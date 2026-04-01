# Mandatos del Proyecto - Mercado Laboral

- **Directorio de trabajo**: El directorio de trabajo del proyecto es "C:\Users\Brenda\Documents\Tarea 2 Macroeconomia"
- **Ejecución de Código:**
  -   Todas las bases de datos descargadas manualmente deben almacenarse en una carpeta llamada input en el directorio de trabajo.
  -   Todos los archivos generados por los scripts deben almacenarse en una carpeta llamada output en el directorio de trabajo.
- **Flujo de Trabajo:**

  1. Gemini genera y guarda el script en el workspace.
  2. Gemini se detiene y espera a que el usuario proporcione el output de la terminal.
  3. Gemini analiza los resultados y procede con el siguiente paso del plan, antes de iniciar el siguiente paso, lo avisa y pide permiso
- **Resultados:** Se debe mantener un archivo `Resultados.Rmd` que se actualizará de forma incremental con cada hallazgo relevante para la tarea, procura reportar los resultados en forma de tabla o graficas cuando sea el caso y para los porcentajes especificar el calculo para llegar a ellos. En las tablas no hagas versiones resumidas (...) a menos que se te indique.
- **Idioma:** Todas las respuestas y reportes de Gemini deben ser en **español**.
- **Herramientas:** Se debe priorizar el uso de R para todos los scripts de análisis y python para procesamiento.
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
