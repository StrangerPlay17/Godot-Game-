extends CharacterBody2D

const moveSpeed = 25.0
const maxSpeed = 50.0
const jumpHeight = -300.0
const gravity = 15.0
var lifes = 3 

@onready var sprite = $Sprite2D # Orientación del jugador (izquierda o derecha)
@onready var animationPlayer = $AnimationPlayer # Animaciones del jugador (quieto y caminando)

func _physics_process(_delta: float) -> void:
	velocity.y += gravity # Aplica la gravedad en el eje y
	
	var friction = false
	
	# INPUT EN CASO DE QUE EL JUGADOR PRESIONE LA TECLA "DERECHA" PARA CAMINAR
	if Input.is_action_pressed("ui_right"):
		sprite.flip_h = true # Cambia la orientación del personaje hacia la "derecha"
		animationPlayer.play("Walk")  # Animación de jugador caminando  
		velocity.x = min(velocity.x + moveSpeed, maxSpeed) # Camina hacia el eje +x 
	
	# INPUT EN CASO DE QUE EL JUGADOR PRESIONE LA TECLA "IZQUIERDA" PARA CAMINAR
	elif Input.is_action_pressed("ui_left"):
		sprite.flip_h = false   # Cambia la orientación del personaje hacia la "izquierda"
		animationPlayer.play("Walk") # Animación de jugador caminando 
		velocity.x = max(velocity.x - moveSpeed, -maxSpeed) # Camina hacia el eje -x 
	
	# INPUT EN CASO DE QUE EL JUGADOR ESTÉ "QUIETO"
	else:
		animationPlayer.play("Idle") # Animación de jugador quieto 
		friction = true # Mantiene quieto al jugador
	
	if is_on_floor():
		if Input.is_action_pressed("ui_accept") or Input.is_action_pressed("ui_up"):
			velocity.y = jumpHeight # Hace el salto en el eje +y 
		
		if friction == true: # Si el jugador está quieto 
			velocity.x = lerp(velocity.x, 0.0, 0.5) # Suavizado entre el no movimiento de un lado a otro 
	
	else:
		if friction == true: # Si el jugador está quieto 
			velocity.x = lerp(velocity.x, 0.0, 0.01) # Suavizado entre el no movimiento de un lado a otro 
	
	# Aplica el movimiento usando la propiedad `velocity` directamente
	move_and_slide()

# Funcion en caso de morir en puas <-
func _on_spikes_body_entered(body):
	if body.get_name() == "Player1": # Valida si fue el player el que se cayo del mapa <-
		print("Se ha pinchao el player1")
		body._loseLife(position.x)

# Funcion que baja la vida del jugador
func _loseLife(enemyposx):
	print("El player1 ha perdido 1 vida")
	# El jugador recibe un "emepujon" por el daño recibido 
	if position.x < enemyposx: # Si el player esta a la izquierda del enemigo
		velocity.x = -400 # Enpujon del player en x
		velocity.y = -100 # Enpujon del player en y
	else:  #Si el player esta a la derecha del enemigo 
		velocity.x = 400
		velocity.y = -100
	lifes -= 1 # Se pierde una vida
	print("Vidas restantes: "+str(lifes))
	# Encuentra el nodo "CanvasLayer" desde el nodo raíz de la escena
	var canvas_layer = get_tree().root.get_node("Game/CanvasLayer")
	canvas_layer.handleHearts(lifes) # Llama a la función "handlehearts" con la cantidad de vidas actuales <-
	
	if lifes <= 0: # Si las vidas del jugador se agotan
		call_deferred("reload_scene")  # Llama a la función de recarga de la escena

# Función para recargar la escena
func reload_scene() -> void: # Carga una nueva escena 
	get_tree().change_scene_to_file("res://scenes/game over.tscn")
	#get_tree().reload_current_scene()
	

'''
		
		
const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
'''
