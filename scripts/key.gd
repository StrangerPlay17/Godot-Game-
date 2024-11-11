extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player1": # Valida si fue el player el que se cayo del mapa <-
		print("Player1 abrio")

	if body.get_name() == "Player2": # Valida si fue el player el que se cayo del mapa <-
		print("Player2 abrio")
	
	DataDoors.is_open = true
	queue_free()
	
	pass # Replace with function body.
