-- poblar_bd_ddl_compat.sql
-- Script de población compatible con el DDL provisto (IDs controlados manualmente)

-- LIMPIAR TABLAS (vaciar contenido)
TRUNCATE TABLE resultado, telefono_cliente, cliente_segmento, segmento_accion,
accion_canal, cliente, canal_difusion, accion_comercial, segmento, producto_bancario RESTART IDENTITY CASCADE;

-- -----------------------
-- PRODUCTOS BANCARIOS (IDs fijos)
-- -----------------------
INSERT INTO producto_bancario (id_producto_bancario, nombre_producto, tipo, fecha_lanzamiento) VALUES
(1, 'Cuenta Corriente', 'Cuenta', '2010-01-01'),
(2, 'Tarjeta de Crédito', 'Tarjeta', '2012-06-15'),
(3, 'Crédito Hipotecario', 'Crédito', '2015-09-10'),
(4, 'Crédito de Consumo', 'Crédito', '2017-03-25'),
(5, 'Inversión a Plazo', 'Inversión', '2018-11-30');

-- -----------------------
-- CANALES DE DIFUSIÓN (IDs fijos)
-- -----------------------
INSERT INTO canal_difusion (id_canal_difusion, nombre_canal, tipo) VALUES
(1, 'Email Marketing', 'Digital'),
(2, 'Llamada Telefónica', 'Directo'),
(3, 'SMS', 'Digital'),
(4, 'Sucursal', 'Presencial'),
(5, 'Redes Sociales', 'Digital'),
(6, 'Publicidad en Línea', 'Digital');

-- -----------------------
-- SEGMENTOS (IDs fijos)
-- -----------------------
INSERT INTO segmento (id_segmento, tamano_segmento, nombre_segmento, criterios) VALUES
(1, 0, 'Estudiantes', 'Clientes menores de 25 años o en etapa universitaria'),
(2, 0, 'Profesionales', 'Clientes entre 25 y 50 años, con ingresos estables'),
(3, 0, 'Emprendedores', 'Propietarios de pequeñas empresas o freelancers'),
(4, 0, 'Deportistas', 'Clientes con estilo de vida activo y gasto en deporte'),
(5, 0, 'Jubilados', 'Clientes mayores de 60 años con pensiones'),
(6, 0, 'Familias Jóvenes', 'Clientes entre 25 y 40 años con hijos pequeños'),
(7, 0, 'Inversionistas', 'Clientes interesados en productos de ahorro e inversión');

-- -----------------------
-- ACCIONES COMERCIALES (IDs 1..100) y asociaciones a canales/segmentos
-- -----------------------
DO $$
DECLARE
    i INT;
    v_producto INT;
    v_nombre TEXT;
    v_objetivo TEXT;
    v_presupuesto INT;
    v_exito_esp FLOAT;
    v_fecha_ini DATE;
    v_fecha_fin DATE;
    v_canal INT;
    v_segmento INT;
