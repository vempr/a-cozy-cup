extends Node

var cup: Array[G.OPTION] = []
var cup_is_in_cupholder := false
var cup_is_in_cocoa := false
var holding: G.HOLD
var in_animation := false
var customers = []
var current_customer


func _ready() -> void:
	populate_customers_arr()


func reset_cup() -> void:
	cup = []


func add_to_cup(opt: G.OPTION) -> bool:
	print(opt)
	if opt not in cup:
		cup.append(opt)
		print(cup)
		return true
	return false


func access_cup() -> G.RESULT:
	var correct_ingredients = G.dialog[current_customer]["order"]
	var max_score = correct_ingredients.size()
	var score := 0
	
	print(cup)
	print(correct_ingredients)
	
	for ing in cup:
		if ing in correct_ingredients:
			score += 1
		else:
			score -= 1
	
	if score == max_score:
		return G.RESULT.PERFECT
	elif float(score) / float(max_score) > 0.4:
		return G.RESULT.OKAY
	else:
		return G.RESULT.BAD


func populate_customers_arr() -> void:
	for c in G.CHARACTERS:
		customers.append(c)


func pick_rand_customer() -> void:
	if customers.size() <= 0:
		populate_customers_arr()
	
	var cidx := 0 if customers.size() == 1 else randi_range(0, customers.size() - 1)
	current_customer = G.CHARACTERS[customers[cidx]]
	customers.remove_at(cidx)
