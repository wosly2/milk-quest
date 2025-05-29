extends Sprite2D

var t = 0

func _physics_process(delta: float) -> void:
	position.x += 10*sin(deg_to_rad(t)) * delta
	position.y += 10*cos(deg_to_rad(t)) * delta
	
	if t >= 360:
		t = 0
	else:
		t += 1
	
