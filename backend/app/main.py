import csv
import io
from datetime import date
from fastapi import FastAPI, HTTPException
from fastapi.responses import StreamingResponse
from pydantic import BaseModel
from app.database import get_connection

app = FastAPI(title="API SENASA - Gestión y Reportes", version="1.0.0")

# --- Esquemas de entrada ---
class SolicitudVehiculoCreate(BaseModel):
    codigo_trabajador: int
    motivo_de_solicitud: str
    tiempo_uso: float
    matricula: str
    tipo_vehiculo: str

class InspeccionTrampaUpdate(BaseModel):
    cod_trampa_rot: str
    cd_trampa: str
    codigo_tecnico: int
    nuevo_estado_trampa: str  # 'B', 'M', 'R', 'C', 'S'
    exposicion: float
    placa: str
    kilometraje_final: float

# 1. READ (4 tablas): Listar solicitudes con su trabajador, vehículo o equipo asignado
@app.get("/solicitudes/detalle")
def listar_solicitudes_completas():
    query = """
        SELECT 
            s.id_solicitud,
            t.codigo AS codigo_trabajador,
            t.reponsable_de_zona,
            t.zona,
            s.tipo_de_solicitud,
            s.motivo_de_solicitud,
            s.tiempo_uso,
            sv.matricula AS vehiculo_matricula,
            sv.tipo_vehiculo,
            se.codigo_equipo,
            se.tipo_equipo
        FROM solicitud s
        INNER JOIN trabajador t ON s.codigo = t.codigo
        LEFT JOIN solicitud_vehiculo sv ON s.id_solicitud = sv.id_solicitud
        LEFT JOIN solicitud_equipo se ON s.id_solicitud = se.id_solicitud
        ORDER BY s.id_solicitud;
    """
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(query)
            return cur.fetchall()

# 2. CREATE (3 tablas): Validar trabajador, crear solicitud y asignar vehículo
@app.post("/solicitudes/vehiculo", status_code=201)
def crear_solicitud_vehiculo(datos: SolicitudVehiculoCreate):
    with get_connection() as conn:
        with conn.cursor() as cur:
            # Verificar que existe el trabajador
            cur.execute(
                "SELECT codigo, reponsable_de_zona FROM trabajador WHERE codigo = %s;",
                (datos.codigo_trabajador,)
            )
            trabajador = cur.fetchone()
            if not trabajador:
                raise HTTPException(status_code=404, detail="Trabajador no encontrado")

            try:
                # Insertar en SOLICITUD y capturar el ID de la secuencia
                cur.execute(
                    """
                    INSERT INTO solicitud (codigo, tipo_de_solicitud, motivo_de_solicitud, tiempo_uso)
                    VALUES (%s, 'Vehiculo', %s, %s)
                    RETURNING id_solicitud;
                    """,
                    (datos.codigo_trabajador, datos.motivo_de_solicitud, datos.tiempo_uso)
                )
                nueva_solicitud = cur.fetchone()
                id_generado = nueva_solicitud["id_solicitud"]

                # Insertar detalle en SOLICITUD_VEHICULO
                cur.execute(
                    """
                    INSERT INTO solicitud_vehiculo (matricula, tipo_vehiculo, id_solicitud)
                    VALUES (%s, %s, %s)
                    RETURNING matricula, tipo_vehiculo, id_solicitud;
                    """,
                    (datos.matricula, datos.tipo_vehiculo, id_generado)
                )
                detalle = cur.fetchone()
                conn.commit()
                return {
                    "mensaje": "Solicitud de vehículo registrada correctamente",
                    "trabajador": trabajador["reponsable_de_zona"],
                    "solicitud": detalle
                }
            except Exception as e:
                conn.rollback()
                raise HTTPException(status_code=400, detail=f"Error en base de datos: {str(e)}")

