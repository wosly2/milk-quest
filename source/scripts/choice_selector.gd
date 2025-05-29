extends Node2D


# i have so many fucking scripts


func _ready() -> void:
	self.hide()

func assign_attacks(card: CardResource):
	%Attack1.text = card.attack_1.name + ": -" + str(card.attack_1.milk_cost) + " Mk"
	%Attack1.update_desc(card.attack_1.desc)
	%Attack2.text = card.attack_2.name + ": -" + str(card.attack_2.milk_cost) + " Mk"
	%Attack2.update_desc(card.attack_2.desc)

func cripple() -> void:
	$Panel/VBoxContainer/HBoxContainer/Buff.disabled = true
	$Panel/VBoxContainer/HBoxContainer/Debuff.disabled = true
	$Panel/VBoxContainer/HBoxContainer2/Defend.disabled = true
	%Attack1.disabled = true
	%Attack2.disabled = true

func give_them_jesus() -> void:
	$Panel/VBoxContainer/HBoxContainer/Buff.disabled = false
	$Panel/VBoxContainer/HBoxContainer/Debuff.disabled = false
	$Panel/VBoxContainer/HBoxContainer2/Defend.disabled = false
	%Attack1.disabled = false
	%Attack2.disabled = false
