 -- USE proyecto_logistica_mexico;
 /* =============================================================
   PROYECTO: ANALÍTICA LOGÍSTICA MÉXICO-GLOBAL (VERSIÓN SENIOR)
   ============================================================= */

-- 1. Geografía (Para Mapas en Power BI)
CREATE TABLE dim_ubicaciones (
    id_ubicacion INT PRIMARY KEY,
    ciudad VARCHAR(100) NOT NULL,
    estado VARCHAR(100) NOT NULL,
    region VARCHAR(50),
    codigo_postal VARCHAR(10) -- Dato real para geolocalización precisa
);

-- 2. Proveedores (Para KPI de Riesgo)
CREATE TABLE dim_proveedores (
    id_proveedor INT PRIMARY KEY,
    nombre_empresa VARCHAR(100) NOT NULL,
    pais_origen VARCHAR(50) NOT NULL,
    moneda_compra VARCHAR(3),
    dias_credito INT, -- ¿Cuánto tiempo nos dan para pagar? 
    nivel_servicio VARCHAR(20) CHECK (nivel_servicio IN ('Premium', 'Estandar', 'Critico'))
);

-- 3. Productos (Para Análisis de Margen)
CREATE TABLE dim_productos (
    id_producto INT PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    id_proveedor INT,
    categoria VARCHAR(50),
    costo_unitario_usd DECIMAL(10,2), -- Costo de importación
    precio_venta_mxn DECIMAL(10,2),  -- Precio en México
    peso_kg DECIMAL(10,2),           -- calcular logística
    FOREIGN KEY (id_proveedor) REFERENCES dim_proveedores(id_proveedor)
);

-- 4. Ventas y Logística (Tabla de Hechos Central)
CREATE TABLE fact_ventas (
    id_venta INT PRIMARY KEY,
    id_producto INT,
    id_ubicacion INT,
    fecha_pedido DATE NOT NULL,
    fecha_limite_entrega DATE,      -- Para medir si llegamos tarde
    fecha_entrega_real DATE,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    costo_envio_mxn DECIMAL(10,2),
    estado_pedido VARCHAR(20) CHECK (estado_pedido IN ('Entregado', 'En Transito', 'Cancelado', 'Devuelto')),
    FOREIGN KEY (id_producto) REFERENCES dim_productos(id_producto),
    FOREIGN KEY (id_ubicacion) REFERENCES dim_ubicaciones(id_ubicacion)
);
