-- 1. ¿Qué clientes compraron un crédito hipotecario?

SELECT DISTINCT cl.nombre_cliente, cl.apellido_paterno, cl.apellido_materno, pr.nombre_producto
FROM cliente cl
JOIN cliente_segmento cs ON cl.rut = cs.rut
JOIN segmento s ON cs.id_segmento = s.id_segmento
JOIN segmento_accion sa ON s.id_segmento = sa.id_segmento
JOIN accion_comercial ac ON sa.id_accion_comercial = ac.id_accion_comercial
JOIN producto_bancario pr ON ac.id_producto_bancario = pr.id_producto_bancario
WHERE pr.nombre_producto = 'Crédito Hipotecario';

-- 2. ¿Cuál fue el promedio de acciones comerciales con un resultado exitoso?

SELECT 
    AVG(r.coeficiente_exito) AS promedio_exito
FROM resultado r
WHERE r.coeficiente_exito > 0;

-- 3. ¿Qué segmentos son contactados a través de e-mail? *

SELECT DISTINCT s.nombre_segmento
FROM segmento s
JOIN segmento_accion sa ON s.id_segmento = sa.id_segmento
JOIN accion_comercial ac ON sa.id_accion_comercial = ac.id_accion_comercial
JOIN accion_canal aca ON ac.id_accion_comercial = aca.id_accion_comercial
JOIN canal_difusion c ON aca.id_canal_difusion = c.id_canal_difusion
WHERE c.nombre_canal ILIKE 'Email Marketing';

-- 4. ¿Qué segmentos tienen mejores resultados cuando se les ofrece créditos de consumo? *

SELECT 
    s.nombre_segmento,
    AVG(r.coeficiente_exito) AS promedio_exito
FROM segmento s
JOIN segmento_accion sa ON s.id_segmento = sa.id_segmento
JOIN accion_comercial ac ON sa.id_accion_comercial = ac.id_accion_comercial
JOIN producto_bancario p ON ac.id_producto_bancario = p.id_producto_bancario
JOIN resultado r ON ac.id_accion_comercial = r.id_accion_comercial
WHERE p.nombre_producto ILIKE 'Cuenta Joven Digital'
GROUP BY s.nombre_segmento
ORDER BY promedio_exito DESC;

-- 5. Listar acciones comerciales fallidas que hayan terminado el 1/1/2024

SELECT ac.nombre_accion, ac.objetivo, ac.fecha_termino
FROM accion_comercial ac
JOIN resultado r ON ac.id_accion_comercial = r.id_accion_comercial
WHERE r.coeficiente_exito <= 0 
  AND ac.fecha_termino >= '2024-01-01';

-- 6. ¿Qué clientes, con un sueldo mayor a 4 millones son contactados a través de propagandas de SMS?

SELECT DISTINCT c.nombre_cliente, c.apellido_paterno, c.apellido_materno, c.rut, c.ingresos_mensuales
FROM cliente c
JOIN cliente_segmento cs ON c.rut = cs.rut
JOIN segmento s ON cs.id_segmento = s.id_segmento
JOIN segmento_accion sa ON s.id_segmento = sa.id_segmento
JOIN accion_comercial ac ON sa.id_accion_comercial = ac.id_accion_comercial
JOIN accion_canal aca ON ac.id_accion_comercial = aca.id_accion_comercial
JOIN canal_difusion cd ON aca.id_canal_difusion = cd.id_canal_difusion
WHERE c.ingresos_mensuales > 4000000
  AND cd.nombre_canal ILIKE 'SMS';

-- 7. ¿Qué canales de difusión son los que más promocionan los créditos de consumo?

SELECT 
    cd.nombre_canal AS canal,
    COUNT(*) AS cantidad_promociones
FROM canal_difusion cd
JOIN accion_canal aca ON cd.id_canal_difusion = aca.id_canal_difusion
JOIN accion_comercial ac ON aca.id_accion_comercial = ac.id_accion_comercial
JOIN producto_bancario p ON ac.id_producto_bancario = p.id_producto_bancario
WHERE p.tipo ILIKE 'Crédito'
GROUP BY cd.nombre_canal
ORDER BY cantidad_promociones DESC;