extends CharacterBody2D

const moveSpeed = 25.0
const maxSpeed = 50.0
const jumpHeight = -300.0
const gravity = 9.0
var lifes = 3
signal out_of_lives  

@onready var sprite = $Sprite2D # Orientación del jugador (izquierda o derecha)
@onready var animationPlayer = $AnimationPlayer # Animaciones del jugador (quieto y caminando)

#Variable de estado para controlar si el jugador está muerto
var is_dead = false

func _ready():
	add_to_group("player2")  # Agrega al jugador a un grupo "player2"

func _physics_process(_delta: float) -> void:
	if is_dead:
		return  # Si el jugador está muerto, no procesar el movimiento

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
			$JumpSound.play()
			velocity.y = jumpHeight # Hace el salto en el eje +y 
		
		if friction == true: # Si el jugador está quieto 
			velocity.x = lerp(velocity.x, 0.0, 0.5) # Suavizado entre el no movimiento de un lado a otro 
	
	else:
		if friction == true: # Si el jugador está quieto 
			velocity.x = lerp(velocity.x, 0.0, 0.01) # Suavizado entre el no movimiento de un lado a otro 
	
	# Aplica el movimiento usando la propiedad `velocity` directamente
	move_and_slide()

func _loseLife(enemyposx):
	print("El player2 ha perdido 1 vida")
	# El jugador recibe un "emepujon" por el daño recibido 
	if position.x < enemyposx: # Si el player esta a la izquierda del enemigo
		velocity.x = -400 # Enpujon del player en x
		velocity.y = -100 # Enpujon del player en y
	else:  #Si el player esta a la derecha del enemigo 
		velocity.x = 400
		velocity.y = -100
	lifes -= 1 # Se pierde una vida
	$LifeSound.play()
	print("Vidas restantes: "+str(lifes))
	# Encuentra el nodo "CanvasLayer" desde el nodo raíz de la escena
	var canvas_layer = get_tree().root.get_node("GameTutorial/CanvasLayer")
	if canvas_layer == null:
		canvas_layer = get_tree().root.get_node("Game/CanvasLayer")
	canvas_layer.handleHeartsPlayer2(lifes) # Llama a la función "handlehearts" con la cantidad de vidas actuales <-
	if lifes <= 0: # Si las vidas del jugador se agotan
		is_dead = true  # Marca al jugador como muerto
		animationPlayer.play("Dead")  # Reproduce la animación de muerte
		$DeathSound.play()
		$CollisionShape2D.disabled = true  # Reemplaza CollisionShape2D con el nombre de tu nodo de colisión
		await get_tree().create_timer(2.3).timeout  # Demora de la animación de muerte
		emit_signal("out_of_lives", self)  # Notifica que el jugador se quedó sin vidas
		#call_deferred("reload_scene")  # Llama a la función de recarga de la escena


func reload_scene() -> void: # Carga una nueva escena 
	get_tree().change_scene_to_file("res://scenes/game over.tscn")
	#get_tree().reload_current_scene()


func _on_spikes_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player2": # Valida si fue el player el que se cayo del mapa <-
		print("Se ha pinchao el player2")
		body._loseLife(position.x) # Replace with function body. # Replace with function body.
