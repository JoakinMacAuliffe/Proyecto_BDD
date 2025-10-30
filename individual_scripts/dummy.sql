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