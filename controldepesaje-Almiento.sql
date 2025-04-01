-- Script de creación de la base de datos
CREATE DATABASE IF NOT EXISTS gestion_pesaje_camiones;

-- Selección de la base de datos
USE gestion_pesaje_camiones;

-- Tabla Estaciones
CREATE TABLE IF NOT EXISTS Estaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Tabla Camiones
CREATE TABLE IF NOT EXISTS Camiones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patente VARCHAR(10) NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    cantidad_ejes INT NOT NULL
);

-- Tabla Pesajes
CREATE TABLE IF NOT EXISTS Pesajes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATETIME NOT NULL,
    camion_id INT,
    estacion_id INT,
    resultado DECIMAL(10,2) NOT NULL,
    exceso_peso BOOLEAN NOT NULL,
    FOREIGN KEY (camion_id) REFERENCES Camiones(id),
    FOREIGN KEY (estacion_id) REFERENCES Estaciones(id)
);

-- Tabla Ejes
CREATE TABLE IF NOT EXISTS Ejes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pesaje_id INT,
    eje_numero INT NOT NULL,
    peso DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (pesaje_id) REFERENCES Pesajes(id)
);

-- Tabla Sanciones
CREATE TABLE IF NOT EXISTS Sanciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pesaje_id INT,
    descripcion VARCHAR(255) NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (pesaje_id) REFERENCES Pesajes(id)
);

-- Ejemplos de inserción de datos
-- Insertar datos en la tabla Estaciones
INSERT INTO Estaciones (nombre) VALUES ('Campana');
INSERT INTO Estaciones (nombre) VALUES ('Mar del Plata');
INSERT INTO Estaciones (nombre) VALUES ('San Vicente');
INSERT INTO Estaciones (nombre) VALUES ('Las Heras');

-- Insertar datos en la tabla Camiones
INSERT INTO Camiones (patente, tipo, cantidad_ejes) VALUES ('ABC123', 'Camión Liviano', 2);
INSERT INTO Camiones (patente, tipo, cantidad_ejes) VALUES ('XYZ987', 'Camión Pesado', 4);

-- Insertar datos en la tabla Pesajes
INSERT INTO Pesajes (fecha, camion_id, estacion_id, resultado, exceso_peso) VALUES ('2025-03-27 10:00:00', 1, 1, 1500.75, FALSE);
INSERT INTO Pesajes (fecha, camion_id, estacion_id, resultado, exceso_peso) VALUES ('2025-03-27 12:00:00', 2, 2, 2500.50, TRUE);

-- Insertar datos en la tabla Ejes
INSERT INTO Ejes (pesaje_id, eje_numero, peso) VALUES (1, 1, 750.00);
INSERT INTO Ejes (pesaje_id, eje_numero, peso) VALUES (1, 2, 750.75);
INSERT INTO Ejes (pesaje_id, eje_numero, peso) VALUES (2, 1, 1250.25);
INSERT INTO Ejes (pesaje_id, eje_numero, peso) VALUES (2, 2, 1250.25);

-- Insertar datos en la tabla Sanciones
INSERT INTO Sanciones (pesaje_id, descripcion, monto) VALUES (2, 'Exceso de peso', 500.00);

SELECT * FROM Estaciones;
SELECT * FROM Camiones;
SELECT * FROM sanciones;

SELECT p.id, p.fecha, c.patente, p.resultado, p.exceso_peso
FROM Pesajes p
JOIN Camiones c ON p.camion_id = c.id
JOIN Estaciones e ON p.estacion_id = e.id
WHERE e.nombre = 'Campana' AND DATE(p.fecha) = '2025-03-27';

-- Creación de la vista VistaPesajesExcesoPeso
CREATE VIEW VistaPesajesExcesoPeso AS
SELECT 
    p.id AS pesaje_id, 
    p.fecha, 
    c.patente, 
    p.resultado, 
    e.nombre AS estacion, 
    p.exceso_peso
FROM 
    Pesajes p
JOIN 
    Camiones c ON p.camion_id = c.id
JOIN 
    Estaciones e ON p.estacion_id = e.id
WHERE 
    p.exceso_peso = TRUE;

-- Creación de la vista VistaResumenPesajes
CREATE VIEW VistaResumenPesajes AS
SELECT 
    e.nombre AS estacion, 
    COUNT(p.id) AS total_pesajes, 
    SUM(p.resultado) AS peso_total, 
    SUM(CASE WHEN p.exceso_peso THEN 1 ELSE 0 END) AS infracciones
FROM 
    Pesajes p
JOIN 
    Estaciones e ON p.estacion_id = e.id
GROUP BY 
    e.nombre;
    
    
    
    
    