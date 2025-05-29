extends Label


func _ready() -> void:
	self.hide()
	self.set_anchors_preset(Control.PRESET_CENTER)
	self.set_pivot_offset(self.get_combined_minimum_size() / 2)

func explode() -> void:
	self.show()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(1000, 200), 2)
	tween.tween_callback(func():
		self.queue_free()
	)
	tween.is_queued_for_deletion()
