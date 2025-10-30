-- Stored procedure para generar automaticamente un resultado con valores
-- aleatorios de una accion comercial

CREATE OR REPLACE PROCEDURE generar_resultado (
    p_id_accion_comercial INT
)

LANGUAGE plpgsql

AS $$

DECLARE
    v_titulo_resultado TEXT;
    v_presupuesto INT;
    v_exito_esperado FLOAT;
    v_id_producto INT;
    v_nombre_accion VARCHAR(150);
    v_clientes_alcanzados INT;
    v_rentabilidad INT;
    v_coeficiente_exito NUMERIC;
    v_inversion_recuperada BOOLEAN;
    v_id_resultado INT;
    v_tamano_segmento INT;
BEGIN
    -- Obtener datos de la accion comercial
    SELECT 
        presupuesto, 
        exito_esperado, 
        id_producto_bancario,
        nombre_accion
    INTO 
        v_presupuesto, 
        v_exito_esperado, 
        v_id_producto,
        v_nombre_accion
    FROM accion_comercial
    WHERE id_accion_comercial = p_id_accion_comercial;

    IF v_presupuesto IS NULL THEN
        RAISE EXCEPTION 'No existe una acción comercial con id %', p_id_accion_comercial;
    END IF;

    SELECT s.tamano_segmento
    INTO v_tamano_segmento
    FROM segmento s
    JOIN segmento_accion sa ON s.id_segmento = sa.id_segmento
    WHERE sa.id_accion_comercial = p_id_accion_comercial
    LIMIT 1;

    IF v_tamano_segmento IS NULL THEN
        RAISE NOTICE 'La acción % no tiene segmento asociado', p_id_accion_comercial;
        v_tamano_segmento := 0;
    END IF;

    v_titulo_resultado := 'Resultado automático para: ' || v_nombre_accion;

    v_clientes_alcanzados := FLOOR(RANDOM() * v_tamano_segmento) + 1; -- Entre 1 y tamano_segmento

    v_rentabilidad := FLOOR(RANDOM() * 12000001) - 2000000; -- Numero al azar entre -$2.000.000 y $12.000.000 para simular rentabilidad
    
    IF v_clientes_alcanzados > 0 THEN
        v_coeficiente_exito := ROUND(v_rentabilidad::NUMERIC / v_clientes_alcanzados, 2)::FLOAT;    
    ELSE
        v_coeficiente_exito := 0;
    END IF;
    
    -- Verificar si se recuperó la inversión o no.
    IF v_rentabilidad >= v_presupuesto THEN
        v_inversion_recuperada := TRUE;
    ELSE
        v_inversion_recuperada := FALSE;
    END IF;

    -- Generar nuevo ID de resultado, se busca el ID máximo y se le agrega 1
    SELECT COALESCE(MAX(id_resultado), 500) + 1 INTO v_id_resultado FROM resultado;

    -- Insertar nuevo resultado
        INSERT INTO resultado (
        id_resultado,
        titulo_resultado,
        clientes_alcanzados,
        rentabilidad,
        coeficiente_exito,
        inversion_recuperada,
        id_accion_comercial
    ) VALUES (
        v_id_resultado,
        v_titulo_resultado,
        v_clientes_alcanzados,
        v_rentabilidad,
        v_coeficiente_exito,
        v_inversion_recuperada,
        p_id_accion_comercial
    );

    RAISE NOTICE 'Resultado % generado para acción % (%): clientes=%, tamano_segmento=%, rentabilidad=%, coeficiente=%, inversión recuperada=%',
        v_id_resultado, p_id_accion_comercial, v_nombre_accion, 
        v_clientes_alcanzados, v_tamano_segmento, v_rentabilidad, v_coeficiente_exito, v_inversion_recuperada;

END;
$$;