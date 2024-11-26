extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player1":
		body._loseLife(position.x) # Llama a la funcion _loseLife() de player_2d <-
								   # con "position.x" del objeto que hizo daño
		pass
	if body.get_name() == "Player2":
		body._loseLife(position.x) # Llama a la funcion _loseLife() de player2_2d <-
								   # con "position.x" del objeto que hizo daño
		pass
