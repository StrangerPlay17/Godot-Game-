extends CharacterBody2D

var gravity = 10
var speed = 25
var moving_left = true
var player_detected = false # Para indicar si se ha detectado al jugador
var eliminated = false

# Hace caminar al enemigo iniciando el script con su animación
func _ready() -> void:
	$AnimationPlayer.play("Walk")

# Invoca el proceso de caminado 
func _process(delta: float) -> void:
	move_character()
	turn()

func move_character():
	if eliminated: # Si el enemigo murio, dejar de producir movimiento
		return
	velocity.y += gravity
	if player_detected: # Si el jugador es detectado
		# Persigue al jugador
		if moving_left:
			velocity.x = -speed
		else:
			velocity.x = speed
	else:
		# Movimiento normal si el jugador no está detectado
		if moving_left:
			velocity.x = -speed
		else:
			velocity.x = speed
	move_and_slide()

# Cambia de dirección al enemigo al caminar
func turn():
	# Valida si el enemigo está a punto de caerse
	if not $RayCastFloor2D.is_colliding():
		moving_left = !moving_left # Cambia el movimiento del enemigo al lado contrario
		scale.x = -scale.x # Gira al enemigo
		speed = 25 # Vuelve a su velocidad inicial
	
	# Si el raycast frontal detecta al jugador
	elif $RayCastWall2D.is_colliding():
		var collider = $RayCastWall2D.get_collider()
		if collider != null and collider.name == "Player1" or collider.name == "Player2":
			player_detected = true # Marca al jugador como detectado
			speed += 45 # Persigue mas rapido al jugador
		else: # En caso contrario, valida si el enemigo choca con una pared
			moving_left = !moving_left # Cambia el movimiento del enemigo al lado contrario
			scale.x = -scale.x # Gira al enemigo
			speed = 25 # Vuelve a su velocidad inicial
	# Si el raycast trasero detecta al jugador
	elif $RayCastBack2D.is_colliding():
		var back_collider = $RayCastBack2D.get_collider()
		if back_collider != null and back_collider.name == "Player1" or back_collider.name == "Player2":
			player_detected = true # Marca al jugador como detectado
			speed += 45 #Persigue mas rapido al jugador
			moving_left = !moving_left # Cambia de dirección hacia el jugador
			scale.x = -scale.x # Gira al enemigo hacia el jugador
	else:
		player_detected = false # No detecta al jugador, comportamiento normal

# Al tocar el enemigo, se llama a la función "loseLife" en player
func _on_area_2d_body_entered(body: Node2D) -> void:
	print("El enemigo te golpeo")
	if body.name == "Player1" or body.name == "Player2":
		if eliminated == false: # Si el enemigo murio, no puede golpear
			$AnimationPlayer.play("Attack") # Animacion de golpe
			$Hit2D.visible = true  # Activa el sprite Hit2D para que sea visible
			body._loseLife(position.x)
			await get_tree().create_timer(0.8).timeout # Espera al terminar la animacion para ocultar el hit
			$Hit2D.visible = false  # Oculta el sprite Hit2D 
			$AnimationPlayer.play("Walk") # El enemigo vuelve a caminar luego de golpear
			
			

# Al tocar al enemigo por "encima" el enemigo muere
func _on_head_area_body_entered(body: Node2D) -> void:
	print("Pisaste al enemigo")
	if body.name == "Player1" or body.name == "Player2":
		eliminated = true
		die() # El enemigo muere
		body.velocity.y = -200  # Rebote del jugador hacia arriba
func die():
	$AnimationPlayer.play("Death") 
	$LifeSound.play()
	await get_tree().create_timer(1).timeout
	queue_free()  # Elimina al enemigo
	eliminated = false
