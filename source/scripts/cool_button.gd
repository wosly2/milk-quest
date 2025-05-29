extends Button


@export var desc: String
@export var sound: AudioStreamMP3

var follow_mouse := false

func _ready() -> void:
	%Desc.text = desc
	$Click.stream = sound

func _process(delta: float) -> void:
	if follow_mouse:
		$DescPoint.global_position = get_global_mouse_position()

func update_desc(txt) -> void:
	desc = txt
	%Desc.text = desc

func _on_button_down() -> void:
	$Click.play()


func _on_mouse_entered() -> void:
	%Desc.show()
	follow_mouse = true


func _on_mouse_exited() -> void:
	%Desc.hide()
	follow_mouse = false
