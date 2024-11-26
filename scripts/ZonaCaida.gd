extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player1":  # Valida si fue el player1 quien cayó
		print("Se ha caído el player1")
		for _i in range(body.lifes):  # Reduce las vidas restantes a 0
			body._loseLife(position.x)

	elif body.get_name() == "Player2":  # Valida si fue el player2 quien cayó
		print("Se ha caído el player2")
		for _i in range(body.lifes):  # Reduce las vidas restantes a 0
			body._loseLife(position.x)

# Función para recargar la escena
func reload_scene() -> void: # Carga una nueva escena 
	#get_tree().change_scene_to_file("res://menu.tscn")
	get_tree().reload_current_scene()
