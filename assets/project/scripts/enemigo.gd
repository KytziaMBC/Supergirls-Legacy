extends Area2D

@export var velocidad : float = 300.0

func _ready():
	$AnimatedSprite2D.play("vuelo")

func _process(delta):
	# El movimiento que ya tenías
	position.x -= velocidad * delta
	
	if global_position.x < -100:
		queue_free()
		
func _on_body_entered(body: Node2D) -> void:
	# Verificamos si lo que chocó con el enemigo fue el personaje
	if body is CharacterBody2D:
		
		# Opcional: Reproducir sonido de golpe aquí
		
		# Llamamos a la función mostrar_game_over() que está en nivel1
		if get_tree().current_scene.has_method("mostrar_game_over"):
			get_tree().current_scene.mostrar_game_over()
