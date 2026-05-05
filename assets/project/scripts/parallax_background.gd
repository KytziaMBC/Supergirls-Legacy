extends ParallaxBackground

# Esta es la velocidad a la que se moverá el fondo
@export var velocidad: float = 100.0

func _process(delta: float) -> void:
	# Sumamos velocidad al desplazamiento horizontal (X)
	# Multiplicamos por 'delta' para que se mueva fluido sin importar los FPS
	scroll_offset.x -= velocidad * delta
