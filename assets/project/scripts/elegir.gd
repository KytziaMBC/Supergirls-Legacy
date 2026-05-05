extends TextureButton

func _on_pressed():
	# Cambia la escena de vuelta al menú principal
	# Asegúrate de que el nombre del archivo sea exacto (menu.tscn o menu_principal.tscn)
	get_tree().change_scene_to_file("res://assets/project/scenes/seleccion.tscn")


func _on_elegir_pressed() -> void:
	pass # Replace with function body.
