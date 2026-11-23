-- Trabajador
Insert into Trabajador (Reponsable_de_zona, Zona, telefono) Values 
    ('Juan Carlos','Uchumayo',987123574),
    ('Pepe casas','Tambo',923450765),
    ('Maria alvarado','Arequipa',921047394),
    ('Pedro samuel','Santa rita',904653833),
    ('Orlando toledo','Joya antigua',940673622),
    ('Luis Fernandez','Cural',987654321), 
    ('Ana Gomez','Vitor',912345678), 
    ('Carlos Ruiz','Siguas',998877665),
    ('Luis Perez','Majes (I)',954321876),
    ('Carmen Rojas','Camana',965412398),
    ('Jorge Diaz','Yauca',978564123),
    ('Rosa Silva','Vitor',932145876),
    ('Raul Castro','Ocoña',945612378),
    ('Hugo Blanco','Viraco',987456123),
    ('Ines Ramos','Colca',912365478),
    ('Jose Lira','Tambo',963258741),
    ('Paco Mora','Cural',974125896),
    ('Luz Tapia','Siguas',985214763),
    ('Tito Ruiz','Yuramayo',996325874),
    ('Gema Paz','Chapa',914785236);

-- Analista
Insert into Analista (codigo_analista, ROMF)
    Select codigo, 'Amadeo Arellano' From Trabajador where Reponsable_de_zona ='Juan Carlos'
    Union all
    Select codigo, 'Beto Caceres' From Trabajador where Reponsable_de_zona ='Luis Perez'
    Union all
    Select codigo, 'Cesar Luna' From Trabajador where Reponsable_de_zona ='Carmen Rojas'
    Union all
    Select codigo, 'Diana Rios' From Trabajador where Reponsable_de_zona ='Jorge Diaz'
    Union all
    Select codigo, 'Elena Vargas' From Trabajador where Reponsable_de_zona ='Rosa Silva';


-- Tecnico de vigilancia
Insert into tecnico_vigilancia (codigo_t_v, placa)

    Select codigo, 'DHF128' From Trabajador where Reponsable_de_zona ='Pepe casas'
    Union all
    Select codigo, 'BJW102' From Trabajador where Reponsable_de_zona ='Luis Fernandez'
    Union all
    Select codigo, 'XTY892' From Trabajador where Reponsable_de_zona ='Raul Castro'
    Union all
    Select codigo, 'VBN456' From Trabajador where Reponsable_de_zona ='Hugo Blanco'
    Union all
    Select codigo, 'MKL789' From Trabajador where Reponsable_de_zona ='Ines Ramos';

-- Tecnico CIN
Insert into tecnico_cin (codigo_t_c, analista, placa)
    Select codigo,(Select codigo From Trabajador where Reponsable_de_zona ='Juan Carlos'),'JDK329' From Trabajador where Reponsable_de_zona ='Maria alvarado'
    Union all
    Select codigo,(Select codigo From Trabajador where Reponsable_de_zona ='Juan Carlos'),'POI963' From Trabajador where Reponsable_de_zona ='Carlos Ruiz'
    Union all
    Select codigo,(Select codigo From Trabajador where Reponsable_de_zona ='Luis Perez'),'RTY345' From Trabajador where Reponsable_de_zona ='Jose Lira'
    Union all
    Select codigo,(Select codigo From Trabajador where Reponsable_de_zona ='Carmen Rojas'),'FGH678' From Trabajador where Reponsable_de_zona ='Paco Mora'
    Union all
    Select codigo,(Select codigo From Trabajador where Reponsable_de_zona ='Jorge Diaz'),'CVB901' From Trabajador where Reponsable_de_zona ='Luz Tapia';
    
-- Auxiliar
Insert into Auxiliar (codigo_auxiliar, analista, tecnico_cin, placa)
    Select codigo,(Select codigo From Trabajador where Reponsable_de_zona ='Juan Carlos'),(Select codigo From Trabajador where Reponsable_de_zona ='Maria alvarado'),NULL From Trabajador where Reponsable_de_zona ='Pedro samuel'
    Union all
    Select codigo,(Select codigo From Trabajador where Reponsable_de_zona ='Juan Carlos'),(Select codigo From Trabajador where Reponsable_de_zona ='Maria alvarado'),'DHE695' From Trabajador where Reponsable_de_zona ='Orlando toledo'
    Union all
    Select codigo,(Select codigo From Trabajador where Reponsable_de_zona ='Juan Carlos'),(Select codigo From Trabajador where Reponsable_de_zona ='Carlos Ruiz'),NULL From Trabajador where Reponsable_de_zona ='Ana Gomez'
    Union all
    Select codigo,(Select codigo From Trabajador where Reponsable_de_zona ='Luis Perez'),(Select codigo From Trabajador where Reponsable_de_zona ='Jose Lira'),'LKP234' From Trabajador where Reponsable_de_zona ='Tito Ruiz'
    Union all
    Select codigo,(Select codigo From Trabajador where Reponsable_de_zona ='Carmen Rojas'),(Select codigo From Trabajador where Reponsable_de_zona ='Paco Mora'),'QWE567' From Trabajador where Reponsable_de_zona ='Gema Paz';

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
Insert into trabajo_diario (auxiliar_encargado, tipo_de_control, n_ruta) 
    
    Select codigo,'Quimico','0912345' From Trabajador where Reponsable_de_zona ='Pedro samuel'
    Union all
    Select codigo,'Biologico','0502001' From Trabajador where Reponsable_de_zona ='Orlando toledo'
    Union all
    Select codigo,'Cultural','0702010' From Trabajador where Reponsable_de_zona ='Ana Gomez'
    Union all
    Select codigo,'Quimico','0407194' From Trabajador where Reponsable_de_zona ='Tito Ruiz'
    Union all
    Select codigo,'Biologico','1005022' From Trabajador where Reponsable_de_zona ='Gema Paz';

