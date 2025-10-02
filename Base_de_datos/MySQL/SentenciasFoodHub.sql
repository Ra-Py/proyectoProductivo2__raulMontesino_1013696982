create database foodHub;

use foodHub;

-- Tabla: roles
CREATE TABLE roles (
    idRol INT AUTO_INCREMENT PRIMARY KEY,
    rol VARCHAR(45)
);

-- Tabla: usuarios
CREATE TABLE usuarios (
    idCliente INT AUTO_INCREMENT PRIMARY KEY,
    nombreCliente VARCHAR(25),
    apellidoCliente VARCHAR(30),
    telefonoCliente VARCHAR(15),
    correoCliente VARCHAR(50),
    rol_id INT,
    FOREIGN KEY (rol_id) REFERENCES roles(idRol)
);

-- Tabla: reservas
CREATE TABLE reservas (
    idReserva INT AUTO_INCREMENT PRIMARY KEY,
    fechaReserva DATETIME,
    fechaRealizacion TIMESTAMP,
    cliente_id INT,
    rol_id INT,
    FOREIGN KEY (cliente_id) REFERENCES usuarios(idCliente),
    FOREIGN KEY (rol_id) REFERENCES roles(idRol)
);

-- Tabla: ventas
CREATE TABLE ventas (
    idVenta INT AUTO_INCREMENT PRIMARY KEY,
    fechaVenta DATE,
    montoTotal DECIMAL(10,2),
    rol_id INT,
    cliente_id INT,
    FOREIGN KEY (rol_id) REFERENCES roles(idRol),
    FOREIGN KEY (cliente_id) REFERENCES usuarios(idCliente)
);

-- Tabla: detalleVenta
CREATE TABLE detalleVenta (
    idDetalleVenta INT AUTO_INCREMENT PRIMARY KEY,
    cantidad INT,
    precio FLOAT,
    venta_id INT,
    cliente_id INT,
    FOREIGN KEY (venta_id) REFERENCES ventas(idVenta),
    FOREIGN KEY (cliente_id) REFERENCES usuarios(idCliente)
);

-- Tabla: productos
CREATE TABLE productos (
    idProducto INT AUTO_INCREMENT PRIMARY KEY,
    nombreProducto VARCHAR(45),
    precio FLOAT,
    categoria ENUM('Electrónica', 'Ropa', 'Alimentos', 'Servicios', 'Otros') default 'Otros'
);

-- Tabla: detalleVenta_has_productos
CREATE TABLE detalleVenta_has_productos (
    detalleVenta_id INT,
    detalleVenta_idVenta INT,
    detalleVenta_cliente_id INT,
    producto_id INT,
    rol_id INT,
    PRIMARY KEY (
        detalleVenta_id,
        detalleVenta_idVenta,
        detalleVenta_cliente_id,
        producto_id,
        rol_id
    ),
    FOREIGN KEY (detalleVenta_id) REFERENCES detalleVenta(idDetalleVenta),
    FOREIGN KEY (detalleVenta_idVenta) REFERENCES ventas(idVenta),
    FOREIGN KEY (detalleVenta_cliente_id) REFERENCES usuarios(idCliente),
    FOREIGN KEY (rol_id) REFERENCES roles(idRol),
    FOREIGN KEY (producto_id) REFERENCES productos(idProducto)
);

-- Tabla: ventas_has_productos
CREATE TABLE ventas_has_productos (
    venta_id INT,
    ventas_idCliente INT,
    rol_id INT,
    producto_id INT,
    PRIMARY KEY (
        venta_id,
        ventas_idCliente,
        rol_id,
        producto_id
    ),
    FOREIGN KEY (venta_id) REFERENCES ventas(idVenta),
    FOREIGN KEY (ventas_idCliente) REFERENCES usuarios(idCliente),
    FOREIGN KEY (rol_id) REFERENCES roles(idRol),
    FOREIGN KEY (producto_id) REFERENCES productos(idProducto)
);

-- Insertar roles
INSERT INTO roles (rol) VALUES 
('Administrador'),   -- idRol = 1
('Cliente');         -- idRol = 2

INSERT INTO usuarios (nombreCliente, apellidoCliente, telefonoCliente, correoCliente, rol_id) VALUES
('Raúl', 'González', '3001234567', 'raul@foodhub.com', 2),
('Lucía', 'Martínez', '3019876543', 'lucia@foodhub.com', 2),
('Carlos', 'Ramírez', '3024567890', 'carlos@foodhub.com', 1),
('Ana', 'Torres', '3031112222', 'ana@foodhub.com', 2),
('Miguel', 'López', '3043334444', 'miguel@foodhub.com', 2),
('Sofía', 'Pérez', '3055556666', 'sofia@foodhub.com', 2),
('Jorge', 'Mendoza', '3067778888', 'jorge@foodhub.com', 2),
('Valentina', 'Ríos', '3079990000', 'valentina@foodhub.com', 2),
('Andrés', 'Suárez', '3081112222', 'andres@foodhub.com', 2),
('Camila', 'Vargas', '3093334444', 'camila@foodhub.com', 2);

