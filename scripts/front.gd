extends Node2D

signal start_order

const COUNTER_CUP_POSITION := Vector2(960, 914)

var deliver_cup := false
var spots = {
	1: null,
	2: null,
	3: null,
	4: null,
}
@onready var order = %Order
@onready var feedback = %Feedback
@onready var start_btn = %StartButton
@onready var next_btn = %NextButton
var tween: Tween


func _ready() -> void:
	%CounterCupOutline.modulate.a = 0.0
	%Cup.visible = false
	
	order.visible = false
	feedback.visible = false
	start_btn.visible = false
	next_btn.visible = false
	order.modulate.a = 0.0
	feedback.modulate.a = 0.0
	start_btn.modulate.a = 0.0
	next_btn.modulate.a = 0.0
	
	%"1Cup".modulate.a = 0.0
	%"2Cup".modulate.a = 0.0
	%"3Cup".modulate.a = 0.0
	%"4Cup".modulate.a = 0.0
	
	$"CharactersSitting/1/Alph".modulate.a = 0.0
	$"CharactersSitting/1/BalloonBoy".modulate.a = 0.0
	$"CharactersSitting/1/Cloid".modulate.a = 0.0
	$"CharactersSitting/1/Flam".modulate.a = 0.0
	$"CharactersSitting/1/Icie".modulate.a = 0.0
	$"CharactersSitting/1/Karot".modulate.a = 0.0
	$"CharactersSitting/1/Slush".modulate.a = 0.0
	$"CharactersSitting/1/Sunnie".modulate.a = 0.0
	$"CharactersSitting/1/TreeVi".modulate.a = 0.0
	
	$"CharactersSitting/2/Alph".modulate.a = 0.0
	$"CharactersSitting/2/BalloonBoy".modulate.a = 0.0
	$"CharactersSitting/2/Cloid".modulate.a = 0.0
	$"CharactersSitting/2/Flam".modulate.a = 0.0
	$"CharactersSitting/2/Icie".modulate.a = 0.0
	$"CharactersSitting/2/Karot".modulate.a = 0.0
	$"CharactersSitting/2/Slush".modulate.a = 0.0
	$"CharactersSitting/2/Sunnie".modulate.a = 0.0
	$"CharactersSitting/2/TreeVi".modulate.a = 0.0
	
	$"CharactersSitting/3/Alph".modulate.a = 0.0
	$"CharactersSitting/3/BalloonBoy".modulate.a = 0.0
	$"CharactersSitting/3/Cloid".modulate.a = 0.0
	$"CharactersSitting/3/Flam".modulate.a = 0.0
	$"CharactersSitting/3/Icie".modulate.a = 0.0
	$"CharactersSitting/3/Karot".modulate.a = 0.0
	$"CharactersSitting/3/Slush".modulate.a = 0.0
	$"CharactersSitting/3/Sunnie".modulate.a = 0.0
	$"CharactersSitting/3/TreeVi".modulate.a = 0.0
	
	$"CharactersSitting/4/Alph".modulate.a = 0.0
	$"CharactersSitting/4/BalloonBoy".modulate.a = 0.0
	$"CharactersSitting/4/Cloid".modulate.a = 0.0
	$"CharactersSitting/4/Flam".modulate.a = 0.0
	$"CharactersSitting/4/Icie".modulate.a = 0.0
	$"CharactersSitting/4/Karot".modulate.a = 0.0
	$"CharactersSitting/4/Slush".modulate.a = 0.0
	$"CharactersSitting/4/Sunnie".modulate.a = 0.0
	$"CharactersSitting/4/TreeVi".modulate.a = 0.0
	
	S.pick_rand_customer()
	update_order_message()
	fade_in_controls(order, start_btn)
	play_appearing_animation()


func _process(_delta: float) -> void:
	if deliver_cup:
		%Cup.position = get_global_mouse_position()


func _on_start_button_pressed() -> void:
	%Click.play()
	start_order.emit()
	await fade_out_controls(order, start_btn)
	%Dialog.visible = false