BEGIN
    FOR i IN 1..100 LOOP
        -- asignar producto de forma cíclica 1..5
        v_producto := ((i - 1) % 5) + 1;
        v_nombre := 'Campaña ' || i;
        v_objetivo := CASE v_producto
                        WHEN 1 THEN 'Captar nuevas cuentas corrientes'
                        WHEN 2 THEN 'Fomentar uso de tarjetas de crédito'
                        WHEN 3 THEN 'Aumentar colocación de créditos hipotecarios'
                        WHEN 4 THEN 'Impulsar créditos de consumo'
                        WHEN 5 THEN 'Promover inversiones a plazo'
                      END;
        -- presupuesto entre 1.000.000 y 9.000.000
        v_presupuesto := (FLOOR(RANDOM()*8000000) + 1000000)::INT;
        -- exito_esperado entre 0.50 y 1.00 (2 decimales)
        v_exito_esp := ROUND((RANDOM()*0.5 + 0.5)::numeric, 2)::FLOAT;
        v_fecha_ini := DATE '2024-01-01' + (FLOOR(RANDOM()*365))::INT;
        v_fecha_fin := v_fecha_ini + (FLOOR(RANDOM()*180) + 7)::INT;

        -- Insertar acción con id explícito = i
        INSERT INTO accion_comercial (
            id_accion_comercial, nombre_accion, objetivo, presupuesto, exito_esperado, fecha_inicio, fecha_termino, id_producto_bancario
        ) VALUES (
            i, v_nombre, v_objetivo, v_presupuesto, v_exito_esp, v_fecha_ini, v_fecha_fin, v_producto
        );

        -- asociar 1-3 canales aleatorios (evitar duplicados con EXCEPTION)
        FOR j IN 1..(FLOOR(RANDOM()*3)+1) LOOP
            v_canal := FLOOR(RANDOM()*6)+1;
            BEGIN
                INSERT INTO accion_canal (id_accion_comercial, id_canal_difusion)
                VALUES (i, v_canal);
            EXCEPTION WHEN unique_violation THEN NULL;
            END;
        END LOOP;

        -- asociar 1-3 segmentos aleatorios (evitar duplicados)
        FOR j IN 1..(FLOOR(RANDOM()*3)+1) LOOP
            v_segmento := FLOOR(RANDOM()*7)+1;
            BEGIN
                INSERT INTO segmento_accion (id_segmento, id_accion_comercial)
                VALUES (v_segmento, i);
            EXCEPTION WHEN unique_violation THEN NULL;
            END;
        END LOOP;
    END LOOP;
END $$;

-- -----------------------
-- CLIENTES (500) + cliente_segmento + telefono_cliente
-- -----------------------
DO $$
DECLARE
    i INT;
    v_rut TEXT;
    v_nombre TEXT;
    v_ap_pat TEXT;
    v_ap_mat TEXT;
    v_fecha_nac DATE;
    v_ingresos INT;
    v_n_segmentos INT;
    v_segmento INT;
    v_n_telefonos INT;
    v_tel TEXT;
    nombres TEXT[] := ARRAY['Juan','María','Pedro','Ana','Luis','Camila','Javier','Sofía','Diego','Valentina','Carlos','Fernanda','Andrés','Paula','Matías','Constanza'];
    apellidos TEXT[] := ARRAY['González','Muñoz','Rojas','Díaz','Pérez','Soto','Contreras','Silva','López','Martínez','Morales','Gutiérrez','Herrera','Torres','Araya','Pinto'];
BEGIN
    FOR i IN 1..500 LOOP
        -- generar RUT simulado y garantizar unicidad con TRY/CATCH
        v_rut := LPAD((1000000 + FLOOR(RANDOM()*29000000))::TEXT, 8, '0') || '-' || (FLOOR(RANDOM()*9))::TEXT;

        v_nombre := nombres[FLOOR(RANDOM()*array_length(nombres,1))+1];
        v_ap_pat := apellidos[FLOOR(RANDOM()*array_length(apellidos,1))+1];
        v_ap_mat := apellidos[FLOOR(RANDOM()*array_length(apellidos,1))+1];
        v_fecha_nac := DATE '1945-01-01' + (FLOOR(RANDOM()*29200))::INT; -- 1945..2025
        v_ingresos := (FLOOR(RANDOM()*4600000) + 400000)::INT;

        BEGIN
            INSERT INTO cliente (rut, nombre_cliente, fecha_nacimiento, ingresos_mensuales, apellido_paterno, apellido_materno)
            VALUES (v_rut, v_nombre, v_fecha_nac, v_ingresos, v_ap_pat, v_ap_mat);
        EXCEPTION WHEN unique_violation THEN
            -- si el rut ya existe, generar otro y reintentar (simple estrategia)
            v_rut := LPAD((1000000 + FLOOR(RANDOM()*29000000))::TEXT, 8, '0') || '-' || (FLOOR(RANDOM()*9))::TEXT;
            BEGIN
                INSERT INTO cliente (rut, nombre_cliente, fecha_nacimiento, ingresos_mensuales, apellido_paterno, apellido_materno)
                VALUES (v_rut, v_nombre, v_fecha_nac, v_ingresos, v_ap_pat, v_ap_mat);
            EXCEPTION WHEN unique_violation THEN
                NULL; -- si vuelve a fallar, saltar este cliente
            END;
        END;

        -- asignar 1-3 segmentos
        v_n_segmentos := FLOOR(RANDOM()*3)+1;
        FOR j IN 1..v_n_segmentos LOOP
            v_segmento := FLOOR(RANDOM()*7)+1;
            BEGIN
                INSERT INTO cliente_segmento (id_segmento, rut)
                VALUES (v_segmento, v_rut);
            EXCEPTION WHEN unique_violation THEN NULL;
            END;
        END LOOP;

        -- asignar 1-3 teléfonos
        v_n_telefonos := FLOOR(RANDOM()*3)+1;
        FOR j IN 1..v_n_telefonos LOOP
            IF RANDOM() < 0.75 THEN
                v_tel := '+56 9 ' || (FLOOR(RANDOM()*90000000)+10000000)::TEXT;
            ELSE
                v_tel := '+56 2 ' || (FLOOR(RANDOM()*8000000)+2000000)::TEXT;
            END IF;
            BEGIN
                INSERT INTO telefono_cliente (rut, telefono)
                VALUES (v_rut, v_tel);
            EXCEPTION WHEN unique_violation THEN NULL;
            END;
        END LOOP;
    END LOOP;
