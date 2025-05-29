extends Node2D

@export var player_num: int = 1

var flag_updated := true
var update_to: PlayerData

func _ready() -> void:
	if player_num == 1:
		%PlayerNum.text = "PLAYER 1"
	else:
		%PlayerNum.text = "PLAYER 2"

func _process(delta: float) -> void:
	if !flag_updated:
		var x := 0
		if %CardName != null and update_to.main_card != null:
			%CardName.text = update_to.main_card.name
			x += 1
		if %HP != null:
			%HP.value = update_to.hp
			x += 1
		if %Milk != null:
			%Milk.value = update_to.milk
			x += 1
		if x == 3:
			flag_updated = true

func update(pd: PlayerData) -> void:
	flag_updated = false
	update_to = pd
	
