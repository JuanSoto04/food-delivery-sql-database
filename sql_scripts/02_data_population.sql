-- ===================================
-- MODIFICACIONES Tablas
-- ===================================

ALTER TABLE Cliente RENAME COLUMN nombre to nombre_cliente;
ALTER TABLE Sucursal RENAME COLUMN nombre to nombre_sucursal;
ALTER TABLE Repartidor RENAME COLUMN nombre to nombre_repartidor;
ALTER TABLE Producto RENAME COLUMN nombre to nombre_producto;
ALTER TABLE Pedido
  MODIFY id_repartidor INT NULL;

-- ===================================
-- INSERCIÓN DE DATOS INICIALES
-- ===================================

-- CLIENTES
INSERT INTO Cliente (nombre_cliente, email) VALUES
('Juan Perez', 'juanperez05@gmail.com'),
('Maria Gomez', 'mariagomez03@gmail.com'),
('Lucas Fernandez', 'lucasfernandez09@gmail.com'),
('Ana Torres', 'anatorres02@gmail.com'),
('Pedro Lopez', 'pedrolopez07@gmail.com'),
('Carla Ruiz', 'carlaruiz04@gmail.com'),
('Nicolas Rojas', 'nicolasrojas01@gmail.com'),
('Sofia Diaz', 'sofiadiaz06@gmail.com'),
('Martín Alvarez', 'martinalvarez08@gmail.com'),
('Laura Campos', 'lauracampos10@gmail.com'),
('Diego Herrera', 'diegoherrera03@gmail.com'),
('Valentina Sosa', 'valentinasosa07@gmail.com'),
('Mateo Castro', 'mateocastro04@gmail.com'),
('Julieta Blanco', 'julietablanco01@gmail.com'),
('Andres Medina', 'andresmedina02@gmail.com');

-- SUCURSALES
INSERT INTO Sucursal (nombre_sucursal) VALUES
('Mr. Tacon Lomas'),
('Mr. Tacon Temperley'),
('Mr. Tacon Banfield');

-- REPARTIDORES
INSERT INTO Repartidor (nombre_repartidor, id_sucursal) VALUES
('Martin Solis', 1),
('Carlos Vega', 1),
('Luis Herrera', 1),
('Javier Ortiz', 1),
('Miguel Torres', 2),
('Santiago Rios', 2),
('Pablo Castro', 3),
('Diego Ramos', 3);

-- PRODUCTOS (13 comidas + 3 bebidas)
INSERT INTO Producto (nombre_producto, precio, cantidad) VALUES
('Taco de Carne', 1200, 100),
('Taco de Pollo', 1100, 120),
('Taco de Cerdo', 1150, 90),
('Taco Veggie', 1000, 80),
('Taco de Chorizo', 1250, 70),
('Taco de Pescado', 1300, 60),
('Taco de Camarón', 1400, 50),
('Taco de Barbacoa', 1350, 75),
('Taco de Pastor', 1250, 85),
('Taco con Queso', 1150, 100),
('Nachos con Queso', 950, 120),
('Quesadilla', 1050, 110),
('Burrito Mixto', 1500, 65),
('Agua', 400, 200),
('Gaseosa', 700, 180),
('Cerveza', 900, 150);

-- PROMOCIONES
INSERT INTO Promocion (id_promocion, descripcion, descuento) VALUES
(1, 'Sin promoción', 0),
(2, 'Happy Friday', 10),
(3, 'Descuento de 15% en compras superiores a $5000', 15),
(4, 'Descuento de 5% por cada compra mayor a $3000', 5);

-- PEDIDOS

-- MODIFICACION A TABLA PEDIDO

ALTER TABLE Pedido
  MODIFY id_repartidor INT NULL;
  
INSERT INTO Pedido (id_pedido, id_cliente, id_sucursal, id_repartidor, fecha_hora, tipo_entrega, estado)
VALUES
(1,  3, 1,  2, '2025-08-01 12:45:00', 'Delivery', 'Entregado'),
(2,  7, 1,  4, '2025-08-01 13:10:00', 'Delivery', 'Entregado'),
(3,  1, 1,  NULL, '2025-08-01 13:30:00', 'Local', 'Recibido'),
(4, 12, 2,  5, '2025-08-01 14:05:00', 'Delivery', 'En Viaje'),
(5,  4, 1,  3, '2025-08-01 14:20:00', 'Delivery', 'Preparando'),
(6,  9, 3,  8, '2025-08-01 14:55:00', 'Delivery', 'Entregado'),
(7, 15, 1,  1, '2025-08-01 15:15:00', 'Delivery', 'Entregado'),
(8,  5, 1,  NULL, '2025-08-01 15:40:00', 'Local', 'Recibido'),
(9, 11, 2,  6, '2025-08-01 16:00:00', 'Delivery', 'En Viaje'),
(10, 8, 1,  2, '2025-08-01 16:25:00', 'Delivery', 'Entregado'),
(11, 2, 3,  8, '2025-08-01 16:50:00', 'Delivery', 'Preparando'),
(12, 6, 1,  3, '2025-08-01 17:10:00', 'Delivery', 'Entregado'),
(13, 7, 1,  1, '2025-08-01 17:35:00', 'Delivery', 'En Viaje'),
(14, 3, 2,  5, '2025-08-01 18:00:00', 'Delivery', 'Entregado'),
(15, 1, 1,  4, '2025-08-01 18:20:00', 'Delivery', 'Entregado'),
(16, 10, 1,  2, '2025-08-01 18:50:00', 'Delivery', 'Entregado'),
(17, 13, 3,  7, '2025-08-01 19:10:00', 'Delivery', 'Preparando'),
(18, 5, 1,  NULL, '2025-08-01 19:25:00', 'Local', 'Recibido'),
(19, 4, 2,  6, '2025-08-01 19:40:00', 'Delivery', 'En Viaje'),
(20, 9, 1,  1, '2025-08-01 20:00:00', 'Delivery', 'Entregado'),
(21, 2, 1,  3, '2025-08-01 20:20:00', 'Delivery', 'Preparando'),
(22, 14, 3,  8, '2025-08-01 20:35:00', 'Delivery', 'En Viaje'),
(23, 6, 1,  4, '2025-08-01 20:50:00', 'Delivery', 'Entregado'),
(24, 11, 2,  5, '2025-08-01 21:10:00', 'Delivery', 'Entregado'),
(25, 8, 1,  2, '2025-08-01 21:30:00', 'Delivery', 'En Viaje'),
(26, 12, 3,  7, '2025-08-01 21:50:00', 'Delivery', 'Entregado'),
(27, 10, 1,  1, '2025-08-01 22:10:00', 'Delivery', 'Entregado'),
(28, 3, 1,  4, '2025-08-01 22:25:00', 'Delivery', 'Preparando'),
(29, 7, 1,  NULL, '2025-08-01 22:40:00', 'Local', 'Recibido'),
(30, 15, 2,  6, '2025-08-01 23:00:00', 'Delivery', 'Entregado');