INSERT INTO productos (nombreProducto, precio, categoria) VALUES
('Hamburguesa Clásica', 18.50, 'Alimentos'),
('Combo Familiar', 45.00, 'Alimentos'),
('Servicio de Catering', 250.00, 'Servicios'),
('Camiseta FoodHub', 30.00, 'Ropa'),
('Pizza Mediana', 22.00, 'Alimentos'),
('Ensalada Vegana', 15.00, 'Alimentos'),
('Bebida Refrescante', 5.00, 'Alimentos'),
('Postre Gourmet', 12.00, 'Alimentos'),
('Tarjeta Regalo', 100.00, 'Servicios'),
('Gorra FoodHub', 20.00, 'Ropa');

-- Ventas
INSERT INTO ventas (fechaVenta, montoTotal, rol_id, cliente_id) VALUES
('2025-09-01', 63.50, 2, 1),
('2025-09-02', 280.00, 2, 2),
('2025-09-03', 22.00, 2, 4),
('2025-09-04', 45.00, 2, 5),
('2025-09-05', 250.00, 2, 6),
('2025-09-06', 30.00, 2, 7),
('2025-09-07', 37.00, 2, 8),
('2025-09-08', 17.00, 2, 9),
('2025-09-09', 100.00, 2, 10),
('2025-09-10', 50.00, 2, 1),
('2025-09-11', 60.00, 2, 2),
('2025-09-12', 90.00, 2, 3),
('2025-09-13', 75.00, 2, 4),
('2025-09-14', 40.00, 2, 5),
('2025-09-15', 55.00, 2, 6);

-- DetalleVenta
INSERT INTO detalleVenta (cantidad, precio, venta_id, cliente_id) VALUES
(1, 18.50, 1, 1),
(1, 45.00, 1, 1),
(1, 250.00, 2, 2),
(1, 22.00, 3, 4),
(1, 45.00, 4, 5),
(1, 250.00, 5, 6),
(1, 30.00, 6, 7),
(2, 5.00, 7, 8),
(1, 12.00, 7, 8),
(1, 15.00, 8, 9),
(1, 100.00, 9, 10),
(1, 30.00, 10, 1),
(1, 20.00, 10, 1),
(2, 30.00, 11, 2),
(1, 60.00, 12, 3),
(1, 45.00, 13, 4),
(1, 30.00, 13, 4),
(2, 20.00, 14, 5),
(1, 15.00, 15, 6),
(2, 20.00, 15, 6);

-- detalleVenta_has_productos
INSERT INTO detalleVenta_has_productos (
    detalleVenta_id, detalleVenta_idVenta, detalleVenta_cliente_id, producto_id, rol_id
) VALUES
(1, 1, 1, 1, 2),
(2, 1, 1, 2, 2),
(3, 2, 2, 3, 2),
(4, 3, 4, 5, 2),
(5, 4, 5, 2, 2),
(6, 5, 6, 3, 2),
(7, 6, 7, 4, 2),
(8, 7, 8, 7, 2),
(9, 7, 8, 8, 2),
(10, 8, 9, 6, 2),
(11, 9, 10, 9, 2),
(12, 10, 1, 4, 2),
(13, 10, 1, 10, 2),
(14, 11, 2, 4, 2),
(15, 12, 3, 2, 2),
(16, 13, 4, 2, 2),
(17, 13, 4, 4, 2),
(18, 14, 5, 10, 2),
(19, 15, 6, 6, 2),
(20, 15, 6, 10, 2);

-- ventas_has_productos
INSERT INTO ventas_has_productos (
    venta_id, ventas_idCliente, rol_id, producto_id
) VALUES
(1, 1, 2, 1),
(1, 1, 2, 2),
(2, 2, 2, 3),
(3, 4, 2, 5),
(4, 5, 2, 2),
(5, 6, 2, 3),
(6, 7, 2, 4),
(7, 8, 2, 7),
(7, 8, 2, 8),
(8, 9, 2, 6),
(9, 10, 2, 9),
(10, 1, 2, 4),
(10, 1, 2, 10),
(11, 2, 2, 4),
(12, 3, 2, 2),
(13, 4, 2, 2),
(13, 4, 2, 4),
(14, 5, 2, 10),
(15, 6, 2, 6),
(15, 6, 2, 10);

INSERT INTO reservas (fechaReserva, fechaRealizacion, cliente_id, rol_id) VALUES
('2025-09-01 18:00:00', CURRENT_TIMESTAMP, 1, 2),
('2025-09-03 12:30:00', CURRENT_TIMESTAMP, 2, 2),
('2025-09-05 19:00:00', CURRENT_TIMESTAMP, 4, 2),
('2025-09-07 14:00:00', CURRENT_TIMESTAMP, 6, 2),
('2025-09-10 20:00:00', CURRENT_TIMESTAMP, 9, 2);
