extends Control

func _ready() -> void:
	$ColorRect/VBoxContainer/Play.grab_focus()
	$AnimationPlayer.play("Move") # Animation of Chicken
	$AnimationPlayer2.play("Move") # Animation of Slime
	

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")

func _on_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://gameTutorial.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