func _on_game_switch_to_front() -> void:
	%CounterCupOutline.modulate.a = 0.2
	%Dialog.visible = true
	deliver_cup = true
	
	%CocoaMilkCup.visible = false
	%CocoaCup.visible = false
	%CupMarshmellows.visible = false
	%MilkCup.visible = false
	%CupStraw.visible = false
	%CupCream.visible = false
	%EmptyCup.visible = false
	%CocoaMilkCup.modulate.a = 1.0
	%CocoaCup.modulate.a = 1.0
	%CupMarshmellows.modulate.a = 1.0
	%MilkCup.modulate.a = 1.0
	%CupStraw.modulate.a = 1.0
	%CupCream.modulate.a = 1.0
	%EmptyCup.modulate.a = 1.0
	
	if S.cup.size() <= 0:
		%EmptyCup.visible = true
	else:
		if G.OPTION.MARSHMELLOWS in S.cup:
			%CupMarshmellows.visible = true
		if G.OPTION.STRAW in S.cup:
			%CupStraw.visible = true
		if G.OPTION.WHIPPED_CREAM in S.cup:
			%CupCream.visible = true
		
		var cc = G.OPTION.COCOA in S.cup
		var mm = G.OPTION.MILK in S.cup
		var cm = cc && mm
		
		if cm:
			%CocoaMilkCup.visible = true
		elif cc:
			%CocoaCup.visible = true
		elif mm:
			%MilkCup.visible = true
		else:
			%EmptyCup.visible = true
	
	%Cup.visible = true


func _on_counter_cup_mouse_entered() -> void:
	if deliver_cup:
		%CounterCupOutline.modulate.a = 0.4


func _on_counter_cup_mouse_exited() -> void:
	if deliver_cup:
		%CounterCupOutline.modulate.a = 0.2


func _on_counter_cup_pressed() -> void:
	if deliver_cup:
		%Clack.play()
		deliver_cup = false
		%CounterCupOutline.modulate.a = 0.0
		%Cup.position = COUNTER_CUP_POSITION
		
		await get_tree().create_timer(0.5).timeout
		
		fade_out_controls(%CupCream, %CocoaMilkCup, %CocoaCup, %CupMarshmellows, %MilkCup, %CupStraw, %EmptyCup)
		%APCup.play("zoom_out")


func _on_ap_cup_animation_finished(anim_name: StringName) -> void:
	if anim_name == "zoom_out":
		var res = S.access_cup()
		feedback.text = G.CHARACTERS.keys()[S.current_customer] + ": "
		match res:
			G.RESULT.PERFECT:
				feedback.text += G.dialog[S.current_customer]["responses"][G.RESULT.PERFECT]
			G.RESULT.OKAY:
				feedback.text += G.dialog[S.current_customer]["responses"][G.RESULT.OKAY]
			G.RESULT.BAD:
				feedback.text += G.dialog[S.current_customer]["responses"][G.RESULT.BAD]
		
		await fade_in_controls(feedback, next_btn)
		%APCup.play("RESET")
		play_appearing_animation()


func _on_next_button_pressed() -> void:
	%Click.play()
	play_disappearing_animation()
	sit()
	await fade_out_controls(feedback, next_btn)
	S.pick_rand_customer()
	update_order_message()
	fade_in_controls(order, start_btn)
	play_appearing_animation()


func fade_in_controls(...controls: Array) -> bool:
	if tween:
		tween.kill()
	
	tween = create_tween()
	for control_node in controls:
		control_node.visible = true
		tween.parallel().tween_property(control_node, "modulate:a", 1.0, 0.5)
	
	await tween.finished
	return true


func fade_out_controls(...controls: Array) -> bool:
	if tween:
		tween.kill()
	
	tween = create_tween()
	for control_node in controls:
		tween.parallel().tween_property(control_node, "modulate:a", 0.0, 0.3)
	
	await tween.finished
	for control_node in controls:
		control_node.visible = false
	
	return true


func update_order_message() -> void:
	%Order.text = G.CHARACTERS.keys()[S.current_customer] + ": " + G.dialog[S.current_customer]["order_message"]


func play_appearing_animation() -> void:
	%Alph.modulate.a = 0.0
	%BalloonBoy.modulate.a = 0.0
	%Cloid.modulate.a = 0.0
	%Flam.modulate.a = 0.0
	%Icie.modulate.a = 0.0
	%Karot.modulate.a = 0.0
	%Slush.modulate.a = 0.0
	%Sunnie.modulate.a = 0.0
	%TreeVi.modulate.a = 0.0
	
	var tw = create_tween()
	match S.current_customer:
		G.CHARACTERS.ALPH:
			tw.tween_property(%Alph, "modulate:a", 1.0, 0.2)
		G.CHARACTERS.BALLOON_BOY:
			tw.tween_property(%BalloonBoy, "modulate:a", 1.0, 0.2)
		G.CHARACTERS.CLOID:
			tw.tween_property(%Cloid, "modulate:a", 1.0, 0.2)
		G.CHARACTERS.FLAM:
			tw.tween_property(%Flam, "modulate:a", 1.0, 0.2)
		G.CHARACTERS.ICIE:
			tw.tween_property(%Icie, "modulate:a", 1.0, 0.2)
		G.CHARACTERS.KAROT:
			tw.tween_property(%Karot, "modulate:a", 1.0, 0.2)
		G.CHARACTERS.SLUSH:
			tw.tween_property(%Slush, "modulate:a", 1.0, 0.2)
		G.CHARACTERS.SUNNIE:
			tw.tween_property(%Sunnie, "modulate:a", 1.0, 0.2)
		G.CHARACTERS.TREE_VI:
			tw.tween_property(%TreeVi, "modulate:a", 1.0, 0.2)
	
	%APCharacter.play("appear")


