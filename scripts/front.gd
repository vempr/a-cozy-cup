extends Node2D

signal start_order

const COUNTER_CUP_POSITION := Vector2(960, 914)

var deliver_cup := false


func _ready() -> void:
	%CounterCupOutline.modulate.a = 0.0
	%Cup.visible = false


func _process(_delta: float) -> void:
	if deliver_cup:
		%Cup.position = get_global_mouse_position()


func _on_start_button_pressed() -> void:
	var tween = create_tween()
	tween.parallel().tween_property(%Order, "modulate:a", 0.0, 0.4)
	tween.parallel().tween_property(%StartButton, "modulate:a", 0.0, 0.4)
	start_order.emit()
	
	await tween.finished
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
	
	var c = S.cup
	if c.size() <= 0:
		%EmptyCup.visible = true
	else:
		if G.OPTION.MARSHMELLOWS in c:
			%CupMarshmellows.visible = true
		if G.OPTION.STRAW in c:
			%CupStraw.visible = true
		if G.OPTION.WHIPPED_CREAM:
			%CupCream.visible = true
		
		var cc = G.OPTION.COCOA in c
		var mm = G.OPTION.MILK in c
		var cm = cc && mm
		
		if cm:
			%CocoaMilkCup.visible = true
		elif cc:
			%CocoaCup.visible = true
		elif mm:
			%MilkCup.visible = true
		else:
			%EmptyCup.visible = true
	
	await get_tree().create_timer(0.1).timeout
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
		S.access_cup()
		
		await get_tree().create_timer(0.5).timeout
		S.reset_cup()
		
		var tween = create_tween()
		tween.parallel().tween_property(%CupCream, "modulate:a", 0.0, 0.2)
		tween.parallel().tween_property(%CocoaMilkCup, "modulate:a", 0.0, 0.2)
		tween.parallel().tween_property(%CocoaCup, "modulate:a", 0.0, 0.2)
		tween.parallel().tween_property(%CupMarshmellows, "modulate:a", 0.0, 0.2)
		tween.parallel().tween_property(%MilkCup, "modulate:a", 0.0, 0.2)
		tween.parallel().tween_property(%CupStraw, "modulate:a", 0.0, 0.2)
		tween.parallel().tween_property(%EmptyCup, "modulate:a", 0.0, 0.2)
		%APCup.play("zoom_out")


func _on_ap_cup_animation_finished(anim_name: StringName) -> void:
	if anim_name == "zoom_out":
		print("get assessment and dialog 4 result")
