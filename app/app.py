from db import (
    init_connection_pool, 
    close_connection_pool,
    execute_query,
    execute_update,
    call_procedure
)

def mostrar_menu():
    """Muestra el menú principal"""
    print("\n" + "="*50)
    print("      GESTIÓN DE MARKETING - BANCO FUTURA")
    print("="*50)
    print("1. VER DATOS")
    print("2. INSERTAR DATOS")
    print("3. STORED PROCEDURES")
    print("4. EJECUTAR QUERY PERSONALIZADO") # ¡NUEVA OPCIÓN!
    print("5. Salir")
    print("="*50)

def menu_ver_datos():
    """Submenú para ver datos"""
    print("\n--- VER DATOS ---")
    print("1. Ver clientes")
    print("2. Ver acciones comerciales")
    print("3. Ver resultados")
    print("4. Ver segmentos")
    print("5. Ver productos bancarios")
    print("6. Ver canales de difusion")
    print("7. Ver telefonos de clientes")
    print("8. Buscar cliente por RUT")
    print("0. Volver al menu principal")
    
    opcion = input("\nSelecciona una opcion: ")
    
    if opcion == "1":
        ver_clientes()
    elif opcion == "2":
        ver_acciones()
    elif opcion == "3":
        ver_resultados()
    elif opcion == "4":
        ver_segmentos()
    elif opcion == "5":
        ver_productos()
    elif opcion == "6":
        ver_canales()
    elif opcion == "7":
        ver_telefonos()
    elif opcion == "8":
        buscar_cliente()
    elif opcion == "0":
        return
    else:
        print("Opcion invalida")

def menu_insertar_datos():
    """Submenú para insertar datos"""
    print("\n--- INSERTAR DATOS ---")
    print("1. Insertar cliente")
    print("2. Insertar producto bancario")
    print("3. Insertar accion comercial")
    print("4. Insertar segmento")
    print("5. Insertar canal de difusion")
    print("0. Volver al menu principal")
    
    opcion = input("\nSelecciona una opcion: ")
    
    if opcion == "1":
        insertar_cliente()
    elif opcion == "2":
        insertar_producto()
    elif opcion == "3":
        insertar_accion()
    elif opcion == "4":
        insertar_segmento()
    elif opcion == "5":
        insertar_canal()
    elif opcion == "0":
        return
    else:
        print("Opcion invalida")

def menu_stored_procedures():
    """Submenú para stored procedures"""
    print("\n--- STORED PROCEDURES ---")
    print("1. Generar resultado (SP generar_resultado)")
    print("0. Volver al menu principal")
    
    opcion = input("\nSelecciona una opcion: ")
    
    if opcion == "1":
        generar_resultado()
    elif opcion == "0":
        return
    else:
        print("Opcion invalida")

# ============== FUNCIONES VER DATOS ==============

def mostrar_tabla(tabla, limit=10):
    """Muestra los nombres de columnas y los datos de la tabla indicada"""
    columnas = execute_query(
        f"SELECT column_name FROM information_schema.columns WHERE table_name = '{tabla}' ORDER BY ordinal_position"
    )
    nombres = [col[0] for col in columnas]
    print(f"\n--- {tabla.upper()} ---")
    print(" | ".join(nombres))
    print("-" * (len(nombres) * 12))
    datos = execute_query(f"SELECT * FROM {tabla} LIMIT {limit}")
    for fila in datos:
        print(" | ".join(str(valor) for valor in fila))

def ver_clientes():
    mostrar_tabla("cliente")

def ver_acciones():
    mostrar_tabla("accion_comercial")

def ver_resultados():
    mostrar_tabla("resultado")

def ver_segmentos():
    mostrar_tabla("segmento")

def ver_productos():
    mostrar_tabla("producto_bancario")

def ver_canales():
    mostrar_tabla("canal_difusion")

def ver_telefonos():
    mostrar_tabla("telefono_cliente", limit=20)

