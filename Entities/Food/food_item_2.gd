extends RigidBody2D

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		if body.has_method("carry_food") and body.carrying == false:
			body.carry_food()
			queue_free()
			print("Player has the cheese now.")
