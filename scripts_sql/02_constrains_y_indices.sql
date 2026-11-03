-- Restricciones para Tecnico de vigilancia
ALTER TABLE tecnico_vigilancia
    ADD CONSTRAINT uk_tecnico_v_placa UNIQUE (placa),
    ADD CONSTRAINT fk_tecnico_v_trabajador FOREIGN KEY (codigo_t_v) REFERENCES Trabajador(codigo);

-- Restricciones para Analista
ALTER TABLE Analista
    ADD CONSTRAINT fk_analista_trabajador FOREIGN KEY (codigo_analista) REFERENCES Trabajador(codigo);

-- Restricciones para Tecnico_cin
ALTER TABLE tecnico_cin
    ADD CONSTRAINT uk_tecnico_c_placa UNIQUE (placa),
    ADD CONSTRAINT fk_tecnico_cin_analista FOREIGN KEY (analista) REFERENCES Analista(codigo_analista),
    ADD CONSTRAINT fk_tecnico_c_trabajador FOREIGN KEY (codigo_t_c) REFERENCES Trabajador(codigo);

-- Restricciones para Auxiliar
ALTER TABLE auxiliar
    ADD CONSTRAINT uk_auxiliar_placa UNIQUE (placa),
    ADD CONSTRAINT fk_auxiliar_trabajador FOREIGN KEY (codigo_auxiliar) REFERENCES Trabajador(codigo),
    ADD CONSTRAINT fk_auxiliar_analista FOREIGN KEY (analista) REFERENCES Analista(codigo_analista),
    ADD CONSTRAINT fk_auxiliar_tecnico FOREIGN KEY (tecnico_cin) REFERENCES tecnico_cin(codigo_t_c);

-- Restricciones para Ruta 
ALTER TABLE ruta
    ADD CONSTRAINT chk_ruta_cantidad CHECK (cantidad <= 30),
    ADD CONSTRAINT chk_ruta_semana CHECK (semana BETWEEN 1 AND 53);

-- Restricciones para Vehiculo
ALTER TABLE vehiculo
    ADD CONSTRAINT fk_vehiculo_ruta FOREIGN KEY (n_ruta) REFERENCES ruta(n_ruta),
    ADD CONSTRAINT chk_vehiculo_tipo CHECK (tipo_de_vehiculo IN ('Camioneta', 'Moto', 'Combi'));

-- Restricciones para Trabajo diario
ALTER TABLE trabajo_diario
    ADD CONSTRAINT fk_trabajo_auxiliar FOREIGN KEY (auxiliar_encargado) REFERENCES auxiliar(codigo_auxiliar),
    ADD CONSTRAINT fk_trabajo_ruta FOREIGN KEY (n_ruta) REFERENCES ruta(n_ruta),
    ADD CONSTRAINT chk_trabajo_control CHECK (tipo_de_control IN ('Quimico', 'Biologico', 'Cultural'));

-- Restricciones para Trampas
ALTER TABLE trampas
    ADD CONSTRAINT fk_trampas_ruta FOREIGN KEY (n_ruta) REFERENCES ruta(n_ruta),
    ADD CONSTRAINT fk_trampas_tecnico FOREIGN KEY (codigo_inspector) REFERENCES tecnico_vigilancia(codigo_t_v),
    ADD CONSTRAINT chk_trampas_tipo CHECK (tipo_trampa IN ('JT', 'ML')),
    ADD CONSTRAINT chk_trampas_estado CHECK (estado IN ('B', 'M', 'R', 'C', 'S'));

-- Restricciones para Registro Oficial de Muestras (ROM)
ALTER TABLE registro_oficial_muestras
    ADD CONSTRAINT fk_rom_ruta FOREIGN KEY (n_ruta) REFERENCES ruta(n_ruta),
    ADD CONSTRAINT fk_rom_auxiliar FOREIGN KEY (codigo_auxiliar) REFERENCES auxiliar(codigo_auxiliar),
    ADD CONSTRAINT chk_rom_procedencia CHECK (procedencia IN ('Planta', 'Suelo'));

-- Restricciones para Registro Oficial de Trampas (ROT)
ALTER TABLE registro_oficial_trampas
    ADD CONSTRAINT fk_rot_tecnico FOREIGN KEY (codigo_tecnico) REFERENCES tecnico_vigilancia(codigo_t_v),
    ADD CONSTRAINT fk_rot_vehiculo FOREIGN KEY (placa) REFERENCES vehiculo(placa);

-- Solicitud_vehiculo
ALTER TABLE SOLICITUD_VEHICULO
    ADD COLUMN id_solicitud NUMERIC;
ALTER TABLE SOLICITUD_VEHICULO
    ADD CONSTRAINT fk_vehiculo_solicitud FOREIGN KEY (id_solicitud) REFERENCES SOLICITUD(Id_solicitud);

-- Solicitud_equipo
ALTER TABLE SOLICITUD_EQUIPO 
    ADD COLUMN id_solicitud NUMERIC;
ALTER TABLE SOLICITUD_EQUIPO
    ADD CONSTRAINT fk_equipo_solicitud FOREIGN KEY (id_solicitud) REFERENCES SOLICITUD(Id_solicitud),
    ADD CONSTRAINT chk_equipo_tipo CHECK (tipo_equipo IN ('Mochila fumigadora', 'Motosierra'));