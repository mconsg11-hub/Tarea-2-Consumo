import pandas as pd
import os

# Crear carpeta output si no existe
if not os.path.exists('output'):
    os.makedirs('output')

def leer_banxico(archivo, nombre_col):
    print(f"Leyendo: {archivo}")
    # Detectar dónde empieza la data (buscando la palabra 'Fecha')
    try:
        with open(archivo, 'r', encoding='latin1') as f:
            lines = f.readlines()
            skip = 0
            for i, line in enumerate(lines):
                if 'Fecha' in line:
                    skip = i
                    break
        
        # Leer el dataframe
        df = pd.read_csv(archivo, encoding='latin1', skiprows=skip)
        # Tomar solo las primeras dos columnas (Fecha y Dato)
        df = df.iloc[:, [0, 1]]
        df.columns = ['fecha', nombre_col]
        
        # Limpiar fecha y convertir a número
        df['fecha'] = pd.to_datetime(df['fecha'], dayfirst=True, errors='coerce')
        df[nombre_col] = pd.to_numeric(df[nombre_col], errors='coerce')
        
        return df.dropna()
    except Exception as e:
        print(f"Error al leer {archivo}: {e}")
        return pd.DataFrame()

try:
    # 1. Procesar BANXICO
    df_fix = leer_banxico('input/tc_fix.csv', 'tc_fix')
    df_tasa = leer_banxico('input/tasa_nominal.csv', 'tasa_nom')
    df_inpc = leer_banxico('input/inflacion.csv', 'inpc')

    if df_fix.empty or df_tasa.empty or df_inpc.empty:
        raise ValueError("Uno de los archivos de Banxico no se pudo cargar.")

    # Unir datos de Banxico por mes
    df_inpc['fecha_m'] = df_inpc['fecha'].dt.to_period('M').dt.to_timestamp()
    df_tasa['fecha_m'] = df_tasa['fecha'].dt.to_period('M').dt.to_timestamp()
    df_fix['fecha_m'] = df_fix['fecha'].dt.to_period('M').dt.to_timestamp()

    # Calcular inflación mensual y tasa real
    df_inpc = df_inpc.sort_values('fecha_m')
    df_inpc['inf_mensual'] = df_inpc['inpc'].pct_change() * 100
    
    banxico = df_inpc.merge(df_tasa, on='fecha_m').merge(df_fix, on='fecha_m')
    
    # Tasa Real = Tasa Nominal - Inflación Anualizada
    banxico['inf_anual'] = ((1 + banxico['inf_mensual']/100)**12 - 1) * 100
    banxico['tasa_real'] = banxico['tasa_nom'] - banxico['inf_anual']
    
    # Agrupar por trimestre
    banxico['year'] = banxico['fecha_m'].dt.year
    banxico['trimestre'] = banxico['fecha_m'].dt.quarter
    banxico_trim = banxico.groupby(['year', 'trimestre'])[['tc_fix', 'tasa_real']].mean().reset_index()

    # 2. Procesar INEGI
    print("Leyendo: input/inegi_consumo.csv")
    # Intentar leer el inicio de la data en INEGI
    with open('input/inegi_consumo.csv', 'r', encoding='utf-16') as f:
        lines = f.readlines()
        skip_inegi = 0
        for i, line in enumerate(lines):
            if 'Periodo' in line:
                skip_inegi = i
                break

    df_inegi = pd.read_csv('input/inegi_consumo.csv', encoding='utf-16', skiprows=skip_inegi)
    # Limpiar nombres de columnas
    df_inegi = df_inegi.iloc[:, 0:4]
    df_inegi.columns = ['periodo', 'c_total', 'c_nacional', 'c_importado']
    
    # Limpiar el campo periodo (ej: "2000/01")
    df_inegi = df_inegi.dropna(subset=['c_total'])
    df_inegi['year'] = df_inegi['periodo'].str[:4].astype(int)
    df_inegi['trimestre'] = df_inegi['periodo'].str[5:7].astype(int)

    # 3. Unión Final
    df_final = df_inegi.merge(banxico_trim, on=['year', 'trimestre'])
    
    # Ordenar y guardar
    df_final = df_final[['year', 'trimestre', 'periodo', 'c_total', 'c_nacional', 'c_importado', 'tc_fix', 'tasa_real']]
    df_final.to_csv('output/consumo_limpio.csv', index=False)
    
    print("\n¡ÉXITO TOTAL!")
    print(f"Se ha generado 'output/consumo_limpio.csv' con {len(df_final)} filas.")
    print(df_final.head())

except Exception as e:
    print(f"\nERROR: {str(e)}")
