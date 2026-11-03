DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

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
    CONSTRAINT pk_tecnico_cin PRIMARY KEY (codigo_t_c)
);

CREATE TABLE auxiliar (
    codigo_auxiliar VARCHAR(6) NOT NULL,
    analista VARCHAR(6) NOT NULL,
    tecnico_cin VARCHAR(6) NOT NULL,
    placa VARCHAR(10),
    CONSTRAINT pk_auxiliar PRIMARY KEY (codigo_auxiliar)
);

-- Ruta
CREATE TABLE ruta (
    n_ruta VARCHAR(7) NOT NULL,
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
    n_ruta VARCHAR(7) NOT NULL,
    tipo_de_vehiculo VARCHAR(10) NOT NULL,
    nombre VARCHAR(50),
    kilometraje_inicial NUMERIC NOT NULL,
    kilometraje_final NUMERIC NOT NULL,
    CONSTRAINT pk_vehiculo PRIMARY KEY (placa)
);

-- Trabajo Diario
CREATE TABLE trabajo_diario (
    auxiliar_encargado VARCHAR(6) NOT NULL,
    tipo_de_control VARCHAR(12) NOT NULL,
    n_ruta VARCHAR(7) NOT NULL,
    CONSTRAINT pk_trabajo_diario PRIMARY KEY (auxiliar_encargado)
);

-- Trampas
CREATE TABLE trampas (
    Cd_trampa VARCHAR(9) NOT NULL,
    n_ruta VARCHAR(7) NOT NULL,
    tipo_trampa VARCHAR(2) NOT NULL,
    estado VARCHAR(1) NOT NULL,
    codigo_inspector VARCHAR(6) NOT NULL,
    CONSTRAINT pk_trampas PRIMARY KEY (Cd_trampa)
);

-- Registro Oficial de Muestras (ROM)
CREATE TABLE registro_oficial_muestras (
    Id_registro NUMERIC NOT NULL,
    n_ruta VARCHAR(7) NOT NULL,
    codigo_auxiliar VARCHAR(6) NOT NULL,
    n_muestra INTEGER NOT NULL,
    fecha DATE DEFAULT CURRENT_DATE NOT NULL,
    procedencia VARCHAR(7) NOT NULL,
    especie VARCHAR(20) NOT NULL,
    cultivar VARCHAR(20) NOT NULL,
    CONSTRAINT pk_registro_oficial_muestras PRIMARY KEY (Id_registro)
);

-- Registro Oficial de Trampas (ROT)
CREATE TABLE registro_oficial_trampas (
    Cod_trampa VARCHAR(11) NOT NULL,
    codigo_tecnico VARCHAR(6) NOT NULL,
    fecha DATE DEFAULT CURRENT_DATE NOT NULL,
    exposicion NUMERIC NOT NULL,
    placa VARCHAR(10) NOT NULL,
    kilometraje_inicial NUMERIC NOT NULL,
    kilometraje_final NUMERIC NOT NULL,
    CONSTRAINT pk_registro_oficial_trampas PRIMARY KEY (Cod_trampa)
);

-- Solicitud
CREATE TABLE SOLICITUD (
    Id_solicitud NUMERIC NOT NULL,
    codigo VARCHAR(6) NOT NULL,
    tipo_de_solicitud VARCHAR(20) NOT NULL,
    motivo_de_solicitud VARCHAR(50) NOT NULL,
    tiempo_uso NUMERIC,
    CONSTRAINT pk_SOLICITUD PRIMARY KEY (Id_solicitud)
);

-- Solicitud de vehiculo
CREATE TABLE SOLICITUD_VEHICULO (
    matricula VARCHAR(10) CONSTRAINT mat_vehiculo PRIMARY KEY,
    Tipo_vehiculo VARCHAR(20) NOT NULL
);

-- Solicitud de equipo
CREATE TABLE SOLICITUD_EQUIPO (
    codigo_equipo VARCHAR(10) CONSTRAINT cod_equipo PRIMARY KEY,
    tipo_equipo VARCHAR(20) NOT NULL
);