# 3. UPDATE + INSERT (3 tablas): Registrar control ROT, actualizar estado de trampa y kilometraje de vehículo
@app.put("/trampas/inspeccion")
def registrar_inspeccion_trampa(datos: InspeccionTrampaUpdate):
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT kilometraje_final FROM vehiculo WHERE placa = %s;", (datos.placa,))
            vehiculo = cur.fetchone()
            if not vehiculo:
                raise HTTPException(status_code=404, detail="Vehículo no encontrado")

            try:
                # 1. Insertar en registro_oficial_trampas
                cur.execute(
                    """
                    INSERT INTO registro_oficial_trampas 
                        (cod_trampa, codigo_tecnico, fecha, exposicion, placa, kilometraje_inicial, kilometraje_final)
                    VALUES (%s, %s, %s, %s, %s, %s, %s);
                    """,
                    (
                        datos.cod_trampa_rot, datos.codigo_tecnico, date.today(),
                        datos.exposicion, datos.placa, vehiculo["kilometraje_final"], datos.kilometraje_final
                    )
                )
                # 2. Actualizar estado en trampas
                cur.execute(
                    "UPDATE trampas SET estado = %s WHERE cd_trampa = %s;",
                    (datos.nuevo_estado_trampa, datos.cd_trampa)
                )
                if cur.rowcount == 0:
                    raise HTTPException(status_code=404, detail="Trampa no encontrada")

                # 3. Actualizar kilometraje en vehiculo
                cur.execute(
                    "UPDATE vehiculo SET kilometraje_final = %s WHERE placa = %s;",
                    (datos.kilometraje_final, datos.placa)
                )
                conn.commit()
                return {"mensaje": "Inspección registrada y estado de trampa/vehículo actualizados"}
            except HTTPException:
                conn.rollback()
                raise
            except Exception as e:
                conn.rollback()
                raise HTTPException(status_code=400, detail=str(e))

# 4. DELETE (3 tablas): Eliminar solicitud (activa ON DELETE SET NULL en tablas hijas)
@app.delete("/solicitudes/{id_solicitud}")
def eliminar_solicitud(id_solicitud: int):
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("DELETE FROM solicitud WHERE id_solicitud = %s RETURNING id_solicitud;", (id_solicitud,))
            eliminado = cur.fetchone()
            if not eliminado:
                raise HTTPException(status_code=404, detail="Solicitud no encontrada")
            conn.commit()
            return {"mensaje": f"Solicitud {id_solicitud} eliminada (recursos liberados con SET NULL)"}

# 5. REPORTE EXPORTABLE A CSV (GROUP BY + HAVING)
@app.get("/reportes/muestras-por-ruta/csv")
def exportar_reporte_muestras_csv(min_muestras: int = 1):
    query = """
        SELECT 
            r.n_ruta,
            r.provincia,
            t.reponsable_de_zona AS auxiliar_responsable,
            COUNT(rom.id_registro) AS total_registros_rom,
            SUM(rom.n_muestra) AS suma_muestras_recolectadas
        FROM ruta r
        INNER JOIN registro_oficial_muestras rom ON r.n_ruta = rom.n_ruta
        INNER JOIN auxiliar a ON rom.codigo_auxiliar = a.codigo_auxiliar
        INNER JOIN trabajador t ON a.codigo_auxiliar = t.codigo
        GROUP BY r.n_ruta, r.provincia, t.reponsable_de_zona
        HAVING SUM(rom.n_muestra) >= %s
        ORDER BY suma_muestras_recolectadas DESC;
    """
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(query, (min_muestras,))
            filas = cur.fetchall()

    output = io.StringIO()
    writer = csv.writer(output)
    writer.writerow(["N_Ruta", "Provincia", "Auxiliar_Responsable", "Total_Registros_ROM", "Suma_Muestras"])
    for f in filas:
        writer.writerow([
            f["n_ruta"], f["provincia"], f["auxiliar_responsable"],
            f["total_registros_rom"], f["suma_muestras_recolectadas"]
        ])

    output.seek(0)
    return StreamingResponse(
        iter([output.getvalue()]),
        media_type="text/csv",
        headers={"Content-Disposition": "attachment; filename=reporte_muestras_senasa.csv"}
    )

from app.routers import plantilla

app.include_router(plantilla.router)