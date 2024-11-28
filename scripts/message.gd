extends Area2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if DataDoors.is_open_message == true:
		show()
	else:
		hide()
	pass
