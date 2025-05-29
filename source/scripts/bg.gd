extends Sprite2D

@export var SPEED: float = 20

var noise: FastNoiseLite = texture.noise

func _process(delta: float) -> void:
	noise.offset += Vector3(SPEED*delta, SPEED*delta, 0)
