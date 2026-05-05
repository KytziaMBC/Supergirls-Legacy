extends TextureButton

func _on_pressed():
	print("¡El botón funciona!")
	get_tree().change_scene_to_file("res://assets/project/scenes/escena_creditos.tscn")
