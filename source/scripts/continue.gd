extends Button

@export var load: PackedScene
@export var other_load: PackedScene
@export var load_other: bool

func _on_pressed() -> void:
	$"../Fade".fade_out()
	await $"../Fade".finished
	if load_other:
		get_tree().change_scene_to_packed(other_load)
	else:
		get_tree().change_scene_to_packed(load)
	
func _ready() -> void:
	await get_tree().create_timer(.5).timeout
	$"../Fade".fade_in()
	
