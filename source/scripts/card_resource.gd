class_name CardResource extends Resource

enum CardType {
	Milk,
	Grain,
	Metal,
	Porcelain,
	Odd,
	DemoName,
	DemoAttackName,
}

const TypeNames: Dictionary = {
	CardType.Milk: "Milk",
	CardType.Grain: "Grain",
	CardType.Metal: "Metal",
	CardType.Porcelain: "Porcelain",
	CardType.Odd: "Odd",
	CardType.DemoName: "Type",
	CardType.DemoAttackName: "Weakness Type",
}

@export var name: String
@export var max_health: int
@export var weakness: CardType
@export var milk_cost: int
@export var attack_1: AttackResource
@export var attack_2: AttackResource
@export var card_type: CardType
@export var desc: String
@export var image: Texture2D
@export var face_image: Texture2D
