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
    print("4. Salir")
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

def ver_clientes():
    """Muestra todos los clientes"""
    clientes = execute_query("SELECT * FROM cliente LIMIT 10")
    print("\n--- CLIENTES ---")
    for c in clientes:
        print(f"  RUT: {c[0]} | Nombre: {c[1]} {c[4]} {c[5]} | Ingresos: ${c[3]}")

def ver_acciones():
    """Muestra acciones comerciales"""
    acciones = execute_query("SELECT * FROM accion_comercial")
    print("\n--- ACCIONES COMERCIALES ---")
    for a in acciones:
        print(f"  ID: {a[0]} | {a[1]} | Presupuesto: ${a[3]}")

def ver_resultados():
    """Muestra resultados"""
    resultados = execute_query("SELECT * FROM resultado")
    print("\n--- RESULTADOS ---")
    if not resultados:
        print("  No hay resultados registrados")
    for r in resultados:
        print(f"  ID: {r[0]} | Titulo: {r[1]} | Clientes: {r[2]} | Rentabilidad: ${r[3]}")

def ver_segmentos():
    """Muestra segmentos"""
    segmentos = execute_query("SELECT * FROM segmento")
    print("\n--- SEGMENTOS ---")
    for s in segmentos:
        print(f"  ID: {s[0]} | {s[2]} | Tamano: {s[1]}")

def ver_productos():
    """Muestra productos bancarios"""
    productos = execute_query("SELECT * FROM producto_bancario")
    print("\n--- PRODUCTOS BANCARIOS ---")
    for p in productos:
        print(f"  ID: {p[0]} | {p[1]} | Tipo: {p[2]}")

def ver_canales():
    """Muestra canales de difusion"""
    canales = execute_query("SELECT * FROM canal_difusion")
    print("\n--- CANALES DE DIFUSION ---")
    for c in canales:
        print(f"  ID: {c[0]} | {c[1]} | Tipo: {c[2]}")

def ver_telefonos():
    """Muestra telefonos de clientes"""
    telefonos = execute_query("SELECT * FROM telefono_cliente LIMIT 20")
    print("\n--- TELEFONOS DE CLIENTES ---")
    for t in telefonos:
        print(f"  RUT: {t[0]} | Telefono: {t[1]}")

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
            elif opcion == "4":
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