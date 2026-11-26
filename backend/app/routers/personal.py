from typing import Optional, Literal
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel, Field
from app.database import get_connection

router = APIRouter(prefix="/personal", tags=["Personal"])

class VehiculoCreate(BaseModel):
    placa: str = Field(..., max_length=10)
    n_ruta: str = Field(..., min_length=7, max_length=7)
    tipo_de_vehiculo: Literal["Camioneta", "Moto", "Combi"]
    nombre: Optional[str] = None
    kilometraje_inicial: float
    kilometraje_final: float

class PersonalCreate(BaseModel):
    responsable_de_zona: str = Field(..., max_length=50)
    zona: str = Field(..., max_length=20)
    telefono: Optional[int] = None

    tipo_personal: Literal[
        "Analista",
        "Tecnico_CIN",
        "Tecnico_Vigilancia",
        "Auxiliar"
    ]

    romf: Optional[str] = None
    analista: Optional[int] = None
    tecnico_cin: Optional[int] = None
    placa: Optional[str] = None
    vehiculo: Optional[VehiculoCreate] = None

@router.get("/cadena-completa")
def listar_cadena_personal():

    query = """
        SELECT
            -- Trabajador
            t.codigo,
            t.Reponsable_de_zona,
            t.Zona,
            t.telefono,

            -- Analista
            a.codigo_analista,
            a.ROMF,

            -- Técnico CIN
            tc.codigo_t_c,
            tc.analista AS analista_del_cin,
            tc.placa AS placa_cin,

            -- Trabajador técnico CIN
            tc_trabajador.Reponsable_de_zona AS nombre_tecnico_cin,

            -- Auxiliar
            aux.codigo_auxiliar,
            aux.analista AS analista_del_auxiliar,
            aux.tecnico_cin,
            aux.placa AS placa_auxiliar,

            -- Trabajador auxiliar
            aux_trabajador.Reponsable_de_zona AS nombre_auxiliar,

            -- Técnico de vigilancia
            tv.codigo_t_v,
            tv.placa AS placa_vigilancia,

            -- Vehículo técnico CIN
            vcin.tipo_de_vehiculo AS tipo_vehiculo_cin,
            vcin.nombre AS nombre_vehiculo_cin,
            vcin.n_ruta AS ruta_cin,
            vcin.kilometraje_inicial AS km_inicial_cin,
            vcin.kilometraje_final AS km_final_cin,

            -- Vehículo técnico vigilancia
            vv.tipo_de_vehiculo AS tipo_vehiculo_vigilancia,
            vv.nombre AS nombre_vehiculo_vigilancia,
            vv.n_ruta AS ruta_vigilancia,
            vv.kilometraje_inicial AS km_inicial_vigilancia,
            vv.kilometraje_final AS km_final_vigilancia

        FROM trabajador t

        LEFT JOIN analista a
            ON a.codigo_analista = t.codigo

        LEFT JOIN tecnico_cin tc
            ON tc.codigo_t_c = t.codigo

        LEFT JOIN trabajador tc_trabajador
            ON tc_trabajador.codigo = tc.codigo_t_c

        LEFT JOIN auxiliar aux
            ON aux.tecnico_cin = tc.codigo_t_c

        LEFT JOIN trabajador aux_trabajador
            ON aux_trabajador.codigo = aux.codigo_auxiliar

        LEFT JOIN tecnico_vigilancia tv
            ON tv.codigo_t_v = t.codigo

        LEFT JOIN vehiculo vcin
            ON vcin.placa = tc.placa

        LEFT JOIN vehiculo vv
            ON vv.placa = tv.placa

        ORDER BY t.codigo;
    """

    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(query)
            return cur.fetchall()

