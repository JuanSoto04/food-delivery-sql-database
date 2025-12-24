
-- ============================================================
-- 1) VISTAS
-- ============================================================

-- Vista 1: Pedidos pendientes y preperando (no entregados)

CREATE OR REPLACE VIEW vw_pedidos_pendiente_entrega AS 
SELECT 
	p.id_pedido,
	c.nombre_cliente AS `Cliente`,
	p.tipo_entrega as `Tipo de entrega`,
	p.estado,
	p.fecha_hora AS `Fecha y hora`,
	de.direccion,
	s.nombre_sucursal AS `Nombre de sucursal`,
	r.nombre_repartidor AS `Repartidor`
FROM pedido p
JOIN cliente c USING (id_cliente)
JOIN sucursal s USING (id_sucursal)
LEFT JOIN repartidor r USING (id_repartidor)
LEFT JOIN direccion_entrega de USING(id_pedido)
WHERE p.estado IN ('Preparando','En Viaje');

-- Vista 2: Ventas por sucursal
CREATE OR REPLACE VIEW vw_ventas_por_sucursal AS 
SELECT 
	s.id_sucursal,
	s.nombre_sucursal AS `Sucursal`,
	COUNT(DISTINCT p.id_pedido) AS `Cantidad de Pedidos`,
	ROUND(SUM(dp.cantidad * dp.precio_unit * (1 - pr.descuento/100)),2) AS `Monto bruto aprox.`,
	ROUND(SUM(CASE WHEN pa.estado='Realizado' THEN dp.cantidad * dp.precio_unit * (1 - pr.descuento/100) ELSE 0 END),2) AS `Monto cobrado aprox.`
FROM sucursal s
JOIN pedido p USING (id_sucursal)
JOIN detalle_pedido dp USING (id_pedido)
LEFT JOIN promocion pr USING (id_promocion)
LEFT JOIN pago pa USING(id_pedido)
GROUP BY s.id_sucursal,s.nombre_sucursal;


-- Vista 3: Stock actual de productos

CREATE OR REPLACE VIEW vw_stock_productos AS
SELECT
  pr.id_producto,
  pr.nombre_producto,
  pr.precio,
  pr.cantidad AS `Stock actual`
FROM Producto pr;


-- Vista 4: Cantidad de promociones usadas
CREATE OR REPLACE VIEW vw_promociones_uso AS
SELECT
  pr.id_promocion,
  pr.descripcion,
  pr.descuento,
  COUNT(*) AS `Veces Usada`
FROM Detalle_Pedido dp
JOIN Promocion pr ON pr.id_promocion = dp.id_promocion
GROUP BY pr.id_promocion, pr.descripcion, pr.descuento
ORDER BY `Veces Usada` DESC;


-- Vista 5: Productos mas vendidos
CREATE OR REPLACE VIEW vw_productos_top AS
SELECT
	p.id_producto,
	p.nombre_producto,
    SUM(dp.cantidad) AS `Vendidos`,
    SUM(dp.cantidad * dp.precio_unit) AS `Monto recaudado`
FROM producto p
JOIN detalle_pedido dp USING(id_producto)
GROUP BY p.id_producto,p.nombre_producto
ORDER BY `Vendidos` DESC
LIMIT 6;




-- ============================================================
-- 2) FUNCIONES
-- ============================================================

DELIMITER $$

