
-- Creacion de la base de datos
DROP DATABASE restaurantedelivery;
CREATE DATABASE IF NOT EXISTS  RestauranteDelivery;
USE RestauranteDelivery;

-- Tabla: Cliente
CREATE TABLE Cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre_cliente VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- Tabla: Sucursal
CREATE TABLE Sucursal (
    id_sucursal INT AUTO_INCREMENT PRIMARY KEY,
    nombre_sucursal VARCHAR(50) NOT NULL
);

-- Tabla: Repartidor
CREATE TABLE Repartidor (
    id_repartidor INT AUTO_INCREMENT PRIMARY KEY,
    nombre_repartidor VARCHAR(50) NOT NULL,
    id_sucursal INT
);

-- Tabla: Producto
CREATE TABLE Producto (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    cantidad INT NOT NULL
);

-- Tabla: Promocion
CREATE TABLE Promocion (
    id_promocion INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(150),
    descuento DECIMAL(5,2)
);

-- Tabla: Pedido
CREATE TABLE Pedido (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_sucursal INT NOT NULL,
    id_repartidor INT NOT NULL,
    fecha_hora DATETIME NOT NULL,
    tipo_entrega ENUM('Delivery','Local') NOT NULL DEFAULT 'Delivery',
    estado ENUM('Preparando','Entregado','En Viaje','Recibido') NOT NULL DEFAULT 'Preparando',
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_sucursal) REFERENCES Sucursal(id_sucursal),
    FOREIGN KEY (id_repartidor) REFERENCES Repartidor(id_repartidor)
);

-- Tabla: Detalle_Pedido (relación N:M entre Pedido y Producto)
CREATE TABLE Detalle_Pedido (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unit DECIMAL(10,2) NOT NULL,
    id_promocion INT,
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto),
    FOREIGN KEY (id_promocion) REFERENCES Promocion(id_promocion)
);

-- Tabla: Pago
CREATE TABLE Pago (
    id_pedido INT PRIMARY KEY,
    metodo ENUM('Efectivo','Tarjeta','Mercado Pago') NOT NULL DEFAULT 'Efectivo',
    estado ENUM('Pendiente','Realizado') NOT NULL DEFAULT 'Pendiente',
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido)
);

-- Tabla: Direccion_Entrega (1:1 con Pedido, solo si es delivery)
CREATE TABLE Direccion_Entrega (
    id_direccion INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    direccion VARCHAR(150),
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido)
);
