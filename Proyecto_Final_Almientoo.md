# Proyecto Final - Almiento

## Introducción

El proyecto consiste en la creación de una base de datos para el monitoreo de pesaje de camiones en diversas estaciones de pesaje. La base de datos permitirá registrar información sobre las estaciones, los camiones, los pesajes realizados y las sanciones aplicadas por exceso de peso. Además, incluirá funcionalidades adicionales como alertas, mantenimientos de estaciones y análisis de datos.

## Objetivo

El objetivo principal del proyecto es crear una solución que facilite el control y monitoreo del peso de los camiones, asegurando el cumplimiento de las regulaciones de peso y mejorando la seguridad en el transporte. La base de datos contendrá información relevante para la gestión de estaciones de pesaje, administración de sanciones y generación de reportes analíticos.

## Situación Problemática

La implementación de una base de datos para el monitoreo de pesaje de camiones aborda la necesidad de controlar el peso de los camiones para evitar daños en las carreteras y mejorar la seguridad en el transporte. La base de datos permitirá registrar y gestionar los pesajes realizados, identificar posibles infracciones, generar alertas y aplicar sanciones correspondientes.

## Modelo de Negocio

La base de datos será utilizada por operadores de estaciones de pesaje. Los operadores registrarán los pesajes de los camiones, verificarán el cumplimiento de las regulaciones de peso y gestionarán las sanciones por exceso de peso. También se permitirá registrar mantenimientos de estaciones, monitorear alertas y generar reportes analíticos para la toma de decisiones.

## Diagrama E-R