-- Función 1: Calcula el precio final de un ítem según id_promocion
CREATE FUNCTION `fn_precio_con_promocion` (precio DECIMAL(10,2), id_prom INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE des DECIMAL(5,2);
  IF id_prom IS NULL THEN
    SET id_prom = 1;
  END IF;
  SELECT descuento INTO des FROM Promocion WHERE id_promocion = id_prom;
  RETURN ROUND(precio * (1 - (des/100)), 2);
END$$

DELIMITER ;

-- Funcion 2: Total de un pedido (suma de sus detalles aplicando promos)

DELIMITER $$

CREATE FUNCTION `fn_total_pedido` (p_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE tot DECIMAL(10,2);
  SELECT SUM(dp.cantidad * fn_precio_con_promocion(dp.precio_unit, dp.id_promocion))
    INTO tot
  FROM detalle_pedido dp
  WHERE dp.id_pedido = p_id;
  RETURN tot;
END$$

DELIMITER ;

-- ============================================================
-- 3) STORED PROCEDURES
-- ============================================================

DELIMITER $$

-- SP 1: Registrar pedido básico (crea Pedido y dirección)
CREATE PROCEDURE sp_registrar_pedido_basico(
  IN  p_id_cliente INT,
  IN  p_id_sucursal INT,
  IN  p_tipo_entrega ENUM('Delivery','Local'),
  IN  p_id_repartidor INT,
  IN  p_direccion VARCHAR(150),
  OUT p_id_pedido INT
)
BEGIN
  -- Validación: si es Local, forzar repartidor NULL
  IF p_tipo_entrega = 'Local' THEN
    SET p_id_repartidor = NULL;
  END IF;

  INSERT INTO Pedido (id_cliente, id_sucursal, id_repartidor, fecha_hora, tipo_entrega, estado)
  VALUES (p_id_cliente, p_id_sucursal, p_id_repartidor, NOW(), p_tipo_entrega, 'Preparando');

  SET p_id_pedido = LAST_INSERT_ID();

  -- Si es Delivery y vino dirección se guarda
  IF p_direccion IS NOT NULL AND LENGTH(p_direccion) > 0 THEN -- Por si solo se ingresa ""
    INSERT INTO Direccion_Entrega (id_pedido, direccion) VALUES (p_id_pedido, p_direccion);
  END IF;
END$$

DELIMITER ;


-- SP 2: Registrar detalle_pedido (crea detalle_pedido segun id_pedido)

DELIMITER $$

CREATE PROCEDURE sp_agregar_detalles_pedido(
    IN p_id_pedido INT,
    IN p_id_producto INT,
    IN p_cantidad INT,
    IN p_promocion INT
)
BEGIN
    DECLARE v_precio DECIMAL(10,2);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION -- Handler: si algo falla -> ROLLBACK y reenvía el mensaje específico 
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION; -- Comenzamos la transaccion. Si sale bien -> COMMIT || Si sale mal -> ROLLBACK

    -- Validar que el pedido exista y esté en estado válido
    IF NOT EXISTS (SELECT 1 FROM Pedido WHERE id_pedido = p_id_pedido AND estado = 'Preparando') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Pedido no válido o no encontrado';
    END IF;

    -- Validar que el producto exista y obtener el precio
    SELECT precio INTO v_precio 
    FROM Producto 
    WHERE id_producto = p_id_producto;
    
    IF v_precio IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Producto no encontrado';
    END IF;

    -- Validar cantidad
    IF p_cantidad <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cantidad debe ser mayor a 0';
    END IF;
    
    -- Validar promocion
    IF p_promocion NOT IN (1, 2, 3, 4) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ID de promocion invalido';
    END IF;

    -- Insertar detalle_pedido usando la variable v_precio
    INSERT INTO Detalle_Pedido (id_pedido, id_producto, cantidad, precio_unit, id_promocion)
    VALUES (p_id_pedido, p_id_producto, p_cantidad, v_precio, p_promocion);

    COMMIT;
END$$

DELIMITER ;


-- SP 3: Actualiza estado del pedido

DELIMITER $$

CREATE PROCEDURE sp_actualizar_estado_pedido(
  IN p_id_pedido INT,
  IN p_nuevo_estado ENUM('Preparando','Entregado','En Viaje','Recibido')
)
BEGIN
  UPDATE Pedido
  SET estado = p_nuevo_estado
  WHERE id_pedido = p_id_pedido;
END$$

DELIMITER ;

-- SP 4: Reporte de ventas por rango de fechas

DELIMITER $$

CREATE PROCEDURE sp_reporte_ventas(
  IN p_desde DATETIME,
  IN p_hasta DATETIME
)
BEGIN
  SELECT
    p.id_sucursal,
    s.nombre_sucursal AS `Sucursal`,
    COUNT(DISTINCT p.id_pedido) AS `Pedidos`,
    SUM(dp.cantidad * fn_precio_con_promocion(dp.precio_unit, dp.id_promocion)) AS `Total aproximado`
  FROM Pedido p
  JOIN Sucursal s USING(id_sucursal)
  JOIN Detalle_Pedido dp USING(id_pedido)
  WHERE p.fecha_hora BETWEEN p_desde AND p_hasta
  GROUP BY p.id_sucursal, s.nombre_sucursal
  ORDER BY `Total aproximado` DESC;
END$$


DELIMITER ;

-- ============================================================
-- 4) TRIGGERS
-- ============================================================

-- TRIGGER 1: Antes de INSERT en Pedido: regla de repartidor según tipo_entrega

DELIMITER $$

CREATE TRIGGER tr_validar_repartidor_pedidos
BEFORE INSERT ON Pedido
FOR EACH ROW
BEGIN
  IF NEW.tipo_entrega = 'Local' THEN
    SET NEW.id_repartidor = NULL;
  ELSE -- "Delivery"
    -- validar que exista repartidor y pertenezca a la misma sucursal
    IF NEW.id_repartidor IS NULL THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Delivery requiere id_repartidor';
    END IF;
    IF (SELECT r.id_sucursal FROM Repartidor r WHERE r.id_repartidor = NEW.id_repartidor) <> NEW.id_sucursal THEN -- Si el id_repartidor es de una sucursal distinta a la ingresada
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El repartidor no pertenece a la sucursal del pedido';
    END IF;
  END IF;
  
END$$

DELIMITER ;

-- TRIGGER 2: Descontar stock al insertar detalle

DELIMITER $$

CREATE TRIGGER tr_check_descuento_stock
AFTER INSERT ON detalle_pedido
FOR EACH ROW
BEGIN
    UPDATE Producto
    SET cantidad = cantidad - NEW.cantidad
    WHERE id_producto = NEW.id_producto;
    
    -- Validación de stock negativo
    IF (SELECT cantidad FROM Producto WHERE id_producto = NEW.id_producto) < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente para el producto';
    END IF;
END$$

DELIMITER ;

