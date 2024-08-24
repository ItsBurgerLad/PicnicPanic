extends CanvasLayer

@onready var number_tracker: Label = $MarginContainer/MarginContainer/HBoxContainer/NumberTracker

func _ready() -> void:
	Globals.connect("fans_added", change_fans)

func change_fans():
	number_tracker.text = str(Globals.fans)