![Diagrama E-R](https://github.com/facundoalmiento/gestion_pesaje_camiones/blob/main/images/diagrama-er.png)

## Listado de Tablas

### Tabla `Estaciones`

- **Descripción**: Almacena información sobre las estaciones de pesaje.
- **Campos**:
  - `id`: Identificador único de la estación (INT, PRIMARY KEY, AUTO_INCREMENT).
  - `nombre`: Nombre de la estación (VARCHAR(100), NOT NULL).

### Tabla `Camiones`

- **Descripción**: Almacena información sobre los camiones.
- **Campos**:
  - `id`: Identificador único del camión (INT, PRIMARY KEY, AUTO_INCREMENT).
  - `patente`: Patente del camión (VARCHAR(10), NOT NULL).
  - `tipo`: Tipo de camión (VARCHAR(50), NOT NULL).
  - `cantidad_ejes`: Cantidad de ejes del camión (INT, NOT NULL).

### Tabla `Pesajes`

- **Descripción**: Registra los pesajes realizados.
- **Campos**:
  - `id`: Identificador único del pesaje (INT, PRIMARY KEY, AUTO_INCREMENT).
  - `fecha`: Fecha y hora del pesaje (DATETIME, NOT NULL).
  - `camion_id`: Referencia al camión (INT, FOREIGN KEY, NOT NULL).
  - `estacion_id`: Referencia a la estación de pesaje (INT, FOREIGN KEY, NOT NULL).
  - `resultado`: Resultado del pesaje (DECIMAL(10,2), NOT NULL).
  - `exceso_peso`: Indicador de exceso de peso (BOOLEAN, NOT NULL).

### Tabla `Ejes`

- **Descripción**: Almacena el peso de cada eje para los pesajes.
- **Campos**:
  - `id`: Identificador único del eje (INT, PRIMARY KEY, AUTO_INCREMENT).
  - `pesaje_id`: Referencia al pesaje (INT, FOREIGN KEY, NOT NULL).
  - `eje_numero`: Número del eje (INT, NOT NULL).
  - `peso`: Peso del eje (DECIMAL(10,2), NOT NULL).

### Tabla `Sanciones`

- **Descripción**: Almacena información sobre las sanciones aplicadas.
- **Campos**:
  - `id`: Identificador único de la sanción (INT, PRIMARY KEY, AUTO_INCREMENT).
  - `pesaje_id`: Referencia al pesaje (INT, FOREIGN KEY, NOT NULL).
  - `descripcion`: Descripción de la sanción (VARCHAR(255), NOT NULL).
  - `monto`: Monto de la sanción (DECIMAL(10,2), NOT NULL).

### Tabla `Conductores`

- **Descripción**: Almacena información de los conductores de camiones.
- **Campos**:
  - `id_conductor`: Identificador único del conductor (INT, PRIMARY KEY, AUTO_INCREMENT).
  - `nombre`: Nombre del conductor (VARCHAR(50)).
  - `dni`: Documento Nacional de Identidad (VARCHAR(20)).
  - `telefono`: Número de teléfono del conductor (VARCHAR(20)).

### Tabla `Empresas`

- **Descripción**: Almacena información sobre las empresas propietarias de los camiones.
- **Campos**:
  - `id_empresa`: Identificador único de la empresa (INT, PRIMARY KEY, AUTO_INCREMENT).
  - `nombre_empresa`: Nombre de la empresa (VARCHAR(100)).
  - `cuit`: Número de CUIT de la empresa (VARCHAR(20)).

### Tabla `CategoriasCamiones`

- **Descripción**: Define categorías de camiones según su capacidad y características.
- **Campos**:
  - `id_categoria`: Identificador único de la categoría (INT, PRIMARY KEY, AUTO_INCREMENT).
  - `descripcion`: Descripción de la categoría (VARCHAR(100)).
  - `max_peso_total`: Peso máximo permitido para la categoría (DECIMAL(10,2)).

### Tabla `UsuariosEstacion`

- **Descripción**: Almacena información sobre los usuarios de las estaciones de pesaje.
- **Campos**:
  - `id_usuario`: Identificador único del usuario (INT, PRIMARY KEY, AUTO_INCREMENT).
  - `nombre`: Nombre del usuario (VARCHAR(50)).
  - `rol`: Rol del usuario (VARCHAR(50)).
  - `turno`: Turno asignado al usuario (VARCHAR(20)).

### Tabla `Mantenimientos`

- **Descripción**: Registra los mantenimientos realizados en las estaciones.
- **Campos**:
  - `id`: Identificador único del mantenimiento (INT, PRIMARY KEY, AUTO_INCREMENT).
  - `fecha`: Fecha del mantenimiento (DATE, NOT NULL).
  - `descripcion`: Descripción del mantenimiento (TEXT).
  - `id_estacion`: Referencia a la estación donde se realizó el mantenimiento (INT, FOREIGN KEY).

### Tabla `Normativas`

- **Descripción**: Define las normativas de peso máximo permitido según la cantidad de ejes.
- **Campos**:
  - `id_normativa`: Identificador único de la normativa (INT, PRIMARY KEY, AUTO_INCREMENT).
  - `cantidad_ejes`: Cantidad de ejes (INT).
  - `peso_maximo_permitido`: Peso máximo permitido (DECIMAL(10,2)).

### Tabla `Alertas`

- **Descripción**: Registra alertas generadas por exceso de peso u otras situaciones.
- **Campos**:
  - `id_alerta`: Identificador único de la alerta (INT, PRIMARY KEY, AUTO_INCREMENT).
  - `patente`: Patente del camión (VARCHAR(20)).
  - `fecha`: Fecha de la alerta (DATE).
  - `motivo`: Motivo de la alerta (VARCHAR(100)).

### Tabla `IngresosEconomicos`

- **Descripción**: Registra los ingresos económicos derivados de sanciones.
- **Campos**:
  - `id_ingreso`: Identificador único del ingreso (INT, PRIMARY KEY, AUTO_INCREMENT).
  - `id_sancion`: Referencia a la sanción (INT, FOREIGN KEY).
  - `monto`: Monto del ingreso económico (DECIMAL(10,2)).
  - `fecha`: Fecha en que se generó el ingreso (DATE).

### Tabla `TiposSanciones`

- **Descripción**: Define los tipos de sanciones y sus montos base.
- **Campos**:
  - `id_tipo_sancion`: Identificador único del tipo de sanción (INT, PRIMARY KEY, AUTO_INCREMENT).
  - `descripcion`: Descripción del tipo de sanción (VARCHAR(100)).
  - `monto_base`: Monto base asociado al tipo de sanción (DECIMAL(10,2)).

### Tabla `Auditorias`

- **Descripción**: Registra cambios realizados en la base de datos.
- **Campos**:
  - `id_auditoria`: Identificador único de la auditoría (INT, PRIMARY KEY, AUTO_INCREMENT).
  - `tabla_afectada`: Nombre de la tabla modificada (VARCHAR(50)).
  - `id_usuario`: Identificador del usuario que realizó la acción (INT).
  - `fecha_hora`: Fecha y hora de la acción (DATETIME).
  - `accion`: Acción realizada (e.g., INSERT, UPDATE, DELETE) (VARCHAR(20)).

## Listado de Vistas

### Vista `VistaPesajesExcesoPeso`

```sql
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
```

### Vista `VistaResumenPesajes`

```sql
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
```

### Vista `VistaSancionesPorEstacion`

```sql
CREATE VIEW VistaSancionesPorEstacion AS
SELECT e.nombre AS estacion, SUM(s.monto) AS total_sanciones
FROM Sanciones s
JOIN Pesajes p ON s.pesaje_id = p.id
JOIN Estaciones e ON p.estacion_id = e.id
GROUP BY e.nombre;
```

### Vista `VistaCamionesReincidentes`

```sql
CREATE VIEW VistaCamionesReincidentes AS
SELECT c.patente, COUNT(*) AS cantidad_infracciones
FROM Camiones c
JOIN Pesajes p ON c.id = p.camion_id
WHERE p.exceso_peso = TRUE
GROUP BY c.patente
HAVING COUNT(*) > 1;
```

### Vista `VistaMantenimientosRecientes`

```sql
CREATE VIEW VistaMantenimientosRecientes AS
SELECT m.*, e.nombre AS estacion
FROM Mantenimientos m
JOIN Estaciones e ON m.id_estacion = e.id
WHERE m.fecha >= CURDATE() - INTERVAL 30 DAY;
```

### Vista `VistaPesajesTotales`

```sql
CREATE VIEW VistaPesajesTotales AS
SELECT c.tipo, COUNT(p.id) AS total_pesajes, SUM(p.resultado) AS peso_total
FROM Camiones c
JOIN Pesajes p ON c.id = p.camion_id
GROUP BY c.tipo;
```

## Listado de Funciones

### Función `CalcularPesoTotal`

```sql
DELIMITER //
CREATE FUNCTION CalcularPesoTotal(pesajeId INT) RETURNS DECIMAL(10,2)
BEGIN
    DECLARE pesoTotal DECIMAL(10,2);
    SELECT SUM(peso) INTO pesoTotal FROM Ejes WHERE pesaje_id = pesajeId;
    RETURN pesoTotal;
END;
//
DELIMITER ;
```

### Función `TotalSancionesCamion`

```sql
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
END;
//
DELIMITER ;
```

### Función `ContarAlertas`

```sql
DELIMITER //
CREATE FUNCTION ContarAlertas(pat VARCHAR(10))
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM Alertas WHERE patente = pat;
  RETURN total;
END;
//
DELIMITER ;
```

## Listado de Stored Procedures

### Procedimiento `RegistrarPesaje`

```sql
DELIMITER //
CREATE PROCEDURE RegistrarPesaje(
    IN fecha DATETIME,
    IN camionId INT,
    IN estacionId INT,
    IN resultado DECIMAL(10,2),
    IN excesoPeso BOOLEAN,
    IN ejes JSON
)
BEGIN
    DECLARE pesajeId INT;
    INSERT INTO Pesajes (fecha, camion_id, estacion_id, resultado, exceso_peso)
    VALUES (fecha, camionId, estacionId, resultado, excesoPeso);
    SET pesajeId = LAST_INSERT_ID();

    -- Insertar los ejes
    DECLARE i INT DEFAULT 0;
    DECLARE ejeNum INT;
    DECLARE pesoEje DECIMAL(10,2);

    WHILE i < JSON_LENGTH(ejes) DO
        SET ejeNum = JSON_UNQUOTE(JSON_EXTRACT(ejes, CONCAT('$[', i, '].eje_numero')));
        SET pesoEje = JSON_UNQUOTE(JSON_EXTRACT(ejes, CONCAT('$[', i, '].peso')));
        INSERT INTO Ejes (pesaje_id, eje_numero, peso) VALUES (pesajeId, ejeNum, pesoEje);
        SET i = i + 1;
    END WHILE;
END;
//
DELIMITER ;
```

### Procedimiento `InsertarAlertaExcesoPeso`

```sql
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
END;
//
DELIMITER ;
```

### Procedimiento `RegistrarMantenimiento`

```sql
DELIMITER //
CREATE PROCEDURE RegistrarMantenimiento(IN estacionId INT, IN descripcion TEXT)
BEGIN
  INSERT INTO Mantenimientos (fecha, descripcion, id_estacion)
  VALUES (CURDATE(), descripcion, estacionId);
END;
//
DELIMITER ;
```

## Listado de Triggers

### Trigger `auditoria_insert_pesaje`

```sql
DELIMITER //
CREATE TRIGGER auditoria_insert_pesaje
AFTER INSERT ON Pesajes
FOR EACH ROW
BEGIN
  INSERT INTO Auditorias (tabla_afectada, id_usuario, fecha_hora, accion)
  VALUES ('Pesajes', NULL, NOW(), 'INSERT');
END;
//
DELIMITER ;
```

### Trigger `auditoria_insert_sancion`

```sql
DELIMITER //
CREATE TRIGGER auditoria_insert_sancion
AFTER INSERT ON Sanciones
FOR EACH ROW
BEGIN
  INSERT INTO Auditorias (tabla_afectada, id_usuario, fecha_hora, accion)
  VALUES ('Sanciones', NULL, NOW(), 'INSERT');
END;
//
DELIMITER ;
```
