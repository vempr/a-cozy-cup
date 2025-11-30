extends Node2D

signal heads_up(opt: G.INTERACTABLE)
signal heads_down

const CUPHOLDER_POSITION := Vector2(960, 933)
const MILK_POSITION := Vector2(1380, 890)
const WHIPPED_CREAM_POSITION := Vector2(1222, 857)
const COCOA_POSITION := Vector2(612, 920)

@onready var cup := %Cup
@onready var straw := %Straw
@onready var milk := %Milk
@onready var whipped_cream := %WhippedCream
@onready var marshmellows := %Marshmellows


func _ready() -> void:
	hide_all_outlines()
	reset_all_holdables()
	hide_all_options()
	cup.visible = false
	
	%EmptyCup.visible = true
	%CupOutline.visible = true
	milk.visible = true
	whipped_cream.visible = true


func _process(_delta: float) -> void:
	if S.in_animation:
		return
	else:
		if S.holding == G.HOLD.CUP:
			cup.position = get_global_mouse_position()
		elif S.holding == G.HOLD.MILK:
			milk.position = get_global_mouse_position()
		elif S.holding == G.HOLD.MARSHMELLOWS:
			marshmellows.position = get_global_mouse_position()
		elif S.holding == G.HOLD.WHIPPED_CREAM:
			whipped_cream.position = get_global_mouse_position()
		elif S.holding == G.HOLD.STRAW:
			straw.position = get_global_mouse_position()


func reset_all_holdables() -> void:
	milk.position = MILK_POSITION
	whipped_cream.position = WHIPPED_CREAM_POSITION
	straw.visible = false
	marshmellows.visible = false


func hide_all_options() -> void:
	%CocoaMilkCup.visible = false
	%CocoaCup.visible = false
	%CupMarshmellows.visible = false
	%MilkCup.visible = false
	%CupStraw.visible = false
	%EmptyCup.visible = false
	%CupCream.visible = false


func hide_all_outlines() -> void:
	%CupOutline.visible = false
	%StrawsOutline.visible = false
	%CocoaOutline.visible = false
	%CupholderOutline.visible = false
	%WhippedCreamOutline.visible = false
	%MilkOutline.visible = false
	%MarshmellowsOutline.visible = false


func _on_cups_mouse_entered() -> void:
	%CupOutline.modulate.a = 0.3
	heads_up.emit(G.INTERACTABLE.CUPS)


func _on_cups_mouse_exited() -> void:
	%CupOutline.modulate.a = 0.2
	heads_down.emit()


func _on_cups_pressed() -> void:
	if S.in_animation:
		return
	
	S.holding = G.HOLD.CUP
	S.reset_cup()
	
	reset_all_holdables()
	hide_all_options()
	hide_all_outlines()
	
	%EmptyCup.visible = true
	%CupholderOutline.visible = true
	%CocoaOutline.visible = true
	cup.visible = true


func _on_cupholder_mouse_entered() -> void:
	%CupholderOutline.modulate.a = 0.3
	heads_up.emit(G.INTERACTABLE.CUPHOLDER)


func _on_cupholder_mouse_exited() -> void:
	%CupholderOutline.modulate.a = 0.2
	heads_down.emit()


func _on_cupholder_pressed() -> void:
	if S.in_animation:
		return
	
	if S.holding == G.HOLD.CUP:
		S.cup_is_in_cupholder = true
		S.holding = G.HOLD.NOTHING
		cup.position = CUPHOLDER_POSITION
		
		%CupOutline.visible = true
		%StrawsOutline.visible = true
		%CocoaOutline.visible = false
		%CupholderOutline.visible = true
		%WhippedCreamOutline.visible = true
		%MilkOutline.visible = true
		%MarshmellowsOutline.visible = true
	
	elif S.cup_is_in_cupholder:
		if S.holding == G.HOLD.STRAW:
			if S.add_to_cup(G.OPTION.STRAW):
				straw.visible = false
				S.holding = G.HOLD.NOTHING
				%CupStraw.visible = true
		
		elif S.holding == G.HOLD.MARSHMELLOWS:
			if S.add_to_cup(G.OPTION.MARSHMELLOWS):
				marshmellows.visible = false
				S.holding = G.HOLD.NOTHING
				%CupMarshmellows.visible = true
		
		elif S.holding == G.HOLD.WHIPPED_CREAM:
			if S.add_to_cup(G.OPTION.WHIPPED_CREAM):
				%CupCream.visible = true
				S.in_animation = true
				%APWhippedCream.play("apply")
				%CupCream.play("fill")
		
		elif S.holding == G.HOLD.MILK:
			if S.add_to_cup(G.OPTION.MILK):
				S.in_animation = true
				%APMilk.play("pour")
		
		elif S.holding == G.HOLD.NOTHING:
			S.cup_is_in_cupholder = false
			S.holding = G.HOLD.CUP
			hide_all_outlines()
			%CupOutline.visible = true
			%CocoaOutline.visible = true
			%CupholderOutline.visible = true


