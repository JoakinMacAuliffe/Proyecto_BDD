-- Trigger que valida que los datos de los resultados tengan sentido

CREATE OR REPLACE FUNCTION validar_resultado()
RETURNS TRIGGER AS $$
DECLARE
    v_presupuesto INT;
BEGIN
    SELECT presupuesto INTO v_presupuesto
    FROM accion_comercial
    WHERE id_accion_comercial = NEW.id_accion_comercial;

    -- Validar valor de inversion_recuperada
    IF NEW.inversion_recuperada = TRUE AND NEW.rentabilidad < v_presupuesto THEN
        RAISE EXCEPTION 'No puede marcarse como inversión recuperada si la rentabilidad (%) es menor al presupuesto (%)',
        NEW.rentabilidad, v_presupuesto;
    END IF;

    -- Validar coeficiente de exito
    IF NEW.coeficiente_exito < 0 THEN
        RAISE NOTICE 'Coeficiente de éxito negativo detectado (Pérdida económica).';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validar_resultado
BEFORE INSERT OR UPDATE ON resultado
FOR EACH ROW
EXECUTE FUNCTION validar_resultado();