extends CharacterBody2D

var gravity = 10
var speed = 25
var moving_left = true
var player_detected = false # Para indicar si se ha detectado al jugador

# Hace caminar al enemigo iniciando el script con su animación
func _ready() -> void:
	$AnimationPlayer.play("Walk")

# Invoca el proceso de caminado 
func _process(delta: float) -> void:
	move_character()
	turn()

func move_character():
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
		if collider != null and collider.name == "Player1":
			player_detected = true # Marca al jugador como detectado
			speed += 45 # Persigue mas rapido al jugador
		else: # En caso contrario, valida si el enemigo choca con una pared
			moving_left = !moving_left # Cambia el movimiento del enemigo al lado contrario
			scale.x = -scale.x # Gira al enemigo
			speed = 25 # Vuelve a su velocidad inicial
	# Si el raycast trasero detecta al jugador
	elif $RayCastBack2D.is_colliding():
		var back_collider = $RayCastBack2D.get_collider()
		if back_collider != null and back_collider.name == "Player1":
			player_detected = true # Marca al jugador como detectado
			speed += 45 #Persigue mas rapido al jugador
			moving_left = !moving_left # Cambia de dirección hacia el jugador
			scale.x = -scale.x # Gira al enemigo hacia el jugador
	else:
		player_detected = false # No detecta al jugador, comportamiento normal

# Al tocar el enemigo, se llama a la función "loseLife" en player
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player1":
		body._loseLife(position.x) # Llama a la función _loseLife() de Player1 
								   # Pasando la "posicion.x" del enemigo
