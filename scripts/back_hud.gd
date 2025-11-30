extends CanvasLayer

const INTERACTABLE_HEADS_UPS := {
	G.INTERACTABLE.CUPS: "The humble cup. Your trusty vessel for chocolatey goodness.",
	G.INTERACTABLE.STRAWS: "Sippy sippy.. for when you want to drink like a fancy person.",
	G.INTERACTABLE.COCOA_MACHINE: "The magic chocolate waterfall! Liquid happiness dispenser.",
	G.INTERACTABLE.CUPHOLDER: "The cup's parking spot. No working and driving!",
	G.INTERACTABLE.WHIPPED_CREAM: "Fluffy cloud topping. Because everything's better with cream.",
	G.INTERACTABLE.MILK: "Moo juice! For when you want your cocoa extra creamy.",
	G.INTERACTABLE.MARSHMELLOWS: "Squishy floating thingies that are basically edible pillows."
}

@onready var tween: Tween


func _ready() -> void:
	%HeadsUp.modulate.a = 0.0


func _on_back_heads_up(opt: G.INTERACTABLE) -> void:
	if tween:
		tween.kill()
	
	%HeadsUp.text = INTERACTABLE_HEADS_UPS[opt]
	tween = create_tween()
	tween.tween_property(%HeadsUp, "modulate:a", 1.0, 0.1)


func _on_back_heads_down() -> void:
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(%HeadsUp, "modulate:a", 0.0, 0.3)
