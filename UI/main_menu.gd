extends CanvasLayer

var music_playing: bool = false

@onready var texture_button: TextureButton = $MarginContainer3/VBoxContainer/TextureButton
@onready var texture_button_2: TextureButton = $MarginContainer3/VBoxContainer/TextureButton2

func _ready() -> void:
	grab_focus()
	play_music()

func play_music():
	if not music_playing:
		MainMenuMusic.play()
		music_playing = true

func grab_focus():
	texture_button.grab_focus()

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Common/Prototyping/test_world.tscn")
	MainMenuMusic.stop()
	music_playing = false

func _on_texture_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/how_to_play.tscn")
