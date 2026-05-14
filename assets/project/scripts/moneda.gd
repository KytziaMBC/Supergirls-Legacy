extends Area2D

@export var velocidad : float = 250.0

func _ready():
	$AnimatedSprite2D.play("girar")

func _process(delta):
	position.x -= velocidad * delta
	if global_position.x < -100:
		queue_free()

func _on_body_entered(body):
	if body is CharacterBody2D:
		# 1. Sumamos la moneda al Global y guardamos
		Global.añadir_monedas(1)
		
		# 2. Reproducimos el sonido
		$AudioStreamPlayer2D.play()
		
		# 3. TRUCO DE INGENIERÍA:
		# Ocultamos la moneda y desactivamos su colisión para que no 
		# se pueda agarrar dos veces mientras suena.
		hide() 
		set_deferred("monitoring", false)
		
		# 4. Esperamos a que el sonido termine antes de borrar el nodo
		await $AudioStreamPlayer2D.finished
		
		# 5. Ahora sí, limpiamos la memoria
		queue_free()
