extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if (body.get_name() == "Player1") || (body.get_name() == "Player2"): # Valida si fue el player el que se cayo del mapa <-
		print(body.get_name(), " entro al mensaje")
		DataDoors.is_open_message = true #Cambia variable global para mostrar mensaje
	pass


func _on_body_exited(body: Node2D) -> void:
	if (body.get_name() == "Player1") || (body.get_name() == "Player2"): # Valida si fue el player el que se cayo del mapa <-
		print(body.get_name(), " salio al mensaje")
		DataDoors.is_open_message = false #Cambia variable global para cerrar mensaje
	pass
