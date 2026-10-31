-- Trabajadores y subtipos
CREATE TABLE Trabajador (
    codigo VARCHAR(6) NOT NULL,
    Reponsable_de_zona VARCHAR(50) NOT NULL,
    Zona VARCHAR(20) NOT NULL,
    telefono INTEGER,
    CONSTRAINT pk_Trabajador PRIMARY KEY (codigo)
);
CREATE TABLE Analista (
    codigo_analista VARCHAR(6) NOT NULL,
    ROMF VARCHAR(50) NOT NULL,
    CONSTRAINT pk_Analista PRIMARY KEY (codigo_analista)
);
CREATE TABLE tecnico_vigilancia (
    codigo_t_v VARCHAR(6) NOT NULL,
    placa VARCHAR(10) NOT NULL,
    CONSTRAINT pk_tecnico_vigilancia PRIMARY KEY (codigo_t_v)
);
CREATE TABLE tecnico_cin (
    codigo_t_c VARCHAR(6) NOT NULL,
    analista VARCHAR(6) NOT NULL,
    placa VARCHAR(10) NOT NULL,
    CONSTRAINT pk_tecnico_vigilancia PRIMARY KEY (codigo_t_c)
);
CREATE TABLE auxiliar (
    codigo_auxiliar VARCHAR(6) NOT NULL,
    analista VARCHAR(6) NOT NULL,
    tecnico_cin VARCHAR(6) NOT NULL,
    placa VARCHAR(10) ,
    CONSTRAINT pk_auxiliar PRIMARY KEY (codigo_auxiliar)
);

-- Ruta
CREATE TABLE ruta (
    n_ruta INTEGER,
    provincia VARCHAR(20) NOT NULL,
    cantidad INTEGER NOT NULL,
    n_muestras INTEGER NOT NULL,
    fecha DATE NOT NULL,
    semana INTEGER NOT NULL,
    CONSTRAINT pk_ruta PRIMARY KEY (n_ruta)
);

-- Vehiculo
CREATE TABLE vehiculo (
    placa VARCHAR(10),
    n_ruta INTEGER,
    tipo_de_vehiculo VARCHAR(10) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    kilometraje_inicial NUMERIC NOT NULL,
    kilometraje_final NUMERIC NOT NULL,
    CONSTRAINT pk_vehiculo PRIMARY KEY (placa, n_ruta)
);

-- Trabajo Diario
CREATE TABLE trabajo_diario (
    auxiliar_encargado VARCHAR(6),
    tipo_de_control VARCHAR(12) NOT NULL,
    n_ruta INTEGER NOT NULL,
    CONSTRAINT pk_trabajo_diario PRIMARY KEY (auxiliar_encargado)
);

-- Trampas
CREATE TABLE trampas (
    n_ruta INTEGER,
    n_trampa INTEGER,
    tipo_trampa VARCHAR(2) NOT NULL,
    estado VARCHAR(50) NOT NULL,
    exposicion VARCHAR(50) NOT NULL,
    codigo_inspector VARCHAR(20) NOT NULL,
    CONSTRAINT pk_trampas PRIMARY KEY (n_ruta, n_trampa)
);

-- Registro Oficial de Muestras (ROM)
CREATE TABLE registro_oficial_muestras (
    n_ruta INTEGER,
    codigo_auxiliar VARCHAR(20),
    n_muestra INTEGER,
    fecha DATE DEFAULT CURRENT_DATE NOT NULL,
    procedencia VARCHAR(20) NOT NULL,
    especie VARCHAR(50) NOT NULL,
    cultivar VARCHAR(50) NOT NULL,
    CONSTRAINT pk_registro_oficial_muestras PRIMARY KEY (n_ruta, codigo_auxiliar, n_muestra)
);

-- Registro Oficial de Trampas (ROT)
CREATE TABLE registro_oficial_trampas (
    n_ruta INTEGER,
    n_trampa INTEGER,
    fecha DATE DEFAULT CURRENT_DATE NOT NULL,
    codigo_tecnico VARCHAR(20) NOT NULL,
    procedencia VARCHAR(50) NOT NULL,
    placa VARCHAR(10) NOT NULL,
    kilometraje_inicial NUMERIC NOT NULL,
    kilometraje_final NUMERIC NOT NULL,
    CONSTRAINT pk_registro_oficial_trampas PRIMARY KEY (n_ruta, n_trampa, fecha)
);

-- Solicitud
CREATE TABLE SOLICITUD (
  codigo NUMERIC(6) CONSTRAINT cod_solicitud PRIMARY KEY,
  tipo_de_solicitud VARCHAR(20) NOT NULL,
  motivo_de_solicitud VARCHAR(50) NOT NULL
);

-- Solicitud de vehiculo
CREATE TABLE SOLICITUD_VEHICULO (
  matricula VARCHAR(10) CONSTRAINT mat_vehiculo PRIMARY KEY,
  disponibilidad VARCHAR(2) NOT NULL
);

-- Solicitud de equipo
CREATE TABLE SOLICITUD_EQUIPO (
  codigo_equipo NUMERIC(10) CONSTRAINT cod_equipo PRIMARY KEY,
  tipo_equipo VARCHAR(20) NOT NULL
);

----------------------------------------------------------------------------------------------------
-- espacio para insertar registros

Insert into Trabajador (codigo_trabajador, Reponsable_de_zona,  Zona, telefono)
Values 
    ('153456','Juan Carlos','Uchumayo',987123574),
    ('832456','Pepe casas','Tambo',923450765),
    ('398573','Maria alvarado','Arequipa',921047394),
    ('278645','Pedro samuel','Santa rita',904653833),
    ('296548','Orlando toledo','Joya antigua',940673622);



