extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if (body.get_name() == "Player1") || (body.get_name() == "Player2"): # Valida si fue el player el que se cayo del mapa <-
		print(body.get_name(), " abrio")
		DataDoors.is_open = true #Cambia variable global para abrir puerta
		$AudioStreamPlayer.play()  # Llama al método play() para reproducir el audio
		await get_tree().create_timer(0.1).timeout  # Tiempo de 0.1seg antes de destruir
		queue_free()
	
	pass # Replace with function body.