extends Area2D

signal coinCollected 

func _ready():
	add_to_group("coins")  # Agrega la moneda a un grupo "coins"

func _on_body_entered(body: Node2D) -> void:  # Función al tocar la moneda
	if body.get_name() == "Player": # Valida si la moneda fue tocada por el jugador <-
		emit_signal("coinCollected")  # Envía señal de recolección de moneda
		queue_free()  # Elimina la moneda de la escena
