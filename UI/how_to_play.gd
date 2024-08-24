extends CanvasLayer

@onready var texture_button: TextureButton = $MarginContainer3/TextureButton

func _ready() -> void:
	grab_focus()

func grab_focus():
	texture_button.grab_focus()

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")
