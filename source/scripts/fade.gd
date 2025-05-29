extends Node2D

enum Fade {
	IN,
	OUT,
}

@export var fade_type: Fade = Fade.OUT

var fading: bool = false
var fade_dir: float = 0

signal finished

func _ready() -> void:
	if fade_type == Fade.OUT:
		hide()
		$Block.modulate[3] = 0
		
	else:
		show()
		$Block.modulate[3] = 1

func _process(delta: float) -> void:
	if fading:
		show()
		$Block.modulate[3] += fade_dir * delta
		if fade_dir > 0 and $Block.modulate[3] >= 1:
			fade_dir = 0
			fading = false
			finished.emit()
		if fade_dir < 0 and $Block.modulate[3] <= 0:
			fade_dir = 0
			fading = false
			finished.emit()

func fade_out() -> void:
	fade_dir = 1
	fading = true

func fade_in() -> void:
	fade_dir = -1
	fading = true
