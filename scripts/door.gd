extends Area2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if DataDoors.is_open == true: #Si la bandera global es true, quitara la puerta
		queue_free()
	pass