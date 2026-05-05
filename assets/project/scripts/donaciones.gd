extends Control

# Buscamos el panel llamado "Panel" en cualquier parte de la jerarquía
@onready var panel_ajustes = find_child("Panel", true, false)

func _ready():
	if panel_ajustes:
		panel_ajustes.visible = false
	else:
		print("Error: No se encontró el nodo llamado 'Panel'")

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
