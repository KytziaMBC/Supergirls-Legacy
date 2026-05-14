extends Marker2D

@export var escena_enemigo : PackedScene
@export var escena_moneda : PackedScene # Arrastra la nueva escena aquí

func _on_timer_timeout():
	var chance = randf() # Genera un número entre 0.0 y 1.0
	var objeto
	
	if chance < 0.7:
		objeto = escena_enemigo.instantiate()
	else:
		objeto = escena_moneda.instantiate()
	
	var y_random = randf_range(50, 550)
	objeto.global_position = Vector2(global_position.x, y_random)
	get_parent().add_child(objeto)
