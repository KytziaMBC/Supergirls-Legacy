extends Control

# --- NODOS DE LA JERARQUÍA ---
# Usamos find_child y rutas relativas para asegurar que conecten bien
@onready var panel_ajustes = find_child("Panel", true, false)
@onready var bloqueo_nivel_2 = $bloqueo  # Nodo que tapa el nivel 2
@onready var bloqueo_nivel_3 = $bloqueo2 # Nodo que tapa el nivel 3

# Botones de niveles (asegúrate de que estos nombres coincidan con tu estructura)
@onready var btn_nivel_1 = $jugar
@onready var btn_nivel_2 = $fondo/nivel2 # Si es que planeas hacerlo botón después
@onready var btn_nivel_3 = $fondo/nivel3

func _ready():
	# 1. Configuración inicial del panel de ajustes
	if panel_ajustes:
		panel_ajustes.visible = false
	else:
		print("Error: No se encontró el nodo llamado 'Panel'")
	
	# 2. Actualizar visualmente qué niveles están bloqueados
	actualizar_bloqueos_niveles()

# --- LÓGICA DE PROGRESO ---
func actualizar_bloqueos_niveles():
	# Nivel 1 siempre está desbloqueado por defecto.
	
	# Control del Nivel 2
	if Global.nivel_maximo >= 2:
		bloqueo_nivel_2.visible = false
		# btn_nivel_2.disabled = false # Descomentar si usas TextureButton para nivel 2
	else:
		bloqueo_nivel_2.visible = true
		# btn_nivel_2.disabled = true

	# Control del Nivel 3
	if Global.nivel_maximo >= 3:
		bloqueo_nivel_3.visible = false
	else:
		bloqueo_nivel_3.visible = true

# --- NAVEGACIÓN DE ESCENAS ---
func _on_jugar_pressed() -> void:
	# Solo permite entrar al Nivel 1 por ahora
	get_tree().change_scene_to_file("res://assets/project/scenes/nivel_1.tscn")

func _on_elegir_pressed() -> void:
	# Manda a la escena de selección de personajes
	get_tree().change_scene_to_file("res://assets/project/scenes/seleccion.tscn")

func _on_atras_pressed() -> void:
	# Si el panel de ajustes está abierto, lo cierra; si no, vuelve al menú principal
	if panel_ajustes and panel_ajustes.visible:
		panel_ajustes.visible = false
	else:
		get_tree().change_scene_to_file("res://assets/project/scenes/menu_principal.tscn")

# --- AJUSTES Y SONIDO ---
func _on_boton_ajustes_pressed() -> void:
	if panel_ajustes:
		panel_ajustes.visible = true #

func _on_boton_cerrar_pressed() -> void:
	if panel_ajustes:
		panel_ajustes.visible = false #

func _on_h_slider_value_changed(value: float) -> void:
	# Control de volumen maestro
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_index, value)
	
	# Mute automático si el slider está muy bajo
	if value <= -29:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)

func _on_boton_salir_pressed() -> void:
	get_tree().quit() # Cierra la aplicación
