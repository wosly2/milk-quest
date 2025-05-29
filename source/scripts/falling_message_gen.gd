class_name FMG extends Node

@export var FMGPrefab: PackedScene

func create_and_fall(text: String, pos: Vector2, end_pos: Vector2, speed: float) -> void:
	var new_fmg := FMGPrefab.instantiate() as Label
	self.add_child(new_fmg)
	new_fmg.global_position = pos
	new_fmg.text = text
	new_fmg.global_position.x -= new_fmg.get_rect().size.x / 2
	
	var tween := get_tree().create_tween()
	tween.parallel().tween_property(new_fmg, "global_position", end_pos-Vector2(new_fmg.get_rect().size.x / 2, 0), speed)
	tween.parallel().tween_property(new_fmg, "modulate", Color(1, 1, 1, 0), speed)
	
	tween.tween_callback( func():
		if new_fmg:
			new_fmg.queue_free()
	)
