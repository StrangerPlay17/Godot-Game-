extends Area2D

func _on_body_entered(body: Node2D) -> void:  # Función al tocar la bandera
	if body.get_name() == "Player1" or body.get_name() == "Player2": # Valida si la moneda fue tocada por el jugador 1 o 2
		$AudioStreamPlayer.play()  # Llama al método play() para reproducir el audio
		await get_tree().create_timer(1.3).timeout  # Tiempo de 0.1seg antes de destruir la moneda
		queue_free()  # Elimina la moneda de la escena
		#Muestra la escena de victoria 
		get_tree().change_scene_to_file("res://scenes/victory.tscn")