func _on_straws_mouse_entered() -> void:
	%StrawsOutline.modulate.a = 0.3
	heads_up.emit(G.INTERACTABLE.STRAWS)


func _on_straws_mouse_exited() -> void:
	%StrawsOutline.modulate.a = 0.2
	heads_down.emit()


func _on_straws_pressed() -> void:
	if S.holding != G.HOLD.CUP && !S.in_animation:
		var bef_res = straw.visible
		if S.cup_is_in_cupholder:
			reset_all_holdables()
			straw.visible = !bef_res
			if straw.visible:
				S.holding = G.HOLD.STRAW
			else:
				S.holding = G.HOLD.NOTHING


func _on_cocoa_pressed() -> void:
	if S.in_animation:
		return
	
	if !S.cup_is_in_cupholder && (S.holding == G.HOLD.CUP || S.holding == G.HOLD.NOTHING):
		S.cup_is_in_cocoa = !S.cup_is_in_cocoa
		
		# using G.OPTION.COCOA not in S.cup instead of S.add_to_cup
		# because it's noticably more performant (idk why)
		if S.cup_is_in_cocoa && G.OPTION.COCOA not in S.cup:
			S.holding = G.HOLD.NOTHING
			cup.position = COCOA_POSITION
			
			S.add_to_cup(G.OPTION.COCOA)
			S.in_animation = true
			%APCocoa.play("pour")
		else:
			S.holding = G.HOLD.CUP


func _on_cocoa_mouse_entered() -> void:
	%CocoaOutline.modulate.a = 0.3
	heads_up.emit(G.INTERACTABLE.COCOA_MACHINE)


func _on_cocoa_mouse_exited() -> void:
	%CocoaOutline.modulate.a = 0.2
	heads_down.emit()


func _on_whipped_cream_mouse_entered() -> void:
	%WhippedCreamOutline.modulate.a = 0.3
	heads_up.emit(G.INTERACTABLE.WHIPPED_CREAM)


func _on_whipped_cream_mouse_exited() -> void:
	%WhippedCreamOutline.modulate.a = 0.2
	heads_down.emit()


func _on_whipped_cream_pressed() -> void:
	if S.holding != G.HOLD.CUP && !S.in_animation:
		if S.cup_is_in_cupholder:
			reset_all_holdables()
			if S.holding == G.HOLD.WHIPPED_CREAM:
				S.holding = G.HOLD.NOTHING
			else:
				S.holding = G.HOLD.WHIPPED_CREAM


func _on_milk_mouse_entered() -> void:
	%MilkOutline.modulate.a = 0.3
	heads_up.emit(G.INTERACTABLE.MILK)


func _on_milk_mouse_exited() -> void:
	%MilkOutline.modulate.a = 0.2
	heads_down.emit()


func _on_milk_pressed() -> void:
	if S.holding != G.HOLD.CUP && !S.in_animation:
		if S.cup_is_in_cupholder:
			reset_all_holdables()
			if S.holding == G.HOLD.MILK:
				S.holding = G.HOLD.NOTHING
			else:
				S.holding = G.HOLD.MILK


func _on_marshmellows_mouse_exited() -> void:
	%MarshmellowsOutline.modulate.a = 0.3
	heads_down.emit()


func _on_marshmellows_mouse_entered() -> void:
	%MarshmellowsOutline.modulate.a = 0.2
	heads_up.emit(G.INTERACTABLE.MARSHMELLOWS)


func _on_marshmellows_pressed() -> void:
	if S.holding != G.HOLD.CUP && !S.in_animation:
		var bef_res = marshmellows.visible
		if S.cup_is_in_cupholder:
			reset_all_holdables()
			marshmellows.visible = !bef_res
			if marshmellows.visible:
				S.holding = G.HOLD.MARSHMELLOWS
			else:
				S.holding = G.HOLD.NOTHING


func _on_ap_whipped_cream_animation_finished(anim_name: StringName) -> void:
	if anim_name == "apply":
		S.in_animation = false
		%APWhippedCream.play("RESET")


func _on_ap_milk_animation_finished(anim_name: StringName) -> void:
	if anim_name == "pour":
		%APMilk.play("fall")
	elif anim_name == "fall":
		%APMilk.play("unpour")
	elif anim_name == "unpour":
		S.in_animation = false
		if G.OPTION.COCOA in S.cup:
			%CocoaMilkCup.visible = true
			%CocoaCup.visible = false
			%MilkCup.visible = false
			%EmptyCup.visible = false
		else:
			%CocoaMilkCup.visible = false
			%CocoaCup.visible = false
			%MilkCup.visible = true
			%EmptyCup.visible = false


func _on_ap_cocoa_animation_finished(anim_name: StringName) -> void:
	if anim_name == "pour":
		S.in_animation = false
		if G.OPTION.MILK in S.cup:
			%CocoaMilkCup.visible = true
			%CocoaCup.visible = false
			%MilkCup.visible = false
			%EmptyCup.visible = false
		else:
			%CocoaMilkCup.visible = false
			%CocoaCup.visible = true
			%MilkCup.visible = false
			%EmptyCup.visible = false