def buscar_cliente():
    """Busca cliente por RUT"""
    rut = input("Ingresa RUT del cliente: ")
    query = f"SELECT * FROM cliente WHERE rut = '{rut}'"
    cliente = execute_query(query)
    if cliente and len(cliente) > 0:
        c = cliente[0]
        print(f"\n--- Cliente encontrado ---")
        print(f"  RUT: {c[0]}")
        print(f"  Nombre: {c[1]} {c[4]} {c[5]}")
        print(f"  Fecha nacimiento: {c[2]}")
        print(f"  Ingresos: ${c[3]}")
    else:
        print("Cliente no encontrado")

# ============== FUNCIONES INSERTAR DATOS ==============

def insertar_cliente():
    """Inserta un nuevo cliente"""
    print("\n--- NUEVO CLIENTE ---")
    rut = input("RUT (12.345.678-9): ")
    nombre = input("Nombre: ")
    apellido_p = input("Apellido paterno: ")
    apellido_m = input("Apellido materno: ")
    fecha_nac = input("Fecha nacimiento (YYYY-MM-DD): ")
    ingresos = input("Ingresos mensuales: ")
    
    try:
        query = f"""INSERT INTO cliente (rut, nombre_cliente, fecha_nacimiento, 
                 ingresos_mensuales, apellido_paterno, apellido_materno) 
                 VALUES ('{rut}', '{nombre}', '{fecha_nac}', {ingresos}, '{apellido_p}', '{apellido_m}')"""
        execute_update(query)
        print("[OK] Cliente insertado correctamente")
    except Exception as e:
        print(f"[ERROR] Error: {e}")

def insertar_producto():
    """Inserta un nuevo producto bancario"""
    print("\n--- NUEVO PRODUCTO BANCARIO ---")
    id_prod = input("ID producto: ")
    nombre = input("Nombre: ")
    tipo = input("Tipo: ")
    fecha = input("Fecha lanzamiento (YYYY-MM-DD): ")
    
    try:
        query = f"""INSERT INTO producto_bancario (id_producto_bancario, nombre_producto, tipo, fecha_lanzamiento)
                     VALUES ({id_prod}, '{nombre}', '{tipo}', '{fecha}')"""
        execute_update(query)
        print("[OK] Producto insertado correctamente")
    except Exception as e:
        print(f"[ERROR] Error: {e}")

def insertar_accion():
    """Inserta una nueva accion comercial"""
    print("\n--- NUEVA ACCION COMERCIAL ---")
    id_accion = input("ID accion: ")
    nombre = input("Nombre: ")
    objetivo = input("Objetivo: ")
    presupuesto = input("Presupuesto: ")
    fecha = input("Fecha inicio (YYYY-MM-DD): ")
    id_producto = input("ID producto bancario: ")
    
    try:
        query = f"""INSERT INTO accion_comercial (id_accion_comercial, nombre_accion, objetivo, presupuesto, fecha_inicio, id_producto_bancario)
                     VALUES ({id_accion}, '{nombre}', '{objetivo}', {presupuesto}, '{fecha}', {id_producto})"""
        execute_update(query)
        print("[OK] Accion comercial insertada correctamente")
    except Exception as e:
        print(f"[ERROR] Error: {e}")

def insertar_segmento():
    """Inserta un nuevo segmento"""
    print("\n--- NUEVO SEGMENTO ---")
    id_seg = input("ID segmento: ")
    tamano = input("Tamano segmento: ")
    nombre = input("Nombre: ")
    criterios = input("Criterios: ")
    
    try:
        query = f"""INSERT INTO segmento (id_segmento, tamano_segmento, nombre_segmento, criterios)
                     VALUES ({id_seg}, {tamano}, '{nombre}', '{criterios}')"""
        execute_update(query)
        print("[OK] Segmento insertado correctamente")
    except Exception as e:
        print(f"[ERROR] Error: {e}")

