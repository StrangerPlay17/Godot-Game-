extends CharacterBody2D

const moveSpeed = 25.0
const maxSpeed = 50.0
const jumpHeight = -300.0
const gravity = 9.0

@onready var sprite = $Sprite2D # Orientación del jugador (izquierda o derecha)
@onready var animationPlayer = $AnimationPlayer # Animaciones del jugador (quieto y caminando)

func _physics_process(_delta: float) -> void:
	velocity.y += gravity # Aplica la gravedad en el eje y
	
	var friction = false
	
	# INPUT EN CASO DE QUE EL JUGADOR PRESIONE LA TECLA "DERECHA" PARA CAMINAR
	if Input.is_key_pressed(Key.KEY_D):
		sprite.flip_h = true # Cambia la orientación del personaje hacia la "derecha"
		animationPlayer.play("Walk")  # Animación de jugador caminando  
		velocity.x = min(velocity.x + moveSpeed, maxSpeed) # Camina hacia el eje +x 
	
	# INPUT EN CASO DE QUE EL JUGADOR PRESIONE LA TECLA "IZQUIERDA" PARA CAMINAR
	elif Input.is_key_pressed(Key.KEY_A):
		sprite.flip_h = false   # Cambia la orientación del personaje hacia la "izquierda"
		animationPlayer.play("Walk") # Animación de jugador caminando 
		velocity.x = max(velocity.x - moveSpeed, -maxSpeed) # Camina hacia el eje -x 
	
	# INPUT EN CASO DE QUE EL JUGADOR ESTÉ "QUIETO"
	else:
		animationPlayer.play("Idle") # Animación de jugador quieto 
		friction = true # Mantiene quieto al jugador
	
	if is_on_floor():
		if Input.is_action_pressed("ui_accept") or Input.is_key_pressed(Key.KEY_W):
			velocity.y = jumpHeight # Hace el salto en el eje +y 
		
		if friction == true: # Si el jugador está quieto 
			velocity.x = lerp(velocity.x, 0.0, 0.5) # Suavizado entre el no movimiento de un lado a otro 
	
	else:
		if friction == true: # Si el jugador está quieto 
			velocity.x = lerp(velocity.x, 0.0, 0.01) # Suavizado entre el no movimiento de un lado a otro 
	
	# Aplica el movimiento usando la propiedad `velocity` directamente
	move_and_slide()
