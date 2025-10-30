-- DDL

DROP TABLE IF EXISTS resultado CASCADE;
DROP TABLE IF EXISTS telefono_cliente CASCADE;
DROP TABLE IF EXISTS cliente_segmento CASCADE;
DROP TABLE IF EXISTS segmento_accion CASCADE;
DROP TABLE IF EXISTS accion_canal CASCADE;
DROP TABLE IF EXISTS cliente CASCADE;
DROP TABLE IF EXISTS canal_difusion CASCADE;
DROP TABLE IF EXISTS accion_comercial CASCADE;
DROP TABLE IF EXISTS segmento CASCADE;
DROP TABLE IF EXISTS producto_bancario CASCADE;


CREATE TABLE producto_bancario (
    id_producto_bancario INT PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    tipo VARCHAR(100) NOT NULL,
    fecha_lanzamiento DATE NOT NULL    
);

CREATE TABLE canal_difusion (
    id_canal_difusion INT PRIMARY KEY,
    nombre_canal VARCHAR(100) NOT NULL,
    tipo VARCHAR(100) NOT NULL
);

CREATE TABLE segmento (
    id_segmento INT PRIMARY KEY,
    tamano_segmento INT NOT NULL,
    nombre_segmento VARCHAR(100),
    criterios TEXT NOT NULL
);
CREATE TABLE cliente (
    rut VARCHAR(14) PRIMARY KEY,
    nombre_cliente VARCHAR(100),
    fecha_nacimiento DATE NOT NULL,
    ingresos_mensuales INT,
    apellido_paterno VARCHAR(100),
    apellido_materno VARCHAR(100)
);

CREATE TABLE accion_comercial (
    id_accion_comercial INT PRIMARY KEY,
    nombre_accion VARCHAR(150) NOT NULL,
    objetivo TEXT NOT NULL,
    presupuesto INT NOT NULL,
    exito_esperado FLOAT,
    fecha_inicio DATE NOT NULL,
    fecha_termino DATE,
    id_producto_bancario INT,
    FOREIGN KEY (id_producto_bancario) REFERENCES producto_bancario(id_producto_bancario)
);

CREATE TABLE accion_canal (
    id_accion_comercial INT,
    id_canal_difusion INT,
    PRIMARY KEY (id_accion_comercial, id_canal_difusion),
    FOREIGN KEY (id_accion_comercial) REFERENCES accion_comercial(id_accion_comercial),
    FOREIGN KEY (id_canal_difusion) REFERENCES canal_difusion(id_canal_difusion)
);

CREATE TABLE cliente_segmento (
    id_segmento INT,
    rut VARCHAR(14),
    PRIMARY KEY (id_segmento, rut),
    FOREIGN KEY (id_segmento) REFERENCES segmento(id_segmento),
    FOREIGN KEY (rut) REFERENCES cliente(rut) 
);

CREATE TABLE segmento_accion (
    id_segmento INT,
    id_accion_comercial INT,
    PRIMARY KEY (id_segmento, id_accion_comercial),
    FOREIGN KEY (id_segmento) REFERENCES segmento(id_segmento),
    FOREIGN KEY (id_accion_comercial) REFERENCES accion_comercial(id_accion_comercial)
);

CREATE TABLE telefono_cliente (
    rut VARCHAR(14),
    telefono VARCHAR(100),
    PRIMARY KEY (rut, telefono),
    FOREIGN KEY (rut) REFERENCES cliente(rut)
);

CREATE TABLE resultado (
    id_resultado INT PRIMARY KEY,
    titulo_resultado VARCHAR(100) NOT NULL,
    clientes_alcanzados INT NOT NULL,
    rentabilidad INT NOT NULL,
    coeficiente_exito FLOAT NOT NULL,
    id_accion_comercial INT,
    inversion_recuperada BOOLEAN,
    FOREIGN KEY (id_accion_comercial) REFERENCES accion_comercial(id_accion_comercial)
);