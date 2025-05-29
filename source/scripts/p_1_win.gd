extends Node2D

func _ready() -> void:
	$Fade.fade_in()

func _on_cool_button_pressed() -> void:
	print("hi")
	$Fade.fade_out()
	await $Fade.finished
	get_tree().change_scene_to_file("res://scenes/title.tscn")
