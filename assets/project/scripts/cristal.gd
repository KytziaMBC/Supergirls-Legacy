extends Area2D

# Ajusta esta velocidad para que coincida con el ritmo de tu nivel
@export var velocidad: float = 300.0 

func _process(delta: float) -> void:
	# Movemos el cristal hacia la izquierda cada frame
	position.x -= velocidad * delta
	
	# Si el cristal sale de la pantalla por la izquierda sin ser tocado, lo borramos
	if position.x < -200:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		if get_tree().current_scene.has_method("mostrar_victoria"):
			get_tree().current_scene.mostrar_victoria()
			queue_free()
