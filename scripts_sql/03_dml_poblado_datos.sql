-- Trabajador
Insert into Trabajador (codigo, Reponsable_de_zona, Zona, telefono) Values 
    ('153456','Juan Carlos','Uchumayo',987123574),
    ('832456','Pepe casas','Tambo',923450765),
    ('398573','Maria alvarado','Arequipa',921047394),
    ('278645','Pedro samuel','Santa rita',904653833),
    ('296548','Orlando toledo','Joya antigua',940673622),
    ('705945','Luis Fernandez','Cural',987654321), 
    ('276593','Ana Gomez','Vitor',912345678), 
    ('504956','Carlos Ruiz','Siguas',998877665),
    ('612394','Luis Perez','Majes (I)',954321876),
    ('845932','Carmen Rojas','Camana',965412398),
    ('492015','Jorge Diaz','Yauca',978564123),
    ('758392','Rosa Silva','Vitor',932145876),
    ('184950','Raul Castro','Ocoña',945612378),
    ('593821','Hugo Blanco','Viraco',987456123),
    ('302918','Ines Ramos','Colca',912365478),
    ('918273','Jose Lira','Tambo',963258741),
    ('456129','Paco Mora','Cural',974125896),
    ('827364','Luz Tapia','Siguas',985214763),
    ('635241','Tito Ruiz','Yuramayo',996325874),
    ('294857','Gema Paz','Chapa',914785236);

-- Analista
Insert into Analista (codigo_analista, ROMF) Values 
    ('153456','Amadeo Arellano'),
    ('612394','Beto Caceres'),
    ('845932','Cesar Luna'),
    ('492015','Diana Rios'),
    ('758392','Elena Vargas');

-- Tecnico de vigilancia
Insert into tecnico_vigilancia (codigo_t_v, placa) Values  
    ('832456','DHF128'),
    ('705945','BJW102'),
    ('184950','XTY892'),
    ('593821','VBN456'),
    ('302918','MKL789');

-- Tecnico CIN
Insert into tecnico_cin (codigo_t_c, analista, placa) Values  
    ('398573','153456','JDK329'),
    ('504956','153456','POI963'),
    ('918273','612394','RTY345'),
    ('456129','845932','FGH678'),
    ('827364','492015','CVB901');
    
-- Auxiliar
Insert into Auxiliar (codigo_auxiliar, analista, tecnico_cin, placa) Values   
    ('278645','153456','398573',NULL),
    ('296548','153456','398573','DHE695'),
    ('276593','153456','504956',NULL),
    ('635241','612394','918273','LKP234'),
    ('294857','845932','456129','QWE567');

-- Ruta
Insert into Ruta (n_ruta, provincia, cantidad, n_muestras, fecha, semana) Values   
    ('0204031','Arequipa',23,14,'2026-10-19',43),
    ('0117023','Islay',30,13,'2026-10-22',43),
    ('0407194','Arequipa',26,9,'2026-10-12',42),
    ('0912345','Arequipa',25,15,'2026-10-15',42),
    ('0502001','Arequipa',29,15,'2026-10-07',41),
    ('0301015','Arequipa',15,10,'2026-10-20',43),
    ('0702010','Arequipa',20,12,'2026-10-21',43),
    ('1005022','Arequipa',18,8,'2026-10-23',43);
    
-- Vehiculo
Insert into Vehiculo (placa, n_ruta, tipo_de_vehiculo, nombre, kilometraje_inicial, kilometraje_final) Values   
    ('DHF128', '0117023', 'Moto', 'Pepe casas', 34566, 34567),
    ('JDK329', '0407194', 'Combi', 'Maria alvarado', 267536, 267541),
    ('GFS466', '0204031', 'Camioneta', 'Juan Carlos', 76566, 34568),
    ('BJW102', '0301015', 'Moto', 'Luis Fernandez', 10000, 10045),
    ('ZXC741', '0702010', 'Camioneta', 'Ana Gomez', 50000, 50120),
    ('POI963', '1005022', 'Combi', 'Carlos Ruiz', 80000, 80150);
    
-- Trabajo Diario
Insert into trabajo_diario (auxiliar_encargado, tipo_de_control, n_ruta) Values   
    ('278645','Quimico','0912345'),
    ('296548','Biologico','0502001'),
    ('276593','Cultural','0702010'),
    ('635241','Quimico','0407194'),
    ('294857','Biologico','1005022');

-- Trampas
Insert into trampas (Cd_trampa, n_ruta, tipo_trampa, estado, codigo_inspector) Values   
    ('011702301', '0117023', 'JT', 'B', '832456'),
    ('011702302', '0117023', 'ML', 'S', '832456'),
    ('011702303', '0117023', 'ML', 'B', '832456'),
    ('030101501', '0301015', 'JT', 'B', '705945'),
    ('030101502', '0301015', 'ML', 'M', '705945'),
    ('030101503', '0301015', 'JT', 'R', '705945');
    
-- Registro Oficial de Muestras (ROM)
Insert into registro_oficial_muestras (Id_registro, n_ruta, codigo_auxiliar, n_muestra, fecha, procedencia, especie, cultivar) Values   
    (374958372, '0502001', '278645', 3, '2026-10-30', 'Planta', 'Palta', 'Fuerte'),
    (394726190, '0502001', '278645', 12, '2026-10-29', 'Planta', 'Guayaba', 'Hass'),
    (581238793, '0912345', '296548', 2, '2026-10-29', 'Suelo', 'Mango', 'Sutano'),
    (472190378, '0912345', '296548', 5, '2026-10-28', 'Planta', 'Chirimoya', 'Criolla'),
    (683920184, '0702010', '276593', 8, '2026-10-22', 'Planta', 'Uva', 'Italia');

-- Registro Oficial de Trampas (ROT)
Insert into registro_oficial_trampas (Cod_trampa, codigo_tecnico, fecha, exposicion, placa, kilometraje_inicial, kilometraje_final) Values   
    ('011702301JT','832456','2026-10-28',4,'DHF128',34563,34566),
    ('011702301ML','832456','2026-10-29',6,'DHF128',34566,34567),
    ('030101501JT','705945','2026-10-25',7,'BJW102',10000,10020),
    ('011702303ML','832456','2026-10-30',5,'DHF128',34567,34570),
    ('030101502ML','705945','2026-10-26',8,'BJW102',10020,10045);

-- Solicitud
Insert into SOLICITUD (Id_solicitud, codigo, tipo_de_solicitud, motivo_de_solicitud, tiempo_uso) Values
    (395740348,'153456','Vehiculo','Transporte de personal',2),
    (395376895,'705945','Equipo','Instalacion de trampas',2),
    (396690432,'276593','Equipo','Renovacion de trampas',3),
    (394759493,'398573','Equipo','Uso en zonas alejadas',3),
    (393509483,'504956','Vehiculo','Transporte de trampas',2);

-- Solicitud Vehiculo
Insert into SOLICITUD_VEHICULO (matricula, Tipo_vehiculo, id_solicitud) Values   
    ('GFS466','Camioneta', 395740348),
    ('NSY937','Moto', 393509483),
    ('ETX565','Combi', 395740348),
    ('DAJ310','Camioneta', 393509483),
    ('HAT528','Camioneta', 395740348);

-- Solicitud Equipo
Insert into SOLICITUD_EQUIPO (codigo_equipo, tipo_equipo, id_solicitud) Values   
    ('3654','Mochila fumigadora', 395376895),
    ('5837','Mochila fumigadora', 396690432),
    ('9074','Motosierra', 394759493),
    ('6685','Mochila fumigadora', 395376895),
    ('1927','Motosierra', 396690432);