extends Control

# VARIABLES DE CONTROL
var monedas = 500  
var personajes_comprados = ["perso1"]
var seleccionado = "perso1"

var precios = {
	"perso1": 0,
	"perso2": 100,
	"perso3": 300,
	"perso4": 200,
	"perso5": 400
}

func _ready():
	if panel_ajustes:
		panel_ajustes.visible = false
	else:
		print("Error: No se encontró el nodo llamado 'Panel'")

	# Al empezar el juego, actualizamos los textos de los personajes y las monedas
	actualizar_interfaz()

func manejar_compra(id_perso):
	var precio = precios[id_perso]
	
	if id_perso in personajes_comprados:
		# Si ya es dueño, solo lo selecciona
		seleccionado = id_perso
	elif monedas >= precio:
		# Si tiene dinero, RESTAMOS el precio de las monedas totales
		monedas -= precio
		personajes_comprados.append(id_perso)
		seleccionado = id_perso
		print("Compra exitosa de: ", id_perso, ". Monedas restantes: ", monedas)
	else:
		print("No tienes suficiente dinero para: ", id_perso)
	
	# Llamamos a actualizar para que los cambios se vean en pantalla inmediatamente
	actualizar_interfaz()

func actualizar_interfaz():
	# 1. ACTUALIZAR EL TEXTO DE LAS MONEDAS
	# Buscamos el nuevo Label que creamos (asegúrate que el nombre sea idéntico)
	var label_monedas = get_node_or_null("LabelMonedas")
	if label_monedas:
		label_monedas.text = "Monedas: $" + str(monedas)
	
	# 2. ACTUALIZAR LOS BOTONES DE PERSONAJES (con find_child para evitar errores de ruta)
	for id in precios.keys():
		var boton = find_child(id, true, false)
		
		if boton:
			var label_btn = null
			for hijo in boton.get_children():
				if hijo is Label:
					label_btn = hijo
					break
			
			if label_btn:
				if seleccionado == id:
					label_btn.text = "ELEGIDO"
				elif id in personajes_comprados:
					label_btn.text = "ELEGIR"
				else:
					label_btn.text = "$" + str(precios[id])
					
# Buscamos el panel llamado "Panel" en cualquier parte de la jerarquía
@onready var panel_ajustes = find_child("Panel", true, false)


# --- BOTÓN SALIR ---
# Conecta la señal pressed() de tu BotonSalir a esta función
func _on_boton_salir_pressed() -> void:
	get_tree().quit() # Este comando cierra el juego

# --- BOTÓN AJUSTES ---
# Conecta la señal pressed() de tu BotonAjustes a esta función
func _on_boton_ajustes_pressed() -> void:
	if panel_ajustes:
		panel_ajustes.visible = true

# --- BOTÓN CERRAR PANEL ---
# Conecta la señal pressed() del botón que está DENTRO del panel aquí
func _on_boton_cerrar_pressed() -> void:
	if panel_ajustes:
		panel_ajustes.visible = false

# --- CONTROL DE VOLUMEN ---
func _on_h_slider_value_changed(value: float) -> void:
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_index, value)
	
	if value <= -29:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)


func _on_atras_pressed() -> void:
	if panel_ajustes:
		panel_ajustes.visible = false
		
# ASEGÚRATE DE QUE ESTO ESTÉ CONECTADO A LAS SEÑALES PRESSED
func _on_perso_1_pressed(): manejar_compra("perso1")
func _on_perso_2_pressed(): manejar_compra("perso2")
func _on_perso_3_pressed(): manejar_compra("perso3")
func _on_perso_4_pressed(): manejar_compra("perso4")
func _on_perso_5_pressed(): manejar_compra("perso5")
