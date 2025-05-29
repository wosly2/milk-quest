extends MeshInstance3D

# observing cubes OBSERVE the players

@export var ROT_SPEED: float = 2
@export var PULSE_MAG: float = 0.2
@export var PULSE_SPEED: float = 1.0

var pulse_time: float = 0.0

func _process(delta: float) -> void:
	rotate_x(ROT_SPEED * delta)
	rotate_y(ROT_SPEED * delta)
	rotate_z(ROT_SPEED * delta)
	
	pulse_time += delta
	var pulse = 1.0 + sin(pulse_time * PULSE_SPEED * PI * 2) * PULSE_MAG
	scale = Vector3.ONE * pulse
