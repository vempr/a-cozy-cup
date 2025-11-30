extends Node

var cup: Array[G.OPTION] = []
var cup_is_in_cupholder := false
var cup_is_in_cocoa := false
var holding: G.HOLD
var in_animation := false


func reset_cup() -> void:
	cup = []


func add_to_cup(opt: G.OPTION) -> bool:
	if opt not in cup:
		cup.append(opt)
		return true
	return false


func access_cup() -> void:
	print("to be made")
