class_name Card extends Node2D

@export var res: CardResource
@export var p1_scale: Vector2 = Vector2(3, 3)
@export var p2_scale: Vector2 = Vector2(2, 2)
@onready var does_hover: bool = false

@onready var text: Node2D = %Text
@onready var card_back: Sprite2D = $Sprites/CardBack
@onready var card_face: Sprite2D = $Sprites/CardFace

signal picked(resource: CardResource)

func update_card(resource: CardResource) -> void:
	res = resource
	%Title.text = res.name
	%MaxHealth.text = str(res.max_health)+" HP"
	%Weakness.text = res.TypeNames[res.weakness]
	%Milk.text = str(res.milk_cost)+" Mk"
	%MilkAttack1.text = str(res.attack_1.milk_cost)+" Mk"
	%MilkAttack2.text = str(res.attack_2.milk_cost)+" Mk"
	%Attack1.text = res.attack_1.name
	%Attack2.text = res.attack_2.name
	%Type.text = res.TypeNames[res.card_type]
	%AttackDesc1.text = res.attack_1.desc
	%AttackDesc2.text = res.attack_2.desc
	$Sprites/CardBack.texture = res.image
	$Sprites/CardFace.texture = res.face_image
	$Clicky.update_desc(res.desc)
	
	if res.card_type == CardResource.CardType.DemoName:
		$Sprites/CardFace.scale /= 3

func _ready() -> void:
	$Clicky.hide()
	if res != null:
		update_card(res)
		#print("yo i just updated myself fool")
	else:
		#print("aint got no card resource homeboy")
		pass
		


func _on_area_2d_mouse_entered() -> void:
	if !does_hover: return
	scale += Vector2(0.3, 0.3)
	$Clicky.show()


func _on_area_2d_mouse_exited() -> void:
	if !does_hover: return
	scale -= Vector2(0.3, 0.3)
	$Clicky.hide()


func _on_clicky_pressed() -> void:
	picked.emit(res)