-- Trampas
Insert into trampas (Cd_trampa, n_ruta, tipo_trampa, estado, codigo_inspector)
     Select '011702301', '0117023', 'JT', 'B', codigo From Trabajador where Reponsable_de_zona = 'Pepe casas'
    Union all
     Select '011702302', '0117023', 'ML', 'S', codigo From Trabajador where Reponsable_de_zona = 'Pepe casas'
    Union all
     Select '011702303', '0117023', 'ML', 'B', codigo From Trabajador where Reponsable_de_zona = 'Pepe casas'
    Union all
     Select '030101501', '0301015', 'JT', 'B', codigo From Trabajador where Reponsable_de_zona = 'Luis Fernandez'
    Union all
     Select '030101502', '0301015', 'ML', 'M', codigo From Trabajador where Reponsable_de_zona = 'Luis Fernandez'
    Union all
     Select '030101503', '0301015', 'JT', 'R', codigo From Trabajador where Reponsable_de_zona = 'Luis Fernandez';
    
-- Registro Oficial de Muestras (ROM)
Insert into registro_oficial_muestras (n_ruta, codigo_auxiliar, n_muestra, fecha, procedencia, especie, cultivar)
    Select '0502001', codigo, 3, '2026-10-30', 'Planta', 'Palta', 'Fuerte' From Trabajador where Reponsable_de_zona = 'Pedro samuel'
    Union all
    Select '0502001', codigo, 12, '2026-10-29', 'Planta', 'Guayaba', 'Hass' From Trabajador where Reponsable_de_zona = 'Pedro samuel'
    Union all
    Select '0912345', codigo, 2, '2026-10-29', 'Suelo', 'Mango', 'Sutano' From Trabajador where Reponsable_de_zona = 'Orlando toledo'
    Union all
    Select '0912345', codigo, 5, '2026-10-28', 'Planta', 'Chirimoya', 'Criolla' From Trabajador where Reponsable_de_zona = 'Orlando toledo'
    Union all
    Select '0702010', codigo, 8, '2026-10-22', 'Planta', 'Uva', 'Italia' From Trabajador where Reponsable_de_zona = 'Ana Gomez';

-- Registro Oficial de Trampas (ROT)
Insert into registro_oficial_trampas (Cod_trampa, codigo_tecnico, fecha, exposicion, placa, kilometraje_inicial, kilometraje_final)
    Select '011702301JT', codigo,'2026-10-28',4,'DHF128',34563,34566 From Trabajador where Reponsable_de_zona = 'Pepe casas'
    Union all
    Select '011702301ML', codigo,'2026-10-29',6,'DHF128',34566,34567 From Trabajador where Reponsable_de_zona = 'Pepe casas'
    Union all
    Select '030101501JT', codigo,'2026-10-25',7,'BJW102',10000,10020 From Trabajador where Reponsable_de_zona = 'Luis Fernandez'
    Union all
    Select '011702303ML', codigo,'2026-10-30',5,'DHF128',34567,34570 From Trabajador where Reponsable_de_zona = 'Pepe casas'
    Union all
    Select '030101502ML', codigo,'2026-10-26',8,'BJW102',10020,10045 From Trabajador where Reponsable_de_zona = 'Luis Fernandez';

-- Solicitud
Insert into SOLICITUD (codigo, tipo_de_solicitud, motivo_de_solicitud, tiempo_uso)
    Select  codigo,'Vehiculo','Transporte de personal',2 From Trabajador where Reponsable_de_zona = 'Juan Carlos'
    Union all
    Select  codigo,'Equipo','Instalacion de trampas',2 From Trabajador where Reponsable_de_zona = 'Luis Fernandez'
    Union all
    Select  codigo,'Equipo','Renovacion de trampas',3 From Trabajador where Reponsable_de_zona = 'Ana Gomez'
    Union all
    Select  codigo,'Equipo','Uso en zonas alejadas',3 From Trabajador where Reponsable_de_zona = 'Maria alvarado'
    Union all
    Select  codigo,'Vehiculo','Transporte de trampas',2 From Trabajador where Reponsable_de_zona = 'Carlos Ruiz';

-- Solicitud Vehiculo
Insert into SOLICITUD_VEHICULO (matricula, Tipo_vehiculo, id_solicitud) Values   
    ('GFS466','Camioneta', 100000000),
    ('NSY937','Moto', 100000004),
    ('ETX565','Combi', 100000000),
    ('DAJ310','Camioneta', 100000004),
    ('HAT528','Camioneta', 100000000);

-- Solicitud Equipo
Insert into SOLICITUD_EQUIPO (codigo_equipo, tipo_equipo, id_solicitud) Values   
    ('3654','Mochila fumigadora', 100000001),
    ('5837','Mochila fumigadora', 100000002),
    ('9074','Motosierra', 100000003),
    ('6685','Mochila fumigadora', 100000001),
    ('1927','Motosierra', 100000002);