END $$;

-- -----------------------
-- RESULTADOS (uno por cada acción comercial existente)
-- -----------------------
DO $$
DECLARE
    rec RECORD;
    v_clientes_alcanzados INT;
    v_rentabilidad INT;
    v_coef_exito FLOAT;
    v_inversion_recuperada BOOLEAN;
    v_id_resultado INT := 0;
BEGIN
    FOR rec IN SELECT id_accion_comercial, presupuesto FROM accion_comercial ORDER BY id_accion_comercial LOOP
        v_id_resultado := v_id_resultado + 1;

        v_clientes_alcanzados := FLOOR(RANDOM()*4000 + 100); -- 100..4100

        -- Generar rentabilidad de forma que a veces supere el presupuesto y a veces no
        IF RANDOM() < 0.35 THEN
            -- buena campaña: rentabilidad entre presupuesto y 3x presupuesto
            v_rentabilidad := (FLOOR(rec.presupuesto * (1 + RANDOM()*2)))::INT;
        ELSE
            -- resultado moderado o pérdida: entre -1.5*presupuesto y presupuesto*0.9
            v_rentabilidad := (FLOOR(rec.presupuesto * (-1.5 + RANDOM()*2.4)))::INT;
        END IF;

        -- asegurar que v_clientes_alcanzados != 0
        IF v_clientes_alcanzados = 0 THEN
            v_clientes_alcanzados := 1;
        END IF;

        v_coef_exito := ROUND((v_rentabilidad::NUMERIC / v_clientes_alcanzados)::numeric, 2)::FLOAT;

        -- inversion recuperada solo si rentabilidad >= presupuesto (regla del trigger)
        v_inversion_recuperada := (v_rentabilidad >= rec.presupuesto);

        -- Insertar con id_resultado único
        INSERT INTO resultado (
            id_resultado, titulo_resultado, clientes_alcanzados, rentabilidad, coeficiente_exito, id_accion_comercial, inversion_recuperada
        ) VALUES (
            v_id_resultado,
            'Resultado acción ' || rec.id_accion_comercial,
            v_clientes_alcanzados,
            v_rentabilidad,
            v_coef_exito,
            rec.id_accion_comercial,
            v_inversion_recuperada
        );
    END LOOP;
END $$;

-- -----------------------
-- Actualizar tamano_segmento (conteo real)
-- -----------------------
UPDATE segmento s
SET tamano_segmento = COALESCE((
    SELECT COUNT(*) FROM cliente_segmento cs WHERE cs.id_segmento = s.id_segmento
), 0);

-- FIN
