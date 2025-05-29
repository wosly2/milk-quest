class_name PlayerData extends Object

const HAND_SIZE: int = 5
const DECK_SIZE: int = 59
const STARTING_MILK: int = 100
const STARTING_HP: int = 100

var name: String

var hand: Array[CardResource]
var main_card: CardResource
var discard: Array[CardResource]
var deck: Array[CardResource]

var milk: int = STARTING_MILK 
var hp: int = STARTING_HP
var points: int = 0

var damage_give_mult := 1.0
var damage_take_mult := 1.0

func update(cr: CardResource):
	main_card = cr
	hp = cr.max_health
	milk = STARTING_MILK - cr.milk_cost
