SELECT cl.nombre_cliente
FROM cliente cl
JOIN cliente_segmento cs ON cl.rut = cs.rut
JOIN segmento s ON cs.id_segmento = s.id_segmento
JOIN segmento_accion sa ON s.id_segmento = sa.id_segmento
JOIN accion_comercial ac ON sa.id_accion_comercial = ac.id_accion_comercial
JOIN producto_bancario pr ON ac.id_producto_bancario = pr.id_producto_bancario
WHERE pr.nombre_producto = 'Credito Hipotecario Flexible'
GROUP BY cl.nombre_cliente;

SELECT 
    AVG(r.coeficiente_exito) AS promedio_exito
FROM resultado r
WHERE r.titulo_resultado ILIKE '%exitoso%';

SELECT DISTINCT s.nombre_segmento
FROM segmento s
JOIN segmento_accion sa ON s.id_segmento = sa.id_segmento
JOIN accion_comercial ac ON sa.id_accion_comercial = ac.id_accion_comercial
JOIN accion_canal aca ON ac.id_accion_comercial = aca.id_accion_comercial
JOIN canal_difusion c ON aca.id_canal_difusion = c.id_canal_difusion
WHERE c.nombre_canal ILIKE 'Email Marketing';

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

SELECT ac.nombre_accion, ac.objetivo, ac.fecha_termino
FROM accion_comercial ac
JOIN resultado r ON ac.id_accion_comercial = r.id_accion_comercial
WHERE r.titulo_resultado ILIKE '%fallido%' 
  AND ac.fecha_termino >= '2024-01-01';

SELECT DISTINCT c.nombre_cliente, c.rut, c.ingresos_mensuales
FROM cliente c
JOIN cliente_segmento cs ON c.rut = cs.rut
JOIN segmento s ON cs.id_segmento = s.id_segmento
JOIN segmento_accion sa ON s.id_segmento = sa.id_segmento
JOIN accion_comercial ac ON sa.id_accion_comercial = ac.id_accion_comercial
JOIN accion_canal aca ON ac.id_accion_comercial = aca.id_accion_comercial
JOIN canal_difusion cd ON aca.id_canal_difusion = cd.id_canal_difusion
WHERE c.ingresos_mensuales > 4000000
  AND cd.nombre_canal ILIKE 'instagram';

SELECT 
    cd.nombre_canal AS canal,
    COUNT(*) AS cantidad_promociones
FROM canal_difusion cd
JOIN accion_canal aca ON cd.id_canal_difusion = aca.id_canal_difusion
JOIN accion_comercial ac ON aca.id_accion_comercial = ac.id_accion_comercial
JOIN producto_bancario p ON ac.id_producto_bancario = p.id_producto_bancario
WHERE p.tipo ILIKE 'crédito de consumo'
GROUP BY cd.nombre_canal
ORDER BY cantidad_promociones DESC;