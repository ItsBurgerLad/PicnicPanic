extends Node2D

@onready var player: Player = $AntPlayerCharacter
@onready var ant_hill: Area2D = $AntHill
@onready var drop_cooldown_timer: Timer = $DropCooldownTimer
@onready var enemy_cooldown_timer: Timer = $EnemyCooldownTimer
@onready var step_zone: Area2D = $"Step Zone"
@onready var warning_symbol: Sprite2D = $WarningSymbol
@onready var warning_timer: Timer = $WarningTimer
@onready var game_over_screen: CanvasLayer = $GameOverScreen
@onready var pause_menu: CanvasLayer = $PauseMenu
@onready var respawn_point: Marker2D = $RespawnPoint
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var death_sound: AudioStreamPlayer2D = $DeathSound

var player_in_pos: bool = false
var can_drop: bool = false
var can_hit: bool = true
var step_zone_entered: bool = false
var finished_warning: bool = false
var game_paused: bool = false

func _ready() -> void:
	warning_symbol.hide()
	game_over_screen.hide()
	pause_menu.hide()
	audio_stream_player_2d.play()

func _physics_process(_delta: float) -> void:
	drop_picnic_snacks()
	enemy_hit()
	pause_game()

func restart_game():
	player.position = respawn_point.global_position
	Globals.fans = 0
	warning_symbol.hide()
	game_over_screen.hide()
	pause_menu.hide()
	get_tree().paused = false
	
func pause_game():
	if Input.is_action_just_pressed("pause") and not get_tree().paused == true:
		get_tree().paused = true
		pause_menu.show()
		pause_menu.grab_focus()
	elif Input.is_action_just_pressed("pause") and get_tree().paused == true:
		pause_menu.hide()
		get_tree().paused = false

func end_game():
	death_sound.play()
	game_over_screen.show()
	game_over_screen.grab_focus()
	get_tree().paused = true

func _on_ant_hill_body_entered(body: Node2D) -> void:
	if body.has_method("drop_food") and body.carrying:
		body.drop_food()
		Globals.fans += 10

func _on_ant_hill_body_exited(_body: Node2D) -> void:
	print("Player has left the anthill.")

func _on_picnic_table_player_ready() -> void:
	player_in_pos = true
	can_drop = true

func enemy_hit():
	var stomp: Vector2
	stomp.x = randf_range((player.global_position.x - 750), (player.global_position.x + 750))

	if step_zone_entered and can_hit:
		can_hit = false
		warning_symbol.show()
		warning_timer.start()
		warning_symbol.position.x = stomp.x
	if finished_warning:
		warning_symbol.hide()
		finished_warning = false
		var enemy = EnemyScenes.enemy_scenes.pick_random().instantiate()
		get_tree().current_scene.add_child(enemy)
		enemy.position.x = warning_symbol.position.x
		enemy.position.y = -225.00
		enemy_cooldown_timer.start()
	if Globals.fans >= 30:
		enemy_cooldown_timer.wait_time = 2.0
	if Globals.fans >= 60:
		enemy_cooldown_timer.wait_time = 1.5
	if Globals.fans >= 100:
		enemy_cooldown_timer.wait_time = 1.0

func drop_picnic_snacks():
	if can_drop:
		if player_in_pos:
			var snack = FoodScenes.food_scenes.pick_random().instantiate()
			get_tree().current_scene.add_child(snack)
			snack.position.x = randf_range(6100.00, 7910.00)
			snack.position.y = -15.00
			can_drop = false
		drop_cooldown_timer.start()

func _on_drop_cooldown_timer_timeout() -> void:
	can_drop = true

func _on_picnic_table_player_gone() -> void:
	can_drop = false
	player_in_pos = false

func _on_enemy_cooldown_timer_timeout() -> void:
	can_hit = true

func _on_step_zone_body_entered(body: Node2D) -> void:
	if body is Player:
		step_zone_entered = true

func _on_step_zone_body_exited(body: Node2D) -> void:
	if body is Player:
		step_zone_entered = false

func _on_warning_timer_timeout() -> void:
	finished_warning = true

func _on_ant_player_character_died() -> void:
	end_game()

func _on_pause_menu_resume_requested() -> void:
	pause_menu.hide()
	get_tree().paused = false

func _on_game_over_screen_retry_requested() -> void:
	restart_game()
	print("Button pressed.")

func _on_pause_menu_restart_requested() -> void:
	restart_game()

func _on_pause_menu_quit_requested() -> void:
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")

func _on_game_over_screen_exit_to_menu() -> void:
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")
