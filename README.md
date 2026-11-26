# Sistema de Gestión Operativa y Recursos — SENASA

Proyecto de implementación de base de datos relacional y API REST para la gestión de solicitudes de recursos (vehículos y equipos), rutas de vigilancia fitosanitaria, control de trampas, registro oficial de muestras y asignación de personal operativo de SENASA.

## Integrantes del Equipo

* **Owen Kurt Vilcarani Checca**

* **Gabriel Guillermo Vargas Toledo**

* **Eduardo Fabián Tapia Rodríguez**

* **Yoshiro Daniel Jaime Quispe Jihuallanca**

**Curso:** Base de Datos — III Semestre (Ciencia de la Computación, UCSP)

## Arquitectura y Stack Tecnológico

* **Base de Datos:** PostgreSQL 16 (`postgres:16`) con inicialización automatizada mediante scripts DDL, restricciones, índices y DML.

* **Backend / API REST:** Python 3.11 + FastAPI + Uvicorn.

* **Driver de Conexión:** `psycopg` (v3) ejecutando consultas SQL parametrizadas directamente contra PostgreSQL.

* **Contenedores:** Docker y Docker Compose para orquestar la red interna entre la base de datos y la API.

## Estructura del Proyecto

```
Practica-Base-de-Datos/
├── backend/
│   ├── app/
│   │   ├── routers/
│   │   │   ├── __init__.py
│   │   │   ├── personal.py        # CRUD y registro transaccional de personal y vehículos
│   │   │   └── trampas.py         # Endpoints y reportes CSV de vigilancia de trampas
│   │   ├── __init__.py
│   │   ├── database.py             # Gestión de conexión directa con psycopg (SQL puro)
│   │   └── main.py                 # Punto de entrada FastAPI, CRUD base y reportes CSV
│   ├── Dockerfile                  # Imagen del contenedor backend
│   └── requirements.txt            # Dependencias de Python (fastapi, uvicorn, psycopg, pydantic)
├── scripts_sql/
│   ├── 01_ddl_estructura.sql       # Creación de las 14 tablas del esquema relacional
│   ├── 02_constrains_y_indices.sql # Llaves primarias, foráneas, restricciones e índices
│   └── 03_dml_poblado_datos.sql    # Carga inicial de datos de prueba
├── .gitignore
├── docker-compose.yml              # Orquestación de servicios postgres_db y senasa_backend
└── README.md


```

## Requisitos Previos

* **Git** instalado.

* **Docker Desktop** instalado y en ejecución (*Engine running*).

## Instalación y Ejecución

### 1. Clonar el repositorio

```
git clone https://github.com/owenvchkt/Practica-Base-de-Datos.git
cd Practica-Base-de-Datos


```

### 2. Construir y levantar los contenedores

Asegúrate de tener **Docker Desktop** abierto y ejecuta en la raíz del proyecto:

```
docker compose up --build -d


```

Al iniciar por primera vez, PostgreSQL ejecutará automáticamente en orden alfabético los scripts ubicados en `scripts_sql/` (`01` $\rightarrow$ `02` $\rightarrow$ `03`) y dejará cargada toda la estructura y los datos iniciales.

### 3. Verificar que los servicios estén activos

```
docker ps


```

Deben aparecer dos contenedores en estado `Up`: **`postgres_db`** (puerto `5432`) y **`senasa_backend`** (puerto `8000`).

## Acceso a la API y Base de Datos

### Documentación Interactiva (Swagger UI)

Abre en tu navegador:

* **URL:** `http://localhost:8000/docs` (o `http://127.0.0.1:8000/docs`)

> **Nota:** Asegúrate de ingresar usando **`http://`** y no `https://` (navegadores como Brave pueden redirigir automáticamente a HTTPS y mostrar `ERR_SSL_PROTOCOL_ERROR`).

### Conexión desde Gestor SQL (DBeaver / pgAdmin)

Si deseas inspeccionar el diagrama ER o ejecutar consultas directamente:

* **Host:** `localhost`

* **Puerto:** `5432`

* **Base de datos:** `appdb`

* **Usuario:** `postgres`

* **Contraseña:** `postgres`

## Funcionalidades Implementadas (SQL Puro)

* **CRUD Multi-tabla:**

  * `GET /solicitudes/detalle`: Consulta con `JOIN` y `LEFT JOIN` entre `solicitud`, `trabajador`, `solicitud_vehiculo` y `solicitud_equipo`.

  * `POST /solicitudes/vehiculo`: Inserción transaccional atómica en `solicitud` y `solicitud_vehiculo` (`RETURNING id_solicitud`).

  * `PUT /trampas/inspeccion`: Actualización del estado de trampa y registro histórico en `registro_oficial_trampas`.

  * `DELETE /solicitudes/{id_solicitud}`: Eliminación controlada en cascada sobre tablas dependientes.

* **Reportes Analíticos Exportables:**

  * `GET /reportes/muestras-por-ruta/csv`: Exportación directa a archivo `.csv` utilizando funciones de agregación (`COUNT`, `SUM`), `GROUP BY` y filtrado con `HAVING`.

  * `GET /plantilla/reporte-trampas/csv`: Reporte agrupado de trampas por provincia y estado.

## Comandos Útiles de Docker

* **Apagar los contenedores sin perder los datos:**

  ```
  docker compose down
  
  
  ```

* **Volver a encender los servicios (uso diario sin reconstruir imagen):**

  ```
  docker compose up -d
  
  
  ```

* **Reiniciar la base de datos desde cero (borra el volumen y vuelve a correr `scripts_sql/`):**

  ```
  docker compose down -v
  docker compose up -d
  
  
  ```

* **Revisar logs en caso de error:**

  ```
  docker compose logs postgres
  docker compose logs backend
  
  
  ```