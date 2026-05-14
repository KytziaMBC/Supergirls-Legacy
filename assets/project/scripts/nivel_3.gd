extends Control

# --- REFERENCIAS A NODOS ---
@onready var panel_ajustes = find_child("Panel", true, false)
@onready var label_monedas = find_child("ContadorMonedas", true, false)

# Paneles de estado final e intermedio
@onready var panel_game_over = find_child("PanelGameOver", true, false)
@onready var panel_victoria = find_child("PanelVictoria", true, false)
@onready var label_monedas_final = find_child("TextoMonedasFinal", true, false)

# Recursos para Spawning
@onready var escena_cristal = preload("res://assets/project/scenes/cristal.tscn")

func _ready():
	# Inicializamos el estado del juego
	get_tree().paused = false
	
	# Ocultamos todos los paneles al iniciar
	ocultar_todos_los_paneles()
	
	# Cargamos al personaje seleccionado
	spawn_personaje_seleccionado()

func _process(_delta):
	# Mantenemos el marcador de monedas actualizado
	if label_monedas:
		label_monedas.text = "MONEDAS: " + str(Global.monedas)

func spawn_personaje_seleccionado():
	# Lógica de instanciación del personaje basada en la selección previa
	var nombre_archivo = Global.seleccionado + ".tscn"
	var ruta_completa = "res://assets/project/scenes/" + nombre_archivo
	
	if ResourceLoader.exists(ruta_completa):
		var escena_perso = load(ruta_completa)
		var instancia = escena_perso.instantiate()
		add_child(instancia)
		
		# Posicionamiento inicial en el SpawnPoint
		if has_node("SpawnPoint"):
			instancia.position = $SpawnPoint.position
		else:
			instancia.position = Vector2(200, 400)
	else:
		print("Error: No se encontró la escena del personaje en: ", ruta_completa)

# --- SISTEMA DE GENERACIÓN (SPAWNER) ---

func _on_timer_cristal_timeout() -> void:
	# Genera un cristal de victoria cada 15 segundos
	var cristal_nuevo = escena_cristal.instantiate()
	
	# Posición aleatoria en el eje Y (ajustar según tu resolución)
	var y_random = randf_range(100, 500) 
	cristal_nuevo.position = Vector2(1200, y_random) 
	
	add_child(cristal_nuevo)

# --- SISTEMA DE VICTORIA Y DERROTA ---

func mostrar_game_over() -> void:
	# Detenemos el juego y mostramos el panel de pérdida
	get_tree().paused = true
	if panel_game_over:
		panel_game_over.visible = true
	actualizar_conteo_final()

func mostrar_victoria() -> void:
	# Detenemos el juego y mostramos el panel de victoria
	get_tree().paused = true
	if panel_victoria:
		panel_victoria.visible = true
	
	# Guardamos el progreso (desbloqueo de nivel y monedas)
	Global.save_game()
	actualizar_conteo_final()

func actualizar_conteo_final():
	if label_monedas_final:
		label_monedas_final.text = "TOTAL RECOLECTADO: " + str(Global.monedas)

# --- NAVEGACIÓN Y BOTONES ---

func _on_boton_siguiente_pressed() -> void:
	# Avanzar al siguiente nivel despausando el motor
	get_tree().paused = false
	Global.save_game()
	
	var ruta_nivel2 = "res://assets/project/scenes/nivel_2.tscn"
	if ResourceLoader.exists(ruta_nivel2):
		get_tree().change_scene_to_file(ruta_nivel2)
	else:
		# Fallback al menú si el nivel no existe
		get_tree().change_scene_to_file("res://assets/project/scenes/menu_secundario.tscn")

func _on_reiniciar_pressed() -> void:
	# Reinicia la escena actual
	ocultar_todos_los_paneles()
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_boton_salir_pressed() -> void:
	# Regresa al menú de selección de personaje
	ocultar_todos_los_paneles()
	get_tree().paused = false
	Global.save_game()
	get_tree().change_scene_to_file("res://assets/project/scenes/menu_secundario.tscn")

func ocultar_todos_los_paneles():
	if panel_ajustes: panel_ajustes.visible = false
	if panel_game_over: panel_game_over.visible = false
	if panel_victoria: panel_victoria.visible = false

# --- SEÑALES DE AJUSTES (PAUSA) ---

func _on_boton_ajustes_pressed() -> void:
	if panel_ajustes:
		panel_ajustes.visible = true
		get_tree().paused = true

func _on_atras_pressed() -> void:
	if panel_ajustes:
		panel_ajustes.visible = false
		get_tree().paused = false

# --- CONTROL DE AUDIO ---

func _on_h_slider_value_changed(value: float) -> void:
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_index, value)
	AudioServer.set_bus_mute(bus_index, value <= -29)

# --- CONEXIONES EXTRA (Manejadores de señales) ---

func _on_boton_reiniciar_pressed() -> void:
	_on_reiniciar_pressed()
