extends Node2D
@onready var animationPlayer = $AnimationPlayer


func _on_bomb_2d_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player1" or body.get_name() == "Player2":
		$AudioStreamPlayer.play()
		$AnimationPlayer.play("Bomb") # Animacion de la bomba
		await get_tree().create_timer(2.1).timeout  # Tiempo de 0.1seg antes de destruir la moneda
		body._loseLife(position.x) # Llama a la funcion _loseLife() de player_2d <-
								   # con "position.x" del objeto que hizo daño
		pass
		queue_free()  # Elimina la bomba de la escena
