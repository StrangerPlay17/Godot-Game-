extends Area2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player1": # Valida si fue el player el que se cayo del mapa <-
		print("Player1 entro al mensaje")

	if body.get_name() == "Player2": # Valida si fue el player el que se cayo del mapa <-
		print("Player2 entro al mensaje")
	
	DataDoors.is_open_message = true
	pass # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	if body.get_name() == "Player1": # Valida si fue el player el que se cayo del mapa <-
		print("Player1 salio del mensaje")

	if body.get_name() == "Player2": # Valida si fue el player el que se cayo del mapa <-
		print("Player2 salio del mensaje")
	
	DataDoors.is_open_message = false
	pass # Replace with function body.
