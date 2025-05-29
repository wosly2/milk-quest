class_name Main extends Node2D

@export_category("Card Prefab")
@export var CardPrefab: PackedScene

@export_category("Card Resources")
@export var CardRecs: Array[CardResource]

@export_category("Other")
@export var default_card_texture: Texture2D

@export_category("Win Scenes")
@export var p1_win: PackedScene
@export var p2_win: PackedScene



const CARD_WIDTH: int = 64
const HAND_RADIUS: int = 1000
const HAND_SPLAY_P1: float = 20
const HAND_SPLAY_P2: float = 10

var p1_data: PlayerData
# this data type stores way too much data
var p2_data: PlayerData
var player_one: int

var random_messages := [
	"You winning, son?",
	"Jolly good show!",
	"Hello from the random message daemon!",
	"Hmm. Looked like a blunder.",
	"Do you guys have one combined brain cell?",
	"Like my cubes?",
	"Mmm... Uranium!",
	"I'm not a splash text!",
	">B)",
	"Yo",
	"Gurt",
	"WOSLYCORP ADVERTISEMENT",
	"Dr. Breen says accept the new world order!",
	"Remember, possession of Choco Shmigs\nis a felony in 17 countries!\n-WOSLYCORP Legal",
	"Do NOT microwave the Fiesta Bowl.",
	"The Observing Cubes are frowning.",
	"Does anyone else hear a Geiger counter?",
	"gurg",
	"Lil Tecca!",
]

func maybe_whisper() -> void:
	if randf() < 0.00015:
		quick_msg(random_messages[randi() % random_messages.size()])

enum Mode {
	#INTRO,
	PICK,
	ATTACK,
	END
}

# useless unorganized flags dont touch
var player_one_picked := false
var mode_init := false

var gm: Mode = Mode.PICK # GAME MODE fsm type shit

func change_gm(mode: Mode) -> void:
	gm = mode
	mode_init = false

func _ready() -> void:
	$Fade.fade_in()
	
	p1_data = make_new_pd()
	%PlayerData.update(p1_data)
	p2_data = make_new_pd()
	%PlayerData2.update(p2_data)
	player_one = 1


func _process(delta: float) -> void:	
	maybe_whisper()
	
	if gm == Mode.PICK:
		if !mode_init:
			%PlayerData.hide()
			%PlayerData2.hide()
			update_real_hand(CardRecs)
			mode_init = true
			$Cards/Choose.text = "Choose Combatant P1!"
	if gm == Mode.ATTACK:
		do_attack()
	if gm == Mode.END:
		if p1_data.hp > 0:
			get_tree().change_scene_to_packed(p1_win)
		else:
			get_tree().change_scene_to_packed(p2_win)
	

#---------------------------

func get_player(get_opp: bool = false, player_one: int = player_one) -> PlayerData:
	if get_opp:
		player_one = {1: 2, 2: 1}[player_one]
		#print("giving opp {")
	if player_one == 1:
		if get_opp:
			pass
			#print("	gave p1 }")
		else:
			pass
			#print("{ gave p1 }")
		
		return p1_data
	else:
		if get_opp:
			pass
			#print("	gave p2 }")
		else:
			pass
			#print("{ gave p2 }")
		
		return p2_data
	


# --------------------------

func update_real_hand(hand: Array[CardResource]) -> void:
	# free the current hand, if it exists
	for child in %Cards.get_children():
		if child is Card:
			child.queue_free()
	
	# make the hand anew
	var x = 0
	for cardres in hand:
		var new_card = CardPrefab.instantiate() as Card
		%Cards.add_child(new_card)
		new_card.does_hover = true
		new_card.update_card(cardres)
		new_card.position.x += x*(CARD_WIDTH*1.1*new_card.p1_scale.x)
		new_card.scale = new_card.p1_scale
		x += 1
		
		new_card.picked.connect(_pick_main_card)

func update_main_card(cardres: CardResource):
	%PlayerData/Card.update_card(cardres)
	%PlayerData/%CardName.text = cardres.name

func update_p2_card(cardres: CardResource):
	%PlayerData2/Card.update_card(cardres)
	%PlayerData2/%CardName.text = cardres.name



#------------------------
	
func make_hand(count: int, resources: Array[CardResource]) -> Array[CardResource]:
	var hand: Array[CardResource]
	for i in range(count):
		hand.append(resources[randi_range(0, resources.size()-1)])
	return hand

func make_new_pd() -> PlayerData:
	var pd = PlayerData.new()
	pd.hand = make_hand(PlayerData.HAND_SIZE, CardRecs)
	pd.deck = make_hand(PlayerData.DECK_SIZE, CardRecs)
	return pd


