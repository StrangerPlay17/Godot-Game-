extends Node2D

@onready var player1 = $Player1
@onready var player2 = $Player2
@onready var shared_camera = $SharedCamera
var opposing_player
var player_eliminado = false

# Ajusta estos valores según lo necesario
var min_zoom = Vector2(4.4, 4.4)  # Zoom mínimo para la cámara
var max_zoom = Vector2(15, 15)  # Zoom máximo para la cámara
var max_distance = 600  # Máxima distancia entre los jugadores antes de ajustar el zoom

func _ready():
	
	# Conecta los checkpoints a la señal `checkpoint_reached`
	for checkpoint in get_tree().get_nodes_in_group("checkpoints"):
		checkpoint.connect("checkpoint_reached", Callable(self, "_on_checkpoint_reached"))
	# Conecta la señal de vida agotada para ambos jugadores
	for child in get_tree().get_nodes_in_group("player1"):
		child.connect("out_of_lives", Callable(self, "_on_player_out_of_lives"))
	for child in get_tree().get_nodes_in_group("player2"):
		child.connect("out_of_lives", Callable(self, "_on_player_out_of_lives"))

func _on_checkpoint_reached(player, new_position):
	if player.is_in_group("player1"):
		player.update_checkpoint(new_position)
	elif player.is_in_group("player2"):
		player.update_checkpoint(new_position)

func _on_player_out_of_lives(player):
	# Verifica si uno de los dos jugadores ya ha muerto
	if player_eliminado: # Si ya hay un player eliminado
		restart_game()  # Reinicia el juego al morir el segundo jugador
	else: 
		if player == player1:
			opposing_player = player2
		elif player == player2:
			opposing_player = player1
		# Activa la cámara del jugador contrario al morir el otro jugador
		if opposing_player:
			var player_camera = opposing_player.get_node("Camera2D")
			if player_camera:
				player_camera.make_current()  # Hace que esta cámara sea la activa

		# Activa la band de que ya ha sido eliminado 1 jugador
		player_eliminado = true
		player.queue_free() # Elimina el nodo del mapa

func _process(_delta: float) -> void:
	if !player_eliminado: # Si no hay un player eliminado, la camara es compartida
		update_camera_position()
		update_camera_zoom()
		
func update_camera_position() -> void:
	# Calcula el punto medio entre los dos jugadores
	var midpoint = (player1.global_position + player2.global_position) / 2
	# Mueve la cámara al punto medio
	shared_camera.position = midpoint

func update_camera_zoom() -> void:
	# Calcula la distancia entre los jugadores
	var distance = player1.global_position.distance_to(player2.global_position)
	# Calcula un factor de zoom basado en la distancia (interpolación lineal)
	var zoom_factor = clamp(distance / max_distance, min_zoom.x, max_zoom.x)
	# Aplica el zoom a la cámara
	shared_camera.zoom = Vector2(zoom_factor, zoom_factor)

func restart_game() -> void:
	get_tree().change_scene_to_file("res://scenes/game over.tscn")  # Reinicia la escena actual
