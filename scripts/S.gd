extends Node

var cup: Array[G.OPTION] = []
var cup_is_in_cupholder := false
var holding: G.HOLD


func reset_cup() -> void:
	cup = []
