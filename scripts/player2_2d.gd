#player2_2d.gd

extends CharacterBody2D

@warning_ignore("unused_signal")
signal out_of_lives  

const moveSpeed = 25.0
const maxSpeed = 50.0
const jumpHeight = -300.0
const gravity = 09.0
var lifes = 3


@onready var sprite = $Sprite2D # Orientación del jugador (izquierda o derecha)
@onready var animationPlayer = $AnimationPlayer # Animaciones del jugador (quieto y caminando)

#Variable de estado para controlar si el jugador está muerto
var is_dead = false

#Variable para guardar la posición del último checkpoint
var last_checkpoint_position: Vector2

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
		# Buscar el CanvasLayer de manera más segura
	var canvas_layer = null
	# Intenta diferentes rutas posibles
	var possible_paths = [
		"GameTutorial/CanvasLayer",
		"Game/CanvasLayer",
		"../CanvasLayer",  # Busca en el padre
		"/root/GameTutorial/CanvasLayer",
		"/root/Game/CanvasLayer", 
	]
	
	for path in possible_paths:
		if get_node_or_null(path):
			canvas_layer = get_node(path)
			break
	
	if canvas_layer:
		if get_groups().has("player1"):
			canvas_layer.handleHeartsPlayer1(lifes)
		else:
			canvas_layer.handleHeartsPlayer2(lifes)
	else:
		print("ERROR: No se pudo encontrar el CanvasLayer")
	
	if lifes <= 0:
		is_dead = true
		animationPlayer.play("Dead")
		$DeathSound.play()
		#$CollisionShape2D.disabled = true
		$CollisionShape2D.set_deferred("disabled", true)
		await get_tree().create_timer(2.3).timeout
		if last_checkpoint_position:
			# Si hay un checkpoint guardado, reaparecer en el checkpoint
			respawn_at_checkpoint()
		else:
			# Si no hay checkpoint, emitir señal de sin vidas y cargar pantalla de Game Over
			emit_signal("out_of_lives", self)

#Funcion para guardar la posicion del ultimo checkpoint
func update_checkpoint(new_position: Vector2) -> void:
	 # Guarda la nueva posición del checkpoint
	#last_checkpoint_position = new_position
	# Busca los nodos de ambos jugadores
	var player1 = get_node_or_null("/root/Game/Player1")
	var player2 = get_node_or_null("/root/Game/Player2")
	
	player1.last_checkpoint_position = new_position
	player2.last_checkpoint_position = new_position
	 # Imprime un mensaje de confirmación con la posición
	print("Checkpoint actualizado: ", last_checkpoint_position)
	
# Función para reaparecer en el último checkpoint
func respawn_at_checkpoint():
	# Imprime la posición donde va a reaparecer
	print("Reapareciendo en: ", last_checkpoint_position)
	
	# Verifica si hay una posición de checkpoint guardada
	if last_checkpoint_position != Vector2.ZERO:
		# Busca los nodos de ambos jugadores
		var player1 = get_node_or_null("/root/Game/Player1")
		var player2 = get_node_or_null("/root/Game/Player2")
		
		# Array para almacenar los jugadores
		var players = []
		
		# Agrega los jugadores al array si existen
		if player1:
			players.append(player1)
		if player2:
			players.append(player2)
		
		# Itera sobre cada jugador para reaparecer
		for player in players:	
			
			# Desactiva temporalmente la física
			player.set_physics_process(false)
			
			# Resetea propiedades del jugador
			player.velocity = Vector2.ZERO
			player.is_dead = false
			
			# Reactiva la colisión del jugador
			player.get_node("CollisionShape2D").disabled = false
			
			# Teletransporta al jugador al checkpoint
			player.global_position = last_checkpoint_position
			
			# Restablece las vidas del jugador
			player.lifes = 3
			
			# Cambia a la animación de caminar al reaparecer
			player.animationPlayer.play("Walk")
			
			# Reactiva la física después de un breve momento
			await get_tree().create_timer(0.1).timeout
			player.set_physics_process(true)
			
		# Busca el CanvasLayer
		var canvas_layer = null
		var possible_paths = [
			"GameTutorial/CanvasLayer",
			"Game/CanvasLayer",
			"../CanvasLayer",
			"/root/GameTutorial/CanvasLayer",
			"/root/Game/CanvasLayer", 
		]
		
		for path in possible_paths:
			if get_node_or_null(path):
				canvas_layer = get_node(path)
				break
		
		# Restaura los corazones de ambos jugadores
		if canvas_layer:
			# Verifica si ambos jugadores están vivos (tienen vidas > 0)
			var player1_alive = player1 and player1.lifes > 0
			var player2_alive = player2 and player2.lifes > 0
			
			# Si ambos jugadores están vivos
			if player1_alive and player2_alive:
				# Restaura los corazones y actualiza la interfaz de ambos jugadores
				canvas_layer.restoreHearts("player1")
				canvas_layer.handleHeartsPlayer1(player1.lifes)
			
				canvas_layer.restoreHearts("player2")
				canvas_layer.handleHeartsPlayer2(player2.lifes)
			
				print("Jugadores reaparecieron en el checkpoint: ", last_checkpoint_position)
			else:
				 # Si alguno de los jugadores no está vivo
				if player1_alive:
					canvas_layer.restoreHearts("player1")
					canvas_layer.handleHeartsPlayer1(player1.lifes)
					print("Solo Player 1 restaurado en el checkpoint")
				
				if player2_alive:
					canvas_layer.restoreHearts("player2")
					canvas_layer.handleHeartsPlayer2(player2.lifes)
					print("Solo Player 2 restaurado en el checkpoint")
				
		else:
			print("ERROR: No se pudo encontrar el CanvasLayer")
	else:
		print("Error: No hay posición de checkpoint guardada")
	
func reload_scene() -> void: # Carga una nueva escena 
	get_tree().change_scene_to_file("res://scenes/game over.tscn")
	#get_tree().reload_current_scene()


func _on_spikes_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player2": # Valida si fue el player el que se cayo del mapa <-
		print("Se ha pinchao el player2")
		body._loseLife(position.x) # Replace with function body. # Replace with function body.
