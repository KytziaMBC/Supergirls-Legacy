extends Control

# --- CONFIGURACIÓN DE UI ---
# Usamos @onready para asegurar que los nodos existan antes de usarlos
@onready var panel_ajustes = find_child("Panel", true, false)
@onready var label_monedas = get_node_or_null("LabelMonedas")

func _ready():
	# 1. Configuración inicial de visibilidad
	if panel_ajustes:
		panel_ajustes.visible = false
	else:
		print("Error: No se encontró el nodo llamado 'Panel'")

	# 2. Sincronizamos la interfaz con los datos globales inmediatamente
	actualizar_interfaz()

# --- LÓGICA DE COMPRA Y SELECCIÓN ---
func manejar_compra(id_perso: String):
	# Obtenemos el precio desde el script Global (Autoload)
	var precio = Global.precios[id_perso]
	
	if id_perso in Global.personajes_comprados:
		# Si ya es dueño, solo lo selecciona
		Global.seleccionado = id_perso
		print("Seleccionado: ", id_perso)
	elif Global.monedas >= precio:
		# Si tiene dinero, realizamos la transacción en el Global
		Global.monedas -= precio
		Global.personajes_comprados.append(id_perso)
		Global.seleccionado = id_perso
		print("Compra exitosa: ", id_perso, ". Monedas restantes: ", Global.monedas)
	else:
		print("No tienes suficiente dinero para: ", id_perso)
	
	# Refrescamos los textos en pantalla
	actualizar_interfaz()

func actualizar_interfaz():
	# 1. Actualizar el contador de monedas
	if label_monedas:
		label_monedas.text = "Monedas: $" + str(Global.monedas)
	
	# 2. Actualizar el estado de todos los botones de personajes
	for id in Global.precios.keys():
		var boton = find_child(id, true, false)
		if boton:
			var label_btn = _buscar_label_en_hijos(boton)
			if label_btn:
				# Lógica de estados del botón
				if Global.seleccionado == id:
					label_btn.text = "ELEGIDO"
				elif id in Global.personajes_comprados:
					label_btn.text = "ELEGIR"
				else:
					label_btn.text = "$" + str(Global.precios[id])

# Función de apoyo para encontrar el Label dentro de cada botón
func _buscar_label_en_hijos(nodo_padre: Node) -> Label:
	for hijo in nodo_padre.get_children():
		if hijo is Label:
			return hijo
	return null

# --- SEÑALES DE BOTONES DE PERSONAJES ---
# Asegúrate de que estos nombres coincidan con tus nodos en la jerarquía
func _on_perso_1_pressed(): manejar_compra("perso1")
func _on_perso_2_pressed(): manejar_compra("perso2")
func _on_perso_3_pressed(): manejar_compra("perso3")
func _on_perso_4_pressed(): manejar_compra("perso4")
func _on_perso_5_pressed(): manejar_compra("perso5")

# --- MENÚ DE AJUSTES Y NAVEGACIÓN ---
func _on_boton_ajustes_pressed() -> void:
	if panel_ajustes: panel_ajustes.visible = true

func _on_boton_cerrar_pressed() -> void:
	if panel_ajustes: panel_ajustes.visible = false

func _on_atras_pressed() -> void:
	# Regresa al menú de niveles
	get_tree().change_scene_to_file("res://assets/project/scenes/menu_secundario.tscn")

func _on_boton_salir_pressed() -> void:
	get_tree().quit()

# --- CONTROL DE AUDIO ---
func _on_h_slider_value_changed(value: float) -> void:
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_index, value)
	AudioServer.set_bus_mute(bus_index, value <= -29)
