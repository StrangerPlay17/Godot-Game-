# checkpoint.gd
extends Area2D

#señal que se emite cuando se alcanza el cheackpoint
signal checkpoint_reached(player, position)
# Variable exportada para definir posición de checkpoint
@export var checkpoint_position: Vector2
# Variable para rastrear si el checkpoint está activo
var is_active = false

# Se ejecuta cuando el nodo se inicializa
func _ready():
	# Conectar la señal body_entered al método correspondiente
	body_entered.connect(_on_body_entered)
	 # Imprime la posición global del checkpoint
	print("Checkpoint inicializado en posición: ", global_position)
	# Si no se definió posición, usa la posición global
	if checkpoint_position == Vector2.ZERO:
		checkpoint_position = global_position
		print("Checkpoint position actualizada a: ", checkpoint_position)
		
	# Imprime estados de monitoreo (para depuración)
	print("Monitoring: ", monitoring)
	print("Monitorable: ", monitorable)
	
# Método llamado cuando un cuerpo entra al área
func _on_body_entered(body: Node2D) -> void:
	# Imprime el nombre del cuerpo que colisionó
	print("COLISIÓN DETECTADA con: ", body.name)
	
	
	# Verifica si el cuerpo está en los grupos correctos
	if body.is_in_group("player1") or body.is_in_group("player2"):
		print(body.name + " detectado en checkpoint!")
		# Emitir la señal con los parámetros necesarios
		checkpoint_reached.emit(body, checkpoint_position)
		is_active = true # marca el checkpoint activado
	else:
		print("Objeto no reconocido como jugador")


# Método redundante para manejar checkpoint alcanzado
func _on_checkpoint_reached(player: Node2D, new_position: Vector2) -> void:
	# Verifica si el jugador tiene método para actualizar checkpoint
	if player.has_method("update_checkpoint"):
		player.update_checkpoint(new_position)
		print("Checkpoint actualizado para " + player.name)
	else:
		# Lanza un error si no existe el método
		push_error("El jugador no tiene el método update_checkpoint")