-- DETALLE PEDIDO
INSERT INTO Detalle_pedido (id_detalle, id_pedido, id_producto, cantidad, precio_unit, id_promocion)
VALUES
(1,1, 2,2, 950,1), (2,1, 14,1, 400,1),
(3,2, 5,1, 1100,2), (4,2, 15,2, 500,1),
(5,3, 1,3, 900,1),
(6,4, 4,2, 1200,3), (7,4, 16,1, 350,3),
(8,5, 3,1, 1050,1), (9,5, 14,1, 400,1),
(10,6, 6,2, 1300,1),
(11,7, 2,1, 950,1), (12,7, 15,1, 500,1),
(13,8, 7,3, 1250,4),
(14,9, 4,2, 1200,1), (15,9, 14,1, 400,1),
(16,10, 3,2, 1050,1),
(17,11, 8,2, 1350,1),
(18,12, 9,2, 1400,1),
(19,13, 10,1, 1500,1),
(20,14, 2,2, 950,2), (21,14, 16,1, 350,1),
(22,15, 5,2, 1100,1),
(23,16, 6,1, 1300,1), (24,16, 15,1, 500,1),
(25,17, 1,2, 900,3),
(26,18, 3,1, 1050,1),
(27,19, 4,2, 1200,1), (28,19, 16,1, 350,1),
(29,20, 5,2, 1100,1),
(30,21, 6,1, 1300,1),
(31,22, 2,2, 950,1), (32,22, 14,2, 400,1),
(33,23, 3,1, 1050,2),
(34,24, 8,2, 1350,1),
(35,25, 9,2, 1400,1),
(36,26, 10,2, 1500,1),
(37,27, 7,3, 1250,4),
(38,28, 5,1, 1100,1),
(39,29, 2,1, 950,1),
(40,30, 6,2, 1300,2);



-- PAGO
INSERT INTO Pago (id_pedido, metodo, estado)
VALUES
(1,'Efectivo','Realizado'),
(2,'Tarjeta','Realizado'),
(3,'Efectivo','Pendiente'),
(4,'Mercado Pago','Realizado'),
(5,'Tarjeta','Pendiente'),
(6,'Efectivo','Realizado'),
(7,'Tarjeta','Realizado'),
(8,'Efectivo','Pendiente'),
(9,'Mercado Pago','Realizado'),
(10,'Tarjeta','Realizado'),
(11,'Efectivo','Pendiente'),
(12,'Mercado Pago','Realizado'),
(13,'Tarjeta','Realizado'),
(14,'Efectivo','Realizado'),
(15,'Mercado Pago','Pendiente'),
(16,'Tarjeta','Realizado'),
(17,'Efectivo','Realizado'),
(18,'Mercado Pago','Pendiente'),
(19,'Tarjeta','Realizado'),
(20,'Efectivo','Realizado'),
(21,'Mercado Pago','Pendiente'),
(22,'Tarjeta','Realizado'),
(23,'Efectivo','Realizado'),
(24,'Tarjeta','Realizado'),
(25,'Mercado Pago','Pendiente'),
(26,'Efectivo','Realizado'),
(27,'Tarjeta','Realizado'),
(28,'Mercado Pago','Pendiente'),
(29,'Efectivo','Pendiente'),
(30,'Tarjeta','Realizado');

-- DIRECCION ENTREGA
INSERT INTO Direccion_entrega (id_pedido, direccion)
VALUES
(1,'Lavalle 537'),(2,'Sarmiento 324'),(3,'Belgrano 190'),(4,'Alsina 410'),
(5,'Mitre 257'),(6,'Rivadavia 890'),(7,'San Martin 105'),
(8,'Dorrego 77'),(9,'Urquiza 642'),(10,'Colón 155'),
(11,'Castelli 345'),(12,'Saavedra 589'),(13,'Güemes 212'),
(14,'French 472'),(15,'Garibaldi 386'),(16,'España 699'),
(17,'Catamarca 517'),(18,'Balcarce 341'),(19,'Mendoza 173'),
(20,'9 de Julio 228'),(21,'Rosales 471'),(22,'Chacabuco 560'),
(23,'Pringles 487'),(24,'Ituzaingó 231'),(25,'Dean Funes 675'),
(26,'Esquiú 308'),(27,'Belén 589'),(28,'Vicente López 312'),
(29,'Córdoba 129'),(30,'Tucumán 451');

