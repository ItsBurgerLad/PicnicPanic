extends Node

signal fans_added

var player_pos

var fans: int = 0:
	set(value):
		fans = value
		fans_added.emit()

#func restart() -> void:
	#fans = 0
	#get_tree().reload_current_scene()
	#print("Game has been restarted.")
