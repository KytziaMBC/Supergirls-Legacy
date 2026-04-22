extends AudioStreamPlayer

func _on_boton_musica_toggled(button_pressed):
	# El índice 0 suele ser el bus "Master" (el principal)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), button_pressed)
	
