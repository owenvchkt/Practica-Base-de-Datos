-- Restricciones para Tecnico de vigilancia
ALTER TABLE tecnico_vigilancia
    ADD CONSTRAINT uk_tecnico_placa UNIQUE (placa),

ALTER TABLE tecnico_cin
    ADD CONSTRAINT uk_tecnico_placa UNIQUE (placa),
    ADD CONSTRAINT fk_tecnico_cin_analista FOREIGN KEY (codigo_trabajador) REFERENCES analista(codigo_trabajador);

ALTER TABLE auxiliar
    ADD CONSTRAINT uk_tecnico_placa UNIQUE (placa),
    ADD CONSTRAINT fk_auxiliar_tecnico FOREIGN KEY (codigo_trabajador) REFERENCES analista(codigo_trabajador);
    ADD CONSTRAINT fk_auxiliar_analista FOREIGN KEY (codigo_trabajador) REFERENCES tecnico_cin(codigo_trabajador);

-- Restricciones para Vehiculo
ALTER TABLE vehiculo
    ADD CONSTRAINT fk_vehiculo_ruta FOREIGN KEY (n_ruta) REFERENCES ruta(n_ruta);

-- Restricciones para Trabajo diario
ALTER TABLE trabajo_diario
    ADD CONSTRAINT fk_trabajo_auxiliar FOREIGN KEY (auxiliar_encargado) REFERENCES trabajador(codigo),
    ADD CONSTRAINT fk_trabajo_ruta FOREIGN KEY (n_ruta) REFERENCES ruta(n_ruta);

-- Restricciones para Trampas
ALTER TABLE trampas
    ADD CONSTRAINT fk_trampas_ruta FOREIGN KEY (n_ruta) REFERENCES ruta(n_ruta),
    ADD CONSTRAINT fk_trampas_tecnico FOREIGN KEY (codigo_inspector) REFERENCES tecnico_vigilancia(codigo_trabajador),
    ADD CONSTRAINT chk_trampas_tipo CHECK (tipo_trampa IN ('JT', 'ML'));

-- Restricciones para Registro Oficial de Muestras (ROM)
ALTER TABLE registro_oficial_muestras
    ADD CONSTRAINT fk_rom_ruta FOREIGN KEY (n_ruta) REFERENCES ruta(n_ruta),
    ADD CONSTRAINT fk_rom_auxiliar FOREIGN KEY (codigo_auxiliar) REFERENCES auxiliar(codigo_trabajador),
    ADD CONSTRAINT chk_rom_procedencia CHECK (procedencia IN ('árbol', 'suelo'));

-- Restricciones para Registro Oficial de Trampas (ROT)
ALTER TABLE registro_oficial_trampas
    ADD CONSTRAINT fk_rot_trampa FOREIGN KEY (n_ruta, n_trampa) REFERENCES trampas(n_ruta, n_trampa),
    ADD CONSTRAINT fk_rot_tecnico FOREIGN KEY (codigo_tecnico) REFERENCES tecnico_vigilancia(codigo_trabajador),
    ADD CONSTRAINT fk_rot_vehiculo FOREIGN KEY (placa, n_ruta) REFERENCES vehiculo(placa, n_ruta);

-- Solicitud_vehiculo
ALTER TABLE SOLICITUD_VEHICULO
    ADD COLUMN codigo_solicitud NUMERIC(6);

-- Clave foranea del vehículo
ALTER TABLE SOLICITUD_VEHICULO
    ADD CONSTRAINT fk_vehiculo_solicitud FOREIGN KEY (codigo_solicitud) REFERENCES SOLICITUD(codigo);


-- Solicitud_equipo
ALTER TABLE SOLICITUD_EQUIPO 
    ADD COLUMN codigo_solicitud NUMERIC(6);

-- Clave foránea del equipo
ALTER TABLE SOLICITUD_EQUIPO
    ADD CONSTRAINT fk_equipo_solicitud FOREIGN KEY (codigo_solicitud) REFERENCES SOLICITUD(codigo);
