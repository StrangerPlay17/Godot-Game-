extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player": # Valida si fue el player el que se cayo del mapa <-
		print("Se ha caido")
		call_deferred("reload_scene")  # Llama a la función de recarga de la escena

# Función para recargar la escena
func reload_scene() -> void: # Carga una nueva escena 
	get_tree().change_scene_to_file("res://menu.tscn")
