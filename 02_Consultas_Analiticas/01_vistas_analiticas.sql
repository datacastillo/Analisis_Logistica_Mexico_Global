-- USE proyecto_logistica_mexico;

CREATE OR REPLACE VIEW v_master_ventas AS
SELECT 
    v.id_venta,
    v.fecha_pedido,
    p.nombre_producto,
    p.categoria,
    u.ciudad,
    u.estado,
    u.region,
    v.cantidad,
    v.costo_envio_mxn,
    -- Cálculo de Ingresos (Cantidad * Precio Venta)
    (v.cantidad * p.precio_venta_mxn) AS ingresos_mxn,
    -- Cálculo de Utilidad (Ingresos - (Costos USD * TC de 18.5))
    (v.cantidad * p.precio_venta_mxn) - (v.cantidad * (p.costo_unitario_usd * 18.5)) AS utilidad_mxn,
    -- KPI de Logística: 1 si llegó tarde, 0 si a tiempo
    IF(v.fecha_entrega_real > v.fecha_limite_entrega, 1, 0) AS flag_retraso,
    v.estado_pedido
FROM fact_ventas v
JOIN dim_productos p ON v.id_producto = p.id_producto
JOIN dim_ubicaciones u ON v.id_ubicacion = u.id_ubicacion;


SELECT * FROM v_master_ventas LIMIT 10;
