-- Restricciones para Tecnico de vigilancia
ALTER TABLE tecnico_vigilancia
    ADD CONSTRAINT uk_tecnico_placa UNIQUE (placa),
    ADD CONSTRAINT fk_tecnico_trabajor FOREIGN KEY (codigo_trabajador) REFERENCES trabajador(codigo);

-- Restricciones para Vehiculo
ALTER TABLE vehiculo
    ADD CONSTRAINT fk_vehiculo_ruta FOREIGN KEY (n_ruta) REFERENCES ruta(n_ruta);

-- Restricciones para Trabajo diario
ALTER TABLE trabajo_diario
    ADD CONSTRAINT fk_trabajo_auxiliar FOREIGN KEY (auxiliar_encargado) REFERENCES trabajador(codigo),
    ADD CONSTRAINT fk_trabajo_ruta FOREIGN KEY (n_ruta) REFERENCES ruta(n_ruta);