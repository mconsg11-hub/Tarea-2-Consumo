import sqlite3
import csv
import os
import glob

# Configuración de rutas
input_dir = 'input/'
output_dir = 'output/'
db_path = os.path.join(output_dir, 'macroeconomia_consumo.sqlite')

# Asegurar que el directorio de salida exista
if not os.path.exists(output_dir):
    os.makedirs(output_dir)

# Conectar a la base de datos
conn = sqlite3.connect(db_path)
cursor = conn.cursor()
print(f"Conectado a la base de datos: {db_path}")

def clean_str(s):
    if s is None: return ""
    return str(s).replace('\x00', '').strip().strip('"')

def process_file(file_path):
    table_name = os.path.splitext(os.path.basename(file_path))[0]
    print(f"Procesando: {file_path} -> Tabla: {table_name}")
    
    # Lista de codificaciones a probar
    # Nota: utf-16-le es común en archivos de Windows/Excel
    encodings = ['utf-8', 'utf-16', 'utf-16-le', 'utf-16-be', 'latin-1', 'cp1252']
    
    for encoding in encodings:
        try:
            with open(file_path, 'rb') as rb:
                raw_data = rb.read()
                
                try:
                    content = raw_data.decode(encoding)
                except:
                    continue
                
                # Limpiar caracteres nulos del contenido decodificado
                content = content.replace('\x00', '')
                lines = content.splitlines()
                if not lines: continue
                
                # Encontrar el encabezado real
                header_index = -1
                for i, line in enumerate(lines[:100]): # Aumentar rango de búsqueda
                    parts = list(csv.reader([line]))[0]
                    if len(parts) >= 2:
                        # Palabras clave de encabezados comunes
                        low_parts = [p.lower() for p in parts]
                        if any(kw in low_parts[0] for kw in ["fecha", "periodo", "título", "id_indicador", "instituto", "métrica"]):
                            header_index = i
                            break
                        # Si es inegi_consumo, el header tiene nombres de meses o años o estructuras específicas
                        if "indicador" in low_parts[0] or "nombre" in low_parts[0]:
                             header_index = i
                             break
                
                # Si no encontramos por palabras clave, buscamos el que tenga más columnas
                if header_index == -1:
                    max_cols = 0
                    for i, line in enumerate(lines[:50]):
                        parts = list(csv.reader([line]))[0]
                        if len(parts) > max_cols:
                            max_cols = len(parts)
                            header_index = i
                
                if header_index == -1: continue
                
                headers_raw = list(csv.reader([lines[header_index]]))[0]
                headers = [clean_str(h).replace(' ', '_').replace('.', '_').replace('-', '_').lower() for h in headers_raw]
                headers = [h if h else f"col_{j}" for j, h in enumerate(headers)]
                
                # Crear tabla
                columns_def = ", ".join([f'"{h}" TEXT' for h in headers])
                cursor.execute(f'DROP TABLE IF EXISTS "{table_name}"')
                cursor.execute(f'CREATE TABLE "{table_name}" ({columns_def})')
                
                # Insertar datos
                placeholders = ", ".join(['?' for _ in headers])
                count = 0
                reader = csv.reader(lines[header_index+1:])
                for row in reader:
                    if row:
                        row_cleaned = [clean_str(cell) for cell in row]
                        if len(row_cleaned) < len(headers):
                            row_cleaned.extend([''] * (len(headers) - len(row_cleaned)))
                        elif len(row_cleaned) > len(headers):
                            row_cleaned = row_cleaned[:len(headers)]
                        
                        cursor.execute(f'INSERT INTO "{table_name}" VALUES ({placeholders})', row_cleaned)
                        count += 1
                
                print(f"Éxito: {count} registros cargados en {table_name} (Encoding: {encoding}, Header en línea {header_index+1}).")
                return True
        except Exception as e:
            # print(f"Error con {encoding} en {file_path}: {e}")
            continue
    return False

# Procesar todos los archivos
csv_files = glob.glob(os.path.join(input_dir, '*.csv'))
for f in csv_files:
    if not process_file(f):
        print(f"ERROR crítico: No se pudo procesar {f}")

# Guardar y cerrar
conn.commit()
conn.close()
print("Proceso completado.")
