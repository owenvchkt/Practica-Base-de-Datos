import os
import psycopg
from psycopg.rows import dict_row

def get_connection():
    return psycopg.connect(
        host=os.getenv("DB_HOST", "postgres_db"),
        dbname=os.getenv("DB_NAME", "appdb"),
        user=os.getenv("DB_USER", "postgres"),
        password=os.getenv("DB_PASSWORD", "postgres"),
        port=os.getenv("DB_PORT", "5432"),
        row_factory=dict_row
    )