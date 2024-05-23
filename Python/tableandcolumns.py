import os
import pandas as pd
import psycopg2
from dotenv import load_dotenv
from sqlalchemy import create_engine

# Cargar las variables del archivo .env
load_dotenv()

# Obtener las variables de entorno
db_name = os.getenv('DB_NAME')
db_user = os.getenv('DB_USER')
db_password = os.getenv('DB_PASSWORD')
db_host = os.getenv('DB_HOST')
db_port = os.getenv('DB_PORT')

# Ruta al archivo .csv
csv_file_path = 'Data/airbnb.csv'
table_name = 'airbnb'

# Leer el archivo .csv
df = pd.read_csv(csv_file_path)

# Limpieza de nombres de columnas
df.columns = [col.strip().replace(' ', '_').replace('.', '').lower() for col in df.columns]



# Intentar convertir columnas de números almacenados como strings a números
for col in df.columns:
    if df[col].dtype == 'object':
        try:
            df[col] = pd.to_numeric(df[col].str.replace(',', '').str.replace('$', ''), errors='raise')
        except ValueError:
            pass  # Si falla, lo dejamos como stringw

# Generar el esquema de la tabla
def generate_table_schema(df):
    schema = []
    for col in df.columns:
        if pd.api.types.is_integer_dtype(df[col]):
            # Verificar el rango de los valores para decidir entre INTEGER y BIGINT
            if df[col].max() > 2147483647 or df[col].min() < -2147483648:
                col_type = 'BIGINT'
            else:
                col_type = 'INTEGER'
        elif pd.api.types.is_float_dtype(df[col]):
            col_type = 'FLOAT'
        elif pd.api.types.is_bool_dtype(df[col]):
            col_type = 'BOOLEAN'
        elif pd.api.types.is_datetime64_any_dtype(df[col]):
            col_type = 'TIMESTAMP'
        elif pd.api.types.is_timedelta64_dtype(df[col]):
            col_type = 'INTERVAL'
        elif pd.api.types.is_numeric_dtype(df[col]):
            col_type = 'NUMERIC'
        elif pd.api.types.is_string_dtype(df[col]):
            max_length = df[col].map(lambda x: len(str(x))).max() if not df[col].isnull().all() else 255
            col_type = f'VARCHAR({max_length})' if max_length <= 255 else 'TEXT'
        else:
            col_type = 'TEXT'
        schema.append(f'"{col}" {col_type}')  # Envolvemos los nombres de columna en comillas dobles para evitar problemas con nombres reservados
    return ', '.join(schema)


table_schema = generate_table_schema(df)

# Imprimir el esquema de la tabla para verificar
print(f"Esquema de la tabla: {table_schema}")


create_table_query = f"CREATE TABLE {table_name} ({table_schema});"

# Conectar a la base de datos y crear la tabla
try:
    conn = psycopg2.connect(
        dbname=db_name,
        user=db_user,
        password=db_password,
        host=db_host,
        port=db_port
    )
    print("Conexión exitosa a la base de datos")

    cur = conn.cursor()

    # Crear la tabla
    cur.execute(create_table_query)
    conn.commit()
    print(f"Tabla '{table_name}' creada con éxito.")

    # Insertar los datos en la tabla
    engine = create_engine(f'postgresql+psycopg2://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}')

    # Insertar los datos en la tabla
    df.to_sql(table_name, engine, index=False, if_exists='append')
    print(f"Datos insertados en la tabla '{table_name}' con éxito.")

    # Cerrar el cursor y la conexión
    cur.close()
    conn.close()
    print("Conexión cerrada")
except Exception as e:
    print(f"Error: {e}")
    if conn:
        conn.rollback()
    if cur:
        cur.close()
    if conn:
        conn.close()