@router.post("/cadena-completa", status_code=201)
def registrar_cadena_personal(datos: PersonalCreate):
    with get_connection() as conn:
        with conn.cursor() as cur:
            try:
                cur.execute(
                    """
                    INSERT INTO trabajador (
                        Reponsable_de_zona,
                        Zona,
                        telefono
                    )
                    VALUES (%s, %s, %s)
                    RETURNING codigo;
                    """,
                    (
                        datos.responsable_de_zona,
                        datos.zona,
                        datos.telefono
                    )
                )

                codigo = cur.fetchone()["codigo"]

                if datos.tipo_personal == "Analista":
                    if not datos.romf:
                        raise HTTPException(
                            status_code=400,
                            detail="Debe ingresar el ROMF del analista"
                        )

                    cur.execute(
                        """
                        INSERT INTO analista (
                            codigo_analista,
                            ROMF
                        )
                        VALUES (%s, %s);
                        """,
                        (codigo, datos.romf)
                    )

                elif datos.tipo_personal == "Tecnico_CIN":

                    if not datos.analista:
                        raise HTTPException(
                            status_code=400,
                            detail="Debe indicar el código del analista"
                        )

                    cur.execute(
                        """
                        SELECT codigo_analista
                        FROM analista
                        WHERE codigo_analista = %s;
                        """,
                        (datos.analista,)
                    )

                    if not cur.fetchone():
                        raise HTTPException(
                            status_code=404,
                            detail="El analista no existe"
                        )

                    placa = datos.placa

                    if datos.vehiculo:
                        placa = datos.vehiculo.placa
                        cur.execute(
                            """
                            SELECT n_ruta
                            FROM ruta
                            WHERE n_ruta = %s;
                            """,
                            (datos.vehiculo.n_ruta,)
                        )

                        if not cur.fetchone():
                            raise HTTPException(
                                status_code=404,
                                detail="La ruta del vehículo no existe"
                            )

                        cur.execute(
                            """
                            INSERT INTO vehiculo (
                                placa,
                                n_ruta,
                                tipo_de_vehiculo,
                                nombre,
                                kilometraje_inicial,
                                kilometraje_final
                            )
                            VALUES (%s, %s, %s, %s, %s, %s);
                            """,
                            (
                                datos.vehiculo.placa,
                                datos.vehiculo.n_ruta,
                                datos.vehiculo.tipo_de_vehiculo,
                                datos.vehiculo.nombre,
                                datos.vehiculo.kilometraje_inicial,
                                datos.vehiculo.kilometraje_final
                            )
                        )

                    elif placa:
                        cur.execute(
                            "SELECT placa FROM vehiculo WHERE placa = %s;",
                            (placa,)
                        )

                        if not cur.fetchone():
                            raise HTTPException(
                                status_code=404,
                                detail="El vehículo no existe"
                            )

                    else:
                        raise HTTPException(
                            status_code=400,
                            detail="Debe asignar un vehículo al técnico CIN"
                        )

                    cur.execute(
                        """
                        INSERT INTO tecnico_cin (
                            codigo_t_c,
                            analista,
                            placa
                        )
                        VALUES (%s, %s, %s);
                        """,
                        (codigo, datos.analista, placa)
                    )

                elif datos.tipo_personal == "Tecnico_Vigilancia":
                  
                    placa = datos.placa

                    if datos.vehiculo:
                        placa = datos.vehiculo.placa
                        cur.execute(
                            """
                            SELECT n_ruta
                            FROM ruta
                            WHERE n_ruta = %s;
                            """,
                            (datos.vehiculo.n_ruta,)
                        )

                        if not cur.fetchone():
                            raise HTTPException(
                                status_code=404,
                                detail="La ruta del vehículo no existe"
                            )

                        cur.execute(
                            """
                            INSERT INTO vehiculo (
                                placa,
                                n_ruta,
                                tipo_de_vehiculo,
                                nombre,
                                kilometraje_inicial,
                                kilometraje_final
                            )
                            VALUES (%s, %s, %s, %s, %s, %s);
                            """,
                            (
                                datos.vehiculo.placa,
                                datos.vehiculo.n_ruta,
                                datos.vehiculo.tipo_de_vehiculo,
                                datos.vehiculo.nombre,
                                datos.vehiculo.kilometraje_inicial,
                                datos.vehiculo.kilometraje_final
                            )
                        )

                    elif placa:
                        cur.execute(
                            "SELECT placa FROM vehiculo WHERE placa = %s;",
                            (placa,)
                        )

                        if not cur.fetchone():
                            raise HTTPException(
                                status_code=404,
                                detail="El vehículo no existe"
                            )

                    else:
                        raise HTTPException(
                            status_code=400,
                            detail="Debe asignar un vehículo al técnico de vigilancia"
                        )

                    cur.execute(
                        """
                        INSERT INTO tecnico_vigilancia (
                            codigo_t_v,
                            placa
                        )
                        VALUES (%s, %s);
                        """,
                        (codigo, placa)
                    )

                elif datos.tipo_personal == "Auxiliar":

                    if not datos.analista or not datos.tecnico_cin:
                        raise HTTPException(
                            status_code=400,
                            detail="Debe indicar el analista y el técnico CIN"
                        )

                    cur.execute(
                        """
                        SELECT codigo_analista
                        FROM analista
                        WHERE codigo_analista = %s;
                        """,
                        (datos.analista,)
                    )

                    if not cur.fetchone():
                        raise HTTPException(
                            status_code=404,
                            detail="El analista no existe"
                        )

                    cur.execute(
                        """
                        SELECT codigo_t_c, analista
                        FROM tecnico_cin
                        WHERE codigo_t_c = %s;
                        """,
                        (datos.tecnico_cin,)
                    )

                    tecnico = cur.fetchone()

                    if not tecnico:
                        raise HTTPException(
                            status_code=404,
                            detail="El técnico CIN no existe"
                        )

                    if tecnico["analista"] != datos.analista:
                        raise HTTPException(
                            status_code=400,
                            detail="El técnico CIN no pertenece al analista indicado"
                        )

                    cur.execute(
                        """
                        INSERT INTO auxiliar (
                            codigo_auxiliar,
                            analista,
                            tecnico_cin,
                            placa
                        )
                        VALUES (%s, %s, %s, NULL);
                        """,
                        (
                            codigo,
                            datos.analista,
                            datos.tecnico_cin
                        )
                    )

                conn.commit()

                return {
                    "mensaje": "Cadena de personal registrada correctamente",
                    "codigo_trabajador": codigo,
                    "tipo_personal": datos.tipo_personal
                }

            except HTTPException:
                conn.rollback()
                raise

            except Exception as e:
                conn.rollback()

                raise HTTPException(
                    status_code=400,
                    detail=f"Error al registrar la cadena de personal: {str(e)}"
                )
