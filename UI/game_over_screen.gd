extends CanvasLayer

signal retry_requested
signal exit_to_menu

@onready var label_2: Label = $MarginContainer/VBoxContainer/HBoxContainer/Label2
@onready var retry_button: TextureButton = $MarginContainer/VBoxContainer/RetryButton

func _ready() -> void:
	Globals.connect("fans_added", fans_total)
	grab_focus()

func grab_focus():
	retry_button.grab_focus()

func fans_total():
	label_2.text = str(Globals.fans)

func _on_retry_button_pressed() -> void:
	retry_requested.emit()

func _on_main_menu_button_pressed() -> void:
	exit_to_menu.emit()
