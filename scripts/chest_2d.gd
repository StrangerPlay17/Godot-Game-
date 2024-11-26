extends Area2D

@warning_ignore("unused_signal")
signal chestCollected 
@onready var animationPlayer = $AnimationPlayer
var collected = true

func _ready():
	add_to_group("chests")  # Agrega el chest a un grupo "chest"

func _on_body_entered(body: Node2D) -> void:  # Función al tocar el chest
	if body.get_name() == "Player1" or body.get_name() == "Player2": # Valida si el chest fue tocada por el jugador 1 o 2
		if collected:
			$AudioStreamPlayer.play()  # Llama al método play() para reproducir el audio
			$AnimationPlayer.play("Chest") # Animacion del chest
			$Gem2D.visible = true  # Activa el sprite Gem2D para que sea visible
			collected = false # Evita que el cofre siga tomandose por mas de una vez
			await get_tree().create_timer(1.8).timeout  # Tiempo de 0.1seg antes de destruir la moneda
			emit_signal("chestCollected")  # Envía señal de recolección de chest
			queue_free()  # Elimina el chest de la escena
