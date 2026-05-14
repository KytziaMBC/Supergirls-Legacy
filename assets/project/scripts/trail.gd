extends Line2D

@export var largo_estela : float = 150.0  # El largo del rectángulo
@export var offset : Vector2 = Vector2(-20, 5) # Ajuste para que salga de la espalda

func _ready():
	# Limpiamos puntos al iniciar
	clear_points()
	# Ponemos el Z-Index en -1 para que siempre esté detrás de la mona
	z_index = -1

func _process(_delta):
	# Si no hay padre (personaje), no hacemos nada
	if not get_parent(): return
	
	clear_points()
	
	# 1. Obtenemos la posición real de la mona en el mapa
	var punto_inicio_global = get_parent().global_position + offset
	
	# 2. Calculamos el final (restando en X para que vaya hacia atrás)
	var punto_final_global = punto_inicio_global + Vector2(-largo_estela, 0)
	
	# 3. TRUCO CRÍTICO: Convertimos las posiciones del mundo a coordenadas
	# que el Line2D entienda dentro de su propio espacio.
	add_point(to_local(punto_inicio_global))
	add_point(to_local(punto_final_global))
