SELECT 
    s.nombre_segmento,
    SUM(r.rentabilidad) AS rentabilidad_total
FROM segmento s
JOIN segmento_accion sa ON s.id_segmento = sa.id_segmento
JOIN resultado r ON sa.id_accion_comercial = r.id_accion_comercial
GROUP BY s.nombre_segmento
ORDER BY rentabilidad_total DESC;
