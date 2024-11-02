extends Area2D

signal coinCollected 

func _ready():
	add_to_group("coins")  # Agrega la moneda a un grupo "coins"

func _on_body_entered(body: Node2D) -> void:  # Función al tocar la moneda
	if body.get_name() == "Player1" or body.get_name() == "Player2": # Valida si la moneda fue tocada por el jugador 1 o 2
		$AudioStreamPlayer.play()  # Llama al método play() para reproducir el audio
		await get_tree().create_timer(0.1).timeout  # Tiempo de 0.1seg antes de destruir la moneda
		emit_signal("coinCollected")  # Envía señal de recolección de moneda
		queue_free()  # Elimina la moneda de la escena
