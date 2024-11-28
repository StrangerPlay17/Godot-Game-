# checkpoint_container.gd

extends Node2D

func _ready():
	# Imprime un mensaje de inicialización del contenedor
	print("CheckpointContainer inicializado")
	
	#Variable para contar los checkpoints
	var count = 0
	
	for checkpoint in get_children():
		#verifica si es un hijo checkpoint
		if checkpoint is Area2D:
			#incrementa el contador de checkpoint
			count += 1
			# si hay un posible error la conexion de señal aparece incorrecta
			checkpoint.connect("checkpoint_reached", _on_checkpoint_reached)
	# numero de checkpoint conectados
	print("Número de checkpoints conectados: ", count)

# Funcion para manejar cuando se alcanza el checkpoint 
func _on_checkpoint_reached(player, checkpoint_position):
	# Señal del checkpoint resivida
	print("Señal de checkpoint recibida")
	#verifica si el jugador tiene el metodo para actualizar el checkpoint
	if player.has_method("update_checkpoint"):
		#actualiza el chechpoint
		print("Actualizando checkpoint para: ", player.name)
		#llama al metodo para actualizarlo
		player.update_checkpoint(checkpoint_position)
	else:
		#error al actualizar el checkpoint
		print("Error: El jugador no tiene el método update_checkpoint")
