extends Node2D

signal switch_to_back
signal switch_to_front


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass


func _on_front_start_order() -> void:
	%Back.visible = true
	S.reset_cup()
	%GameAnimationPlayer.play("away")


func _on_game_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "away":
		%Front.visible = false
		switch_to_back.emit()
	elif anim_name == "back":
		%Back.visible = false
		switch_to_front.emit()


func _on_back_order_finished() -> void:
	%Front.visible = true
	%GameAnimationPlayer.play("back")
