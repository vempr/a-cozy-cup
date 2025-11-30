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
	
	S.pick_rand_customer()
	update_order_message()
	fade_in_controls(order, start_btn)


func _process(_delta: float) -> void:
	if deliver_cup:
		%Cup.position = get_global_mouse_position()


func _on_start_button_pressed() -> void:
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
		deliver_cup = false
		%CounterCupOutline.modulate.a = 0.0
		%Cup.position = COUNTER_CUP_POSITION
		
		await get_tree().create_timer(0.5).timeout
		
		fade_out_controls(%CupCream, %CocoaMilkCup, %CocoaCup, %CupMarshmellows, %MilkCup, %CupStraw, %EmptyCup)
		%APCup.play("zoom_out")


func _on_ap_cup_animation_finished(anim_name: StringName) -> void:
	if anim_name == "zoom_out":
		var res = S.access_cup()
		match res:
			G.RESULT.PERFECT:
				feedback.text = G.dialog[S.current_customer]["responses"][G.RESULT.PERFECT]
			G.RESULT.OKAY:
				feedback.text = G.dialog[S.current_customer]["responses"][G.RESULT.OKAY]
			G.RESULT.BAD:
				feedback.text = G.dialog[S.current_customer]["responses"][G.RESULT.BAD]
		
		await fade_in_controls(feedback, next_btn)
		%APCup.play("RESET")


func _on_next_button_pressed() -> void:
	await fade_out_controls(feedback, next_btn)
	S.pick_rand_customer()
	update_order_message()
	fade_in_controls(order, start_btn)


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
	%Order.text = G.dialog[S.current_customer]["order_message"]
