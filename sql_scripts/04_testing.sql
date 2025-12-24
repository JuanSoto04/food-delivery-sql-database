
-- -------------------ARCHIVO PRUEBA DE OBJETOS----------------

-- ============================================================
--  							VISTAS
-- ============================================================

-- Prueba View 1: Pedidos pendientes y preperando (no entregados)
SELECT * from vw_pedidos_pendiente_entrega;
-- Prueba View 2: Ventas por sucursal
SELECT * from vw_ventas_por_sucursal;
-- Prueba View 3: Stock actual de productos
SELECT * from vw_stock_productos;
-- Prueba View 4: Cantidad de promociones usadas
SELECT * from vw_promociones_uso;
-- Prueba View 5: Productos mas vendidos
SELECT * from vw_productos_top;

-- ============================================================
--  						FUNCIONES
-- ============================================================

-- Prueba Función 1: Calcula el precio final de un ítem según id_promocion
SELECT `fn_precio_con_promocion`(5000,1);
-- Prueba Función 2: Total de un pedido (suma de sus detalles aplicando promos)
SELECT `fn_total_pedido`(31);

-- ============================================================
--  					STORED PROCEDURES
-- ============================================================

-- Prueba SP 1: Registrar pedido básico (crea Pedido y dirección)
SELECT * from pedido;
CALL sp_registrar_pedido_basico(4,2,'Delivery',5,'Bustos 720',31);
SELECT * FROM pedido
WHERE id_pedido = 31;
-- Prueba SP 2: Registrar detalle_pedido (crea detalle_pedido segun id_pedido)
CALL sp_agregar_detalles_pedido(31,4,2,1);
SELECT * FROM detalle_pedido;
-- Prueba SP 3: Actualiza estado del pedido
Select * from PEDIDO;
CALL sp_actualizar_estado_pedido(11,'En Viaje');
-- Prueba SP 4: Reporte de ventas por rango de fechas
Select * from pedido;
CALL sp_reporte_ventas('2025-07-01','2025-08-2');
CALL sp_reporte_ventas('2025-07-01','2025-09-30'); -- CON EL NUEVO INGRESO DE PEDIDO

-- ============================================================
--  						TRIGGERS
-- ============================================================

-- Prueba TRIGGER 1: Antes de INSERT en Pedido: regla de repartidor según tipo_entrega
INSERT INTO restaurantedelivery.pedido (id_cliente,id_sucursal,id_repartidor,fecha_hora,tipo_entrega, estado) 
VALUES (4, 3, 1,NOW(),'Delivery','Preparando');
-- Prueba TRIGGER 2: Descontar stock al insertar detalle
SELECT * FROM producto
WHERE id_producto = 13;
INSERT INTO `restaurantedelivery`.`detalle_pedido` (id_pedido,id_producto,cantidad,precio_unit,id_promocion)
VALUES (31,13,70,1500,1);