def insertar_canal():
    """Inserta un nuevo canal de difusion"""
    print("\n--- NUEVO CANAL DE DIFUSION ---")
    id_canal = input("ID canal: ")
    nombre = input("Nombre: ")
    tipo = input("Tipo: ")
    
    try:
        query = f"""INSERT INTO canal_difusion (id_canal_difusion, nombre_canal, tipo)
                     VALUES ({id_canal}, '{nombre}', '{tipo}')"""
        execute_update(query)
        print("[OK] Canal insertado correctamente")
    except Exception as e:
        print(f"[ERROR] Error: {e}")

# ============== FUNCIONES STORED PROCEDURES ==============

def generar_resultado():
    """Llama al SP para generar resultado"""
    id_accion = input("Ingresa ID de accion comercial: ")
    try:
        call_procedure('generar_resultado', [int(id_accion)])
        print("[OK] Resultado generado exitosamente.")
    except Exception as e:
        print(f"[ERROR] Error: {e}")

# ============== FUNCION PERSONALIZADA DDL/DML/DQL ==============

def ejecutar_query_personalizado():
    """
    Permite al usuario ingresar y ejecutar una query SQL
    detectando si es de solo lectura (SELECT) o de modificación (UPDATE/DELETE/INSERT/DDL).
    """
    print("\n--- EJECUTAR QUERY PERSONALIZADO ---")
    print("ADVERTENCIA: Ingresa comandos SQL válidos. Sé responsable con ALTER/DROP.")
    
    # Permite al usuario escribir queries de varias líneas
    query_lines = []
    print("Ingresa tu query (termina con una línea vacía):")
    while True:
        line = input("SQL > ")
        if not line:
            break
        query_lines.append(line)
        
    query = " ".join(query_lines).strip()
    
    if not query:
        print("No se ingresó ninguna query.")
        return

    # Normalizar la query para la detección
    query_upper = query.upper().strip()
    
    try:
        if query_upper.startswith("SELECT"):
            # Usar execute_query para comandos SELECT
            resultados = execute_query(query)
            
            if resultados:
                # Intenta obtener los nombres de las columnas para mejorar la visualización
                try:
                    # Esto requiere una suposición, en un entorno real se obtendrían de metadatos
                    # Aquí mostramos solo los datos
                    print("\n--- RESULTADOS ---")
                    # Intenta mostrar una cabecera simple si la query es un SELECT simple
                    if len(resultados) > 0 and isinstance(resultados[0], (list, tuple)):
                        # Intentar inferir el número de columnas para el separador
                        num_cols = len(resultados[0])
                        print("-" * (num_cols * 15))
                        for fila in resultados:
                            print(" | ".join(str(valor) for valor in fila))
                        print("-" * (num_cols * 15))
                    else:
                        for fila in resultados:
                            print(fila)
                    print(f"Filas encontradas: {len(resultados)}")
                except Exception:
                     for fila in resultados:
                            print(fila)
                     print(f"Filas encontradas: {len(resultados)}")
            else:
                print("[OK] Query de selección ejecutada. No se encontraron resultados.")
                
        else:
            # Usar execute_update para comandos INSERT, UPDATE, DELETE, CREATE, DROP, ALTER (DML/DDL)
            execute_update(query)
            print(f"[OK] Query de modificación (DML/DDL) ejecutada correctamente.")
            
    except Exception as e:
        print(f"[ERROR] La ejecución de la query falló: {e}")


# ============== MAIN ==============

def main():
    """Función principal"""
    # Inicializar conexión
    init_connection_pool()
    
    try:
        while True:
            mostrar_menu()
            opcion = input("\nSelecciona una opcion: ")
            
            if opcion == "1":
                menu_ver_datos()
            elif opcion == "2":
                menu_insertar_datos()
            elif opcion == "3":
                menu_stored_procedures()
            elif opcion == "4": # NUEVA OPCION
                ejecutar_query_personalizado()
            elif opcion == "5": # Opción 5 ahora es salir
                print("\nHasta luego!")
                break
            else:
                print("Opcion invalida")
            
            input("\nPresiona ENTER para continuar...")
    
    except KeyboardInterrupt:
        print("\n\nAplicacion interrumpida")
    
    finally:
        # Cerrar conexiones
        close_connection_pool()

if __name__ == "__main__":
    main()