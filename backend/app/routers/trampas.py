import csv
import io
from fastapi import APIRouter, HTTPException
from fastapi.responses import StreamingResponse
from pydantic import BaseModel
from app.database import get_connection

router = APIRouter(prefix="/trampas", tags=["Trampas"])


# --- 1. Esquema de datos de entrada (para POST / PUT) ---
class TrampaCreate(BaseModel):
    cd_trampa: str        # 9 caracteres, ej: '011702304'
    n_ruta: str           # 7 caracteres, ej: '0117023'
    tipo_trampa: str      # 'JT' o 'ML'
    estado: str           # 'B', 'M', 'R', 'C', 'S'
    codigo_inspector: int # Código de tecnico_vigilancia


# --- 2. Endpoint GET cruzando 3 o más tablas ---
@router.get("/trampas-detalle")
def listar_trampas_con_inspector():
    query = """
        SELECT 
            tr.cd_trampa,
            tr.tipo_trampa,
            tr.estado,
            r.n_ruta,
            r.provincia,
            t.codigo AS codigo_inspector,
            t.reponsable_de_zona AS inspector
        FROM trampas tr
        INNER JOIN ruta r ON tr.n_ruta = r.n_ruta
        INNER JOIN tecnico_vigilancia tv ON tr.codigo_inspector = tv.codigo_t_v
        INNER JOIN trabajador t ON tv.codigo_t_v = t.codigo
        ORDER BY tr.cd_trampa;
    """
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(query)
            return cur.fetchall()


# --- 3. Endpoint POST con validaciones y COMMIT / ROLLBACK ---
@router.post("/trampas", status_code=201)
def registrar_trampa(datos: TrampaCreate):
    with get_connection() as conn:
        with conn.cursor() as cur:
            # Validar que exista la ruta
            cur.execute("SELECT n_ruta FROM ruta WHERE n_ruta = %s;", (datos.n_ruta,))
            if not cur.fetchone():
                raise HTTPException(status_code=404, detail="La ruta indicada no existe")

            # Validar que exista el técnico de vigilancia
            cur.execute("SELECT codigo_t_v FROM tecnico_vigilancia WHERE codigo_t_v = %s;", (datos.codigo_inspector,))
            if not cur.fetchone():
                raise HTTPException(status_code=404, detail="El técnico inspector no existe")

            try:
                cur.execute(
                    """
                    INSERT INTO trampas (cd_trampa, n_ruta, tipo_trampa, estado, codigo_inspector)
                    VALUES (%s, %s, %s, %s, %s)
                    RETURNING cd_trampa, n_ruta, tipo_trampa, estado, codigo_inspector;
                    """,
                    (datos.cd_trampa, datos.n_ruta, datos.tipo_trampa, datos.estado, datos.codigo_inspector)
                )
                nueva_trampa = cur.fetchone()
                conn.commit()
                return {"mensaje": "Registro guardado correctamente", "data": nueva_trampa}
            except Exception as e:
                conn.rollback()
                raise HTTPException(status_code=400, detail=f"Error SQL: {str(e)}")


# --- 4. Endpoint de Reporte CSV con GROUP BY y HAVING ---
@router.get("/reporte-trampas/csv")
def exportar_reporte_trampas_csv(min_trampas: int = 1):
    query = """
        SELECT 
            r.provincia,
            tr.estado,
            COUNT(tr.cd_trampa) AS total_trampas
        FROM trampas tr
        INNER JOIN ruta r ON tr.n_ruta = r.n_ruta
        GROUP BY r.provincia, tr.estado
        HAVING COUNT(tr.cd_trampa) >= %s
        ORDER BY total_trampas DESC;
    """
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(query, (min_trampas,))
            filas = cur.fetchall()

    output = io.StringIO()
    writer = csv.writer(output)
    writer.writerow(["Provincia", "Estado_Trampa", "Total_Trampas"])
    for f in filas:
        writer.writerow([f["provincia"], f["estado"], f["total_trampas"]])

    output.seek(0)
    return StreamingResponse(
        iter([output.getvalue()]),
        media_type="text/csv",
        headers={"Content-Disposition": "attachment; filename=reporte_trampas.csv"}
    )