func _on_button_pressed() -> void:
	p1_data = make_new_pd()
	update_real_hand(get_player(1).hand)

#----------------------------

func _pick_main_card(res: CardResource):
	if gm == Mode.PICK:
		if !player_one_picked:
			p1_data.update(res)
			update_main_card(res)
			tween_onto_screen(%PlayerData)
			player_one_picked = true
			$Cards/Choose.text = "Choose Combatant P2!"
		else:
			p2_data.update(res)
			update_p2_card(res)
			tween_onto_screen(%PlayerData2)
			tween_off_screen(%Cards)
			$Fight.explode()
			await get_tree().create_timer(2).timeout
			mode_init = false
			gm = Mode.ATTACK
			
# ------------------------------

func tween_onto_screen(node: Node2D, dur: float = 0.5, dis: float = 1000) -> void:
	node.hide()
	var og_pos = node.position
	var angle = (og_pos - Vector2.ZERO).angle()
	
	var offset = Vector2(cos(angle), sin(angle)) * dis
	node.position += offset
	
	node.show()
	var tween = get_tree().create_tween()
	tween.tween_property(node, "position", og_pos, dur).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	#await tween.finished

func tween_off_screen(node: Node2D, dur: float = 0.5, dis: float = 1000) -> void:
	var og_pos = node.position
	var angle = (og_pos - Vector2.ZERO).angle()
	var offset = Vector2(cos(angle), sin(angle)) * dis
	
	node.show()
	var tween = get_tree().create_tween()
	tween.tween_property(node, "position", og_pos+offset, dur).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	tween.tween_callback(func():
		if node:
			node.hide()
			node.position = og_pos
	)
	
	#await tween.finished
	










var player_one_attacked := false
var attack_started := false

func do_attack() -> void:
	if !attack_started:
		player_one = 1
		
		attack_started = true
		
	
	if !mode_init:
		player_one_attacked = false
		##print("1. tweened on at start, =p1")
		tween_onto_screen(%ChoiceSelector)
		%ChoiceSelector.assign_attacks(p1_data.main_card)
		$ChoiceSelector/Panel/VBoxContainer/Choose.text = "Choose action, Player One"
		%ChoiceSelector/Panel.self_modulate = Color("ffffff")
		%ChoiceSelector.give_them_jesus()
		p1_data.milk += 5
		p2_data.milk += 5
		quick_msg("Gave 5 milk to all players!")
		%PlayerData.update(p1_data)
		%PlayerData2.update(p2_data)
		mode_init = true
	
	#print(str(p1_data.hp), " ", str(p2_data.hp))
	if int(p1_data.hp) <= 0 or int(p2_data.hp) <= 0:
		#print("died")
		mode_init = true
		gm = Mode.END
		

func end_attack_turn(fin: bool = false) -> void:
	if !player_one_attacked:
		
		##print("2. tweened off, w1.4, =p2, tweened on")
		tween_off_screen(%ChoiceSelector)
		await get_tree().create_timer(1.4).timeout
		$ChoiceSelector/Panel/VBoxContainer/Choose.text = "Choose action, Player Two"
		%ChoiceSelector.assign_attacks(p2_data.main_card)
		%ChoiceSelector/Panel.self_modulate = Color("3dffd8")
		tween_onto_screen(%ChoiceSelector)
		%ChoiceSelector.give_them_jesus()
		
		player_one = 2
		
		%PlayerData.update(p1_data)
		%PlayerData2.update(p2_data)
		#print("p1 ", p1_data.hp)
		#print("p2 ", p2_data.hp)
		
		player_one_attacked = true
	else:
		##print("3. tweened off, w1.4")
		tween_off_screen(%ChoiceSelector)
		await get_tree().create_timer(1.4).timeout
		
		player_one = 1
		
		%PlayerData.update(p1_data)
		%PlayerData2.update(p2_data)
		#print("p1 ", p1_data.hp)
		#print("p2 ", p2_data.hp)
		
		#if !fin:
			##print("4. tweened on, =p1")
			#tween_onto_screen(%ChoiceSelector)
			#$ChoiceSelector/Panel/VBoxContainer/Choose.text = "Choose action, Player One"
		#else:
			#gm = Mode.END
		
		mode_init = false
		

func quick_msg(text: String) -> void: $FallingMessageGen.create_and_fall(text, $FallingMessageLoc.global_position, $FallingMessageLoc.global_position+Vector2(0, 800), 3)

