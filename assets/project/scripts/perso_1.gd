extends CharacterBody2D

# Variable para ajustar qué tan rápido vuela/se mueve
@export var velocidad_movimiento: float = 300.0

func _physics_process(delta: float) -> void:
	# Obtenemos la dirección solo en el eje vertical (Y)
	# Devuelve -1 (arriba), 1 (abajo) o 0 (quieto)
	var direccion_y = Input.get_axis("ui_up", "ui_down")
	
	# Bloqueamos el movimiento horizontal (X siempre es 0)
	velocity.x = 0
	
	# Aplicamos la velocidad al eje vertical
	velocity.y = direccion_y * velocidad_movimiento

	# Esta función propia de CharacterBody2D aplica el movimiento
	move_and_slide()

# Esta función detecta cualquier entrada del usuario (teclado, mouse, táctil)
func _input(event: InputEvent) -> void:
	# Verificamos si el evento es un clic de Mouse (para pruebas en PC) 
	# o un toque en la pantalla (para Móvil)
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		# Solo queremos que ataque cuando presiona, no cuando suelta el dedo
		if event.pressed:
			ejecutar_ataque()

func ejecutar_ataque() -> void:
	print("¡Toque/Clic detectado! Haciendo daño al enemigo...")
	
	# Lógica futura: Aquí pondremos el código para detectar enemigos cercanos 
	# (usando un Area2D) y restarles vida.
	
	# --- ANIMACIÓN DE ATAQUE (Comentado por ahora) ---
	# Cuando tengas la animación lista en tu AnimationPlayer o AnimatedSprite2D, 
	# solo debes quitar el "#" de la línea de abajo y ajustar el nombre:
	# $AnimationPlayer.play("animacion_ataque")
