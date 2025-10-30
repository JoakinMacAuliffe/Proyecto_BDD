-- DML

INSERT INTO producto_bancario (id_producto_bancario, nombre_producto, tipo, fecha_lanzamiento) VALUES
(201, 'Credito Hipotecario Flexible', 'Hipoteca', '2023-01-15'),
(202, 'Cuenta Joven Digital', 'Cuenta Corriente', '2024-03-01'),
(203, 'Fondo Mutuo Agresivo', 'Inversion', '2022-06-20');

INSERT INTO segmento (id_segmento, tamano_segmento, nombre_segmento, criterios) VALUES
(101, 50000, 'Alto Valor', 'Ingresos mensuales > $2.000.000 y saldo promedio alto.'),
(102, 35000, 'Joven Universitario', 'Edad entre 18 y 25, con estudios superiores.'),
(103, 70000, 'Ahorrador Conservador', 'Edad > 45, sin deudas de consumo, historial de depósitos a plazo.');

INSERT INTO canal_difusion (id_canal_difusion, nombre_canal, tipo) VALUES
(301, 'Email Marketing', 'Digital'),
(302, 'Sucursal Física', 'Presencial'),
(303, 'App Móvil - Banner', 'Digital'),
(304, 'Redes Sociales', 'Digital');

-- B. DATOS DE CLIENTES Y SU SEGMENTACIÓN (N:M)
INSERT INTO cliente (rut, nombre_cliente, fecha_nacimiento, ingresos_mensuales, apellido_paterno, apellido_materno) VALUES
('18.123.456-7', 'Andrea', '1980-05-20', 2500000, 'Soto', 'Perez'),
('20.987.654-3', 'Javier', '2002-11-10', 500000, 'Muñoz', 'Rojas'),
('15.555.333-2', 'Roberto', '1975-02-28', 1800000, 'Vega', 'Lara'),
('14.000.111-k', 'Sofia', '1995-08-12', 1200000, 'Diaz', 'Araya');

INSERT INTO telefono_cliente (rut, telefono) VALUES
('18.123.456-7', '+56911112222'),
('20.987.654-3', '+56933334444'),
('15.555.333-2', '+56955556666'),
('18.123.456-7', '227890123');

INSERT INTO cliente_segmento (id_segmento, rut) VALUES
(101, '18.123.456-7'),
(103, '18.123.456-7'),
(102, '20.987.654-3'),
(103, '15.555.333-2'),
(101, '14.000.111-k');


-- C. DATOS DE ACCIONES COMERCIALES Y RESULTADOS (PRUEBA DE RENTABILIDAD VS PRESUPUESTO)
INSERT INTO accion_comercial (id_accion_comercial, nombre_accion, objetivo, presupuesto, exito_esperado, fecha_inicio, fecha_termino, id_producto_bancario) VALUES
(401, 'Mega Campaña Hipotecaria', 'Aumentar colocación de hipotecas en 20%', 100000000, 0.20, '2025-10-01', '2025-12-31', 201),
(402, 'Promo App Inversión', 'Captar 1.000 nuevos inversionistas', 5000000, 0.10, '2025-11-01', '2025-12-31', 203),
(403, 'Black Friday Cuenta Joven', 'Abrir 5.000 cuentas nuevas', 20000000, 0.05, '2025-11-20', '2025-12-05', 202),
(404, 'Reactivación Clientes SMS', 'Venta de Hipoteca a clientes inactivos', 1000000, 0.01, '2025-10-15', '2025-11-15', 201);

INSERT INTO resultado (id_resultado, titulo_resultado, clientes_alcanzados, rentabilidad, coeficiente_exito, inversion_recuperada, id_accion_comercial) VALUES
(501, 'Cierre Q4 Hipoteca', 15000, 150000000, 0.15, TRUE, 401),
(502, 'Cierre Q4 Inversion', 500, 2500000, 0.05, FALSE, 402),
(503, 'Cierre Q4 Cta Joven', 2000, 20000000, 0.04, TRUE, 403),
(504, 'Cierre Q4 SMS', 100, 5000000, 0.50, TRUE, 404);

-- D. RELACIONES ENTRE CAMPAÑAS, CANALES Y SEGMENTOS
INSERT INTO accion_canal (id_accion_comercial, id_canal_difusion) VALUES
(401, 301), (401, 302),
(402, 303), (402, 304),
(403, 303),
(404, 301);

INSERT INTO segmento_accion (id_segmento, id_accion_comercial) VALUES
(101, 401),
(103, 402),
(102, 403),
(101, 404);