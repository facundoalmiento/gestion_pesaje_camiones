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

USE gestion_pesaje_camiones;

CREATE TABLE Conductores (
  id_conductor INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(50),
  dni VARCHAR(20),
  telefono VARCHAR(20)
);
CREATE TABLE Empresas (
  id_empresa INT PRIMARY KEY AUTO_INCREMENT,
  nombre_empresa VARCHAR(100),
  cuit VARCHAR(20)
);
CREATE TABLE CategoriasCamiones (
  id_categoria INT PRIMARY KEY AUTO_INCREMENT,
  descripcion VARCHAR(100),
  max_peso_total DECIMAL(10,2)
);
CREATE TABLE UsuariosEstacion (
  id_usuario INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(50),
  rol VARCHAR(50),
  turno VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS Mantenimientos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE NOT NULL,
    descripcion TEXT,
    id_estacion INT,
    FOREIGN KEY (id_estacion) REFERENCES Estaciones(id)
);
CREATE TABLE Normativas (
  id_normativa INT PRIMARY KEY AUTO_INCREMENT,
  cantidad_ejes INT,
  peso_maximo_permitido DECIMAL(10,2)
);
CREATE TABLE Alertas (
  id_alerta INT PRIMARY KEY AUTO_INCREMENT,
  patente VARCHAR(20),
  fecha DATE,
  motivo VARCHAR(100)
);
CREATE TABLE IngresosEconomicos (
  id_ingreso INT PRIMARY KEY AUTO_INCREMENT,
  id_sancion INT,
  monto DECIMAL(10,2),
  fecha DATE,
  FOREIGN KEY (id_sancion) REFERENCES Sanciones(id)
);
CREATE TABLE TiposSanciones (
  id_tipo_sancion INT PRIMARY KEY AUTO_INCREMENT,
  descripcion VARCHAR(100),
  monto_base DECIMAL(10,2)
);
CREATE TABLE Auditorias (
  id_auditoria INT PRIMARY KEY AUTO_INCREMENT,
  tabla_afectada VARCHAR(50),
  id_usuario INT,
  fecha_hora DATETIME,
  accion VARCHAR(20)
);

DELIMITER //
CREATE FUNCTION TotalSancionesCamion(camionPatente VARCHAR(10))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE total DECIMAL(10,2);
  SELECT SUM(s.monto) INTO total
  FROM Sanciones s
  JOIN Pesajes p ON s.pesaje_id = p.id
  JOIN Camiones c ON p.camion_id = c.id
  WHERE c.patente = camionPatente;
  RETURN IFNULL(total, 0);
END //
DELIMITER ;
DELIMITER //
CREATE FUNCTION ContarAlertas(pat VARCHAR(10))
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM Alertas WHERE patente = pat;
  RETURN total;
END //
DELIMITER ;
DELIMITER //
CREATE PROCEDURE InsertarAlertaExcesoPeso(IN pesajeId INT)
BEGIN
  DECLARE patenteCamion VARCHAR(10);
  DECLARE fechaActual DATE;
  SELECT c.patente, p.fecha INTO patenteCamion, fechaActual
  FROM Pesajes p
  JOIN Camiones c ON p.camion_id = c.id
  WHERE p.id = pesajeId AND p.exceso_peso = TRUE;
  
  IF patenteCamion IS NOT NULL THEN
    INSERT INTO Alertas (patente, fecha, motivo)
    VALUES (patenteCamion, fechaActual, 'Exceso de peso');
  END IF;
END //
DELIMITER ;
DELIMITER //
CREATE PROCEDURE RegistrarMantenimiento(IN estacionId INT, IN descripcion TEXT)
BEGIN
  INSERT INTO Mantenimientos (fecha, descripcion, id_estacion)
  VALUES (CURDATE(), descripcion, estacionId);
END //
DELIMITER ;
DELIMITER //
CREATE TRIGGER auditoria_insert_pesaje
AFTER INSERT ON Pesajes
FOR EACH ROW
BEGIN
  INSERT INTO Auditorias (tabla_afectada, id_usuario, fecha_hora, accion)
  VALUES ('Pesajes', NULL, NOW(), 'INSERT');
END //
DELIMITER ;
DELIMITER //
CREATE TRIGGER auditoria_insert_sancion
AFTER INSERT ON Sanciones
FOR EACH ROW
BEGIN
  INSERT INTO Auditorias (tabla_afectada, id_usuario, fecha_hora, accion)
  VALUES ('Sanciones', NULL, NOW(), 'INSERT');
END //
DELIMITER ;

CREATE VIEW VistaSancionesPorEstacion AS
SELECT e.nombre AS estacion, SUM(s.monto) AS total_sanciones
FROM Sanciones s
JOIN Pesajes p ON s.pesaje_id = p.id
JOIN Estaciones e ON p.estacion_id = e.id
GROUP BY e.nombre;

CREATE VIEW VistaCamionesReincidentes AS
SELECT c.patente, COUNT(*) AS cantidad_infracciones
FROM Camiones c
JOIN Pesajes p ON c.id = p.camion_id
WHERE p.exceso_peso = TRUE
GROUP BY c.patente
HAVING COUNT(*) > 1;

CREATE VIEW VistaMantenimientosRecientes AS
SELECT m.*, e.nombre AS estacion
FROM Mantenimientos m
JOIN Estaciones e ON m.id_estacion = e.id
WHERE m.fecha >= CURDATE() - INTERVAL 30 DAY;

CREATE VIEW VistaPesajesTotales AS
SELECT c.tipo, COUNT(p.id) AS total_pesajes, SUM(p.resultado) AS peso_total
FROM Camiones c
JOIN Pesajes p ON c.id = p.camion_id
GROUP BY c.tipo;



