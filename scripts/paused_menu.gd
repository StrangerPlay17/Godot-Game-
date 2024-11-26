extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false

# En escucha de una tecla
func _input(event): # Comprueba si el evento es la acción "pause" o la tecla "Q" en modo presionado
	if (event is InputEventKey and event.keycode == KEY_Q and event.is_pressed()):
		get_tree().paused = not get_tree().paused  # Alterna el estado de pausa
		visible = get_tree().paused # Vuelve visible el menu al estar pausado el juego
		if get_tree().paused:
			print("Juego en pausa")
		else:
			print("Juego reanudado")
	# Comprueba si el evento es la tecla "R"
	if (event is InputEventKey and event.keycode == KEY_R and event.is_pressed()):
		get_tree().reload_current_scene() # Reinicia el nivel con R
