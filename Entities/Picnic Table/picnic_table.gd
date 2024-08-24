extends Area2D

signal player_ready
signal player_gone

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_ready.emit()

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_gone.emit()
