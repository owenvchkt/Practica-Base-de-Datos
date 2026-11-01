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
    nombre VARCHAR(50),
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
    Cd_trampa VARCHAR(9),
    n_ruta INTEGER,
    tipo_trampa VARCHAR(2) NOT NULL,
    estado VARCHAR(1) NOT NULL,
    codigo_inspector INTEGER NOT NULL,
    CONSTRAINT pk_trampas PRIMARY KEY (Cd_trampa)
);

-- Registro Oficial de Muestras (ROM)
CREATE TABLE registro_oficial_muestras (
    Id_registro NUMERIC,
    n_ruta INTEGER,
    codigo_auxiliar VARCHAR(6),
    n_muestra INTEGER,
    fecha DATE DEFAULT CURRENT_DATE NOT NULL,
    procedencia VARCHAR(7) NOT NULL,
    especie VARCHAR(20) NOT NULL,
    cultivar VARCHAR(20) NOT NULL,
    CONSTRAINT pk_registro_oficial_muestras PRIMARY KEY (Id_registro)
);

-- Registro Oficial de Trampas (ROT)
CREATE TABLE registro_oficial_trampas (
    Cod_trampa VARCHAR(11) INTEGER,
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
    Id_solicitud NUMERIC,
    codigo NUMERIC(6) CONSTRAINT cod_solicitud PRIMARY KEY,
    tipo_de_solicitud VARCHAR(20) NOT NULL,
    motivo_de_solicitud VARCHAR(50) NOT NULL,
    tiempo_uso NUMERIC,
    CONSTRAINT pk_SOLICITUD PRIMARY KEY (Id_solicitud)
);

-- Solicitud de vehiculo
CREATE TABLE SOLICITUD_VEHICULO (
  matricula VARCHAR(10) CONSTRAINT mat_vehiculo PRIMARY KEY,
  Tipo_vehiculo VARCHAR(20) NOT NULL,
);

-- Solicitud de equipo
CREATE TABLE SOLICITUD_EQUIPO (
  codigo_equipo NUMERIC(10) CONSTRAINT cod_equipo PRIMARY KEY,
  tipo_equipo VARCHAR(10) NOT NULL,
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

Insert into Analista (codigo_analista, ROMF)
Values 
    ('153456','Amadeo Arellano');

Insert into tecnico_vigilancia (codigo_t_v, placa)
Values  
    ('832456','DHF128');

Insert into tecnico_cin (codigo_t_c,analista,placa)
Values  
    ('398573','153456','JDK329');
    
Insert into Auxiliar (codigo_auxiliar,analista,tecnico_cin,placa)
Values   
    ('278645','153456','398573',NULL),
    ('296548','153456','398573','DHE695');
    
Insert into Ruta (n_ruta,provincia,cantidad,n_muestras,fecha,semana)
Values   
    (0235235,'Arequipa',23,14,'2026-10-19',43),
    (0117023,'Islay',30,13,'2026-10-22',43),
    (0407194,'Arequipa',26,9,'2026-10-12',42),
    (0912345,'Arequipa',25,26,'2026-10-15',42),
    (0502001,'Arequipa',29,30,'2026-10-7',41);
    
Insert into Vehiculo (placa, n_ruta, tipo_de_vehiculo, nombre, kilometraje_inicial, kilometraje_final)
Values   
    ('DHF128','0117023','Moto','Pepe casas',34566,34567),
    ('GFS466',NULL,'Camioneta',NULL,36578,36578),
    ('JDK329','0407194','Combi','Maria alvarado',267536,267541),
    ('GFS466',0235235,'Camioneta','Juan Carlos',76566,34568),
    
Insert into trabajo_diario (auxiliar_encargado, tipo_de_control, n_ruta)
Values   
    ('278645','Quimico',0912345),
    ('296548','Biologo',0502001);
    
Insert into trampas (Cd_trampa,n_ruta,tipo_trampa,estado,codigo_inspector)
Values   
    (011702301,0117023,'JT','B','832456'),
    (011702302,0117023,'ML','S','832456'),
    (011702303,0117023,'ML','B','832456');
    
Insert into registro_oficial_muestras (Id_registro, n_ruta, codigo_auxiliar, n_muestra, fecha, procedencia, especie, cultivar)
Values   
    (374958372,0502001,'278645',3,'2026-10-30','Planta','Palta','Fuerte'),
    (394726190,0502001,'278645',12,'2026-10-29','Planta','Guayaba','Hass'),
    (581238793,0912345,'296548',2,'2026-10-29','Suelo','Mango','Sutano'),
    (472190378,0912345,'296548',5,'2026-10-28','Planta','Chirimoya','Criolla');

Insert into registro_oficial_trampas (Cod_trampa, codigo_tecnico, fecha, exposicion, placa, kilometraje_inicial, kilometraje_final)
Values   
    ('011702301JT','832456','2026-10-28',4,'DHF128',34563,34566),
    ('011702301ML','832456','2026-10-29',6,'DHF128',34566,34567);


Insert into SOLICITUD (Id_solicitud, codigo, tipo_de_solicitud, motivo_de_solicitud,tiempo_uso)
Values   
    (395740348,'153456','Vehiculo','Transporte de personal',2),
    (394759493,'398573','Equipo','Uso en zonas alejadas',3);

Insert into SOLICITUD_VEHICULO (matricula, Tipo_vehiculo)
Values   
    ('GFS466','Camioneta');

Insert into SOLICITUD_EQUIPO (codigo_equipo, tipo_equipo)
Values   
    ('3654','mochila fumigadora');



