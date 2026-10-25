-- Tecnico de vigilancia (subtipo)
CREATE TABLE tecnico_vigilancia (
    codigo_trabajador VARCHAR(20),
    placa VARCHAR(10) NOT NULL,
    CONSTRAINT pk_tecnico_vigilancia PRIMARY KEY (codigo_trabajador)
);

-- Ruta
CREATE TABLE ruta (
    n_ruta INTEGER,
    provincia VARCHAR(50) NOT NULL,
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
    tipo_de_vehiculo VARCHAR(30) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    kilometraje_inicial NUMERIC NOT NULL,
    kilometraje_final NUMERIC NOT NULL,
    observacion VARCHAR(255) NOT NULL,
    CONSTRAINT pk_vehiculo PRIMARY KEY (placa, n_ruta)
);

-- Trabajo Diario
CREATE TABLE trabajo_diario (
    auxiliar_encargado VARCHAR(20),
    tipo_de_control VARCHAR(50) NOT NULL,
    n_ruta INTEGER NOT NULL,
    CONSTRAINT pk_trabajo_diario PRIMARY KEY (auxiliar_encargado)
);