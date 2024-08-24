extends CanvasLayer

signal resume_requested
signal quit_requested
signal restart_requested

@onready var resume_button: TextureButton = $MarginContainer/VBoxContainer/ResumeButton

func _ready() -> void:
	grab_focus()

func grab_focus():
	resume_button.grab_focus()

func _on_resume_button_pressed() -> void:
	resume_requested.emit()

func _on_restart_button_pressed() -> void:
	restart_requested.emit()

func _on_quit_button_pressed() -> void:
	quit_requested.emit()
