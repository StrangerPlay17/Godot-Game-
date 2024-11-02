extends Area2D
var player1 = false
var player2 = false

func _on_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player1": # Valida si fue el player el que se cayo del mapa <-
		print("Se ha caido el player1")
		player1 = true
	if body.get_name() == "Player2": # Valida si fue el player el que se cayo del mapa <-
		print("Se ha caido el player2")
		player2 = true
	if player1 == true and player2 == true: # Valida si ambos ya se cayeron del mapa 
		print("Ambos jugadores se encuentran caidos")
		player1 = false
		player2 = false
		call_deferred("reload_scene")  # Llama a la función de recarga de la escena

# Función para recargar la escena
func reload_scene() -> void: # Carga una nueva escena 
	#get_tree().change_scene_to_file("res://menu.tscn")
	get_tree().reload_current_scene()
