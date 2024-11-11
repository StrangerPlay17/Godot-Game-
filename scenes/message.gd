extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if DataDoors.is_open_message == true:
		show()
	else:
		print(DataDoors.is_open_message)
		hide()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if DataDoors.is_open_message == true:
		show()
	else:
		hide()
	pass