func _on_buff_pressed() -> void:
	%ChoiceSelector.cripple()
	
	#print(player_one)
	var our_p1 := player_one
	#print(our_p1)
	
	if get_player(false, our_p1).milk - 5 < 0:
		quick_msg("Not enough Milk left!, buster #"+str(int(player_one)))
	else:
		get_player(false, our_p1).milk -= 5
		var buff := randf() * 0.1
		get_player(false, our_p1).damage_give_mult += buff
		quick_msg("-5 Milk.\nDamage multiplier increased to "+str(int(get_player(false, our_p1).damage_give_mult*100))+"%")
		
	
	end_attack_turn()


func _on_debuff_pressed() -> void:
	%ChoiceSelector.cripple()
	
	#print(player_one)
	var our_p1 := player_one
	#print(our_p1)
	
	if get_player(false, our_p1).milk - 5 < 0:
		quick_msg("Not enough Milk left!, buster #"+str(int(player_one*100))+"%")
	else:
		get_player(false, our_p1).milk -= 5
		var debuff := randf() * 0.1
		get_player(false, our_p1).damage_give_mult -= debuff
		quick_msg("-5 Milk.\nOpponent's damage multiplier decreased to "+str(int(get_player(true, our_p1).damage_give_mult*100))+"%")
	
	end_attack_turn()


func _on_defend_pressed() -> void:
	%ChoiceSelector.cripple()
	
	#print(player_one)
	var our_p1 := player_one
	#print(our_p1)
	
	if get_player(false, our_p1).milk - 10 < 0:
		quick_msg("Not enough Milk left!, buster #"+str(int(player_one)))
	else:
		get_player(false, our_p1).milk -= 10
		if randf() <= .5:
			var inc := randf() * 20
			quick_msg("Gained "+str(int(inc))+" health!")
			get_player(false, our_p1).hp += inc
		else:
			quick_msg("Failed! :O")
	
	end_attack_turn()


func _on_attack_1_pressed() -> void:
	%ChoiceSelector.cripple()
	
	#print(player_one)
	var our_p1 := player_one # it gets changed, the bitch!
	#print(our_p1)
	
	if get_player(false, our_p1).milk - get_player(false, our_p1).main_card.attack_1.milk_cost < 0:
		quick_msg("Not enough Milk left!, buster #"+str(int(player_one)))
	else:
		get_player(false, our_p1).milk -= get_player(false, our_p1).main_card.attack_1.milk_cost
		if get_player(false, our_p1).main_card.attack_1.success_chance >= randf():
			var damage := get_player(false, our_p1).damage_give_mult * get_player(true, our_p1).damage_take_mult * get_player(false, our_p1).main_card.attack_1.max_damage
			get_player(true, our_p1).hp -= damage
			quick_msg("Dealed "+str(int(damage))+" damage.")
			
			#print("Attacker HP: ", get_player(false, our_p1).hp)
			#print("Defender HP: ", get_player(true, our_p1).hp)
		else:
			quick_msg("Failed!")
	
	end_attack_turn()


func _on_attack_2_pressed() -> void:
	%ChoiceSelector.cripple()
	
	#print(player_one)
	var our_p1 := player_one # it gets changed, the bitch!
	#print(our_p1)
	
	if get_player(false, our_p1).milk - get_player(false, our_p1).main_card.attack_2.milk_cost < 0:
		quick_msg("Not enough Milk left!, buster #"+str(int(player_one)))
	else:
		get_player(false, our_p1).milk -= get_player(false, our_p1).main_card.attack_2.milk_cost
		if get_player(false, our_p1).main_card.attack_2.success_chance >= randf():
			var damage := get_player(false, our_p1).damage_give_mult * get_player(true, our_p1).damage_take_mult * get_player(false, our_p1).main_card.attack_2.max_damage
			get_player(true, our_p1).hp -= damage
			quick_msg("Dealed "+str(int(damage))+" damage.")
			
			#print("Attacker HP: ", get_player(false, our_p1).hp)
			#print("Defender HP: ", get_player(true, our_p1).hp)
		else:
			quick_msg("Failed!")
	
	end_attack_turn()





#----------------------

func _on_debug_fall_message_pressed() -> void:
	$FallingMessageGen.create_and_fall("message", $FallingMessageLoc.global_position, $FallingMessageLoc.global_position+Vector2(0, 800), 2.5)


func _on_debug_goto_p_2_win_pressed() -> void:
	get_tree().change_scene_to_packed(p2_win)


func _on_debug_goto_p_1_win_pressed() -> void:
	get_tree().change_scene_to_packed(p1_win)
