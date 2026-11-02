Insert into SOLICITUD (Id_solicitud, codigo, tipo_de_solicitud, motivo_de_solicitud,tiempo_uso)
Values
  (395740348,'153456','Vehiculo','Transporte de personal',2),
  (395376895,'705945','Equipo','Instalacion de trampas',2),
  (396690432,'276593','Equipo','Renovacion de trampas',3),
  (394759493,'398573','Equipo','Uso en zonas alejadas',3),
  (393509483,'504956','Vehiculo','Transporte de trampas',2);

Insert into SOLICITUD_VEHICULO (matricula, Tipo_vehiculo)
Values   
  ('GFS466','Camioneta'),
  ('NSY937','Motocicleta'),
  ('ETX565','Minivan'),
  ('DAJ310','Automovil'),
  ('HAT528','Camion ligero');

Insert into SOLICITUD_EQUIPO (codigo_equipo, tipo_equipo)
Values   
  ('3654','mochila fumigadora'),
  ('5837','fumigadora estacionaria'),
  ('9074','pesticida'),
  ('6685','mascara con filtro'),
  ('1927','serruchos');