func play_disappearing_animation() -> void:
	%APCharacter.play("appear")
	
	var tw = create_tween()
	match S.current_customer:
		G.CHARACTERS.ALPH:
			tw.tween_property(%Alph, "modulate:a", 0.0, 0.2)
		G.CHARACTERS.BALLOON_BOY:
			tw.tween_property(%BalloonBoy, "modulate:a", 0.0, 0.2)
		G.CHARACTERS.CLOID:
			tw.tween_property(%Cloid, "modulate:a", 0.0, 0.2)
		G.CHARACTERS.FLAM:
			tw.tween_property(%Flam, "modulate:a", 0.0, 0.2)
		G.CHARACTERS.ICIE:
			tw.tween_property(%Icie, "modulate:a", 0.0, 0.2)
		G.CHARACTERS.KAROT:
			tw.tween_property(%Karot, "modulate:a", 0.0, 0.2)
		G.CHARACTERS.SLUSH:
			tw.tween_property(%Slush, "modulate:a", 0.0, 0.2)
		G.CHARACTERS.SUNNIE:
			tw.tween_property(%Sunnie, "modulate:a", 0.0, 0.2)
		G.CHARACTERS.TREE_VI:
			tw.tween_property(%TreeVi, "modulate:a", 0.0, 0.2)


func sit() -> void:
	var free_spots = []
	for i in spots.keys():
		if spots[i] == null:
			free_spots.append(i)
	if free_spots.size() <= 0:
		return
	
	var ri = free_spots[randi() % free_spots.size()]
	var spot_index = ri
	var timer_node = get_node("Timers/%dTimer" % spot_index)
	timer_node.start()
	
	var cup_node = get_node("TableCups/%dCup" % spot_index)
	var twe = create_tween()
	twe.parallel().tween_property(cup_node, "modulate:a", 1.0, 1.0)
	
	var character_name
	match S.current_customer:
		G.CHARACTERS.ALPH:
			character_name = "Alph"
		G.CHARACTERS.BALLOON_BOY:
			character_name = "BalloonBoy"
		G.CHARACTERS.CLOID:
			character_name = "Cloid"
		G.CHARACTERS.FLAM:
			character_name = "Flam"
		G.CHARACTERS.ICIE:
			character_name = "Icie"
		G.CHARACTERS.KAROT:
			character_name = "Karot"
		G.CHARACTERS.SLUSH:
			character_name = "Slush"
		G.CHARACTERS.SUNNIE:
			character_name = "Sunnie"
		G.CHARACTERS.TREE_VI:
			character_name = "TreeVi"
	
	if S.current_customer == G.CHARACTERS.ALPH:
		spots[spot_index] = "Visi"
		return
	
	var character_node_path = "CharactersSitting/%d/%s" % [spot_index, character_name]
	var character_node = get_node(character_node_path)
	
	spots[spot_index] = character_node
	twe.parallel().tween_property(character_node, "modulate:a", 1.0, 1.0)


func _on_1_timeout() -> void:
	unsit(1)


func _on_2_timeout() -> void:
	unsit(2)


func _on_3_timeout() -> void:
	unsit(3)


func _on_4_timeout() -> void:
	unsit(4)


func unsit(sidx: int) -> void:
	if spots.get(sidx) == null:
		return
	
	var cup_node = get_node("TableCups/%dCup" % sidx)
	var twe = create_tween()
	twe.parallel().tween_property(cup_node, "modulate:a", 0.0, 1.0)
	
	var character_node = spots[sidx]
	if character_node != null:
		if character_node is not String:
			twe.parallel().tween_property(character_node, "modulate:a", 0.0, 1.0)
	
	spots[sidx] = null
