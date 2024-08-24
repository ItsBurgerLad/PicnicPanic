extends CharacterBody2D
class_name Player

# export vars
@export_category("Player Movement")
@export var speed: float = 450.0
@export var accel: float = 1200.0
@export var friction: float = 1800.0
@export var jump_velocity: float = -400.0
@export var grav_scale: float = 1.0
@export var air_resist: float = 200.0
@export var dash_speed: float = 900.0

# onready vars
@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var carry_request_timer: Timer = $CarryRequestTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var cheese_sprite: Sprite2D = $CheeseSprite
@onready var dash_timer: Timer = $DashTimer
@onready var dash_again_timer: Timer = $DashAgainTimer
@onready var carry_sound: AudioStreamPlayer2D = $CarrySound
@onready var dash_sound: AudioStreamPlayer2D = $DashSound
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound

# preload vars
@export var food: PackedScene = preload("res://Entities/Food/food_item_2_carried.tscn")

# flex vars
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_jump: bool = false
var jumping: bool = false
var carrying: bool = false
var carry_requested: bool = false
var can_dash: bool = true
var dashing: bool = false
var carry_sound_played: bool = false
var jump_sound_played: bool = false

signal died

func _ready() -> void:
	cheese_sprite.hide()

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	handle_jump()
	jump_buffer()
	var input_axis := Input.get_axis("left", "right")
	update_animations(input_axis)
	handle_accel(input_axis, delta)
	handle_dash(input_axis)
	apply_friction(input_axis, delta)
	apply_air_resistence(input_axis, delta)
	move_and_slide()
	Globals.player_pos = position

func apply_gravity(delta):
	if not is_on_floor():
		if velocity.y > 0:
			velocity.y += gravity * grav_scale * 1.5 * delta
		else:
			velocity.y += gravity * grav_scale * delta

func handle_jump():
	if is_on_floor() or can_jump:
		jump_sound_played = false
		if jump_buffer_timer.time_left > 0.0:
			velocity.y = jump_velocity
			jump_buffer_timer.stop()
			jumping = true
	if not is_on_floor() and jump_buffer_timer.time_left > 0.0:
		if velocity.y < jump_velocity / 2:
			velocity.y = jump_velocity / 2
			jump_buffer_timer.stop()

func jump_buffer():
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer.start()

func handle_accel(input_axis, delta):
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, input_axis * speed, accel * delta)

func handle_dash(input_axis):
	if Input.is_action_just_pressed("dash") and can_dash:
		dashing = true
		can_dash = false
		dash_timer.start()
		dash_again_timer.start()
	if dashing:
		dash_sound.play()
		velocity.x = input_axis * dash_speed

func apply_friction(input_axis, delta):
	if input_axis == 0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, friction * delta)

func apply_air_resistence(input_axis, _delta):
	if input_axis == 0 and not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, air_resist)

func carry_food():
	carrying = true
	carry_sound.play()
	cheese_sprite.show()

func drop_food():
	carrying = false
	carry_sound.play()
	cheese_sprite.hide()

func _on_carry_request_timer_timeout() -> void:
	carry_requested = false

func update_animations(input_axis):
	if input_axis != 0:
		if carrying:
			animated_sprite_2d.flip_h = (input_axis < 0)
			animated_sprite_2d.play("carry_run")
		else:
			animated_sprite_2d.flip_h = (input_axis < 0)
			animated_sprite_2d.play("run")
	if velocity.x == 0:
		if carrying:
			animated_sprite_2d.play("carry_idle")
		else:
			animated_sprite_2d.play("idle")
	if not is_on_floor() and velocity.y < 0 or dashing:
		if carrying:
			animated_sprite_2d.play("carry_jump")
			if not jump_sound_played:
				jump_sound.play()
				jump_sound_played = true
		else:
			animated_sprite_2d.play("jump")
			if not jump_sound_played:
				jump_sound.play()
				jump_sound_played = true
	if not is_on_floor() and velocity.y > 0:
		if carrying:
			animated_sprite_2d.play("carry_fall")
		else:
			animated_sprite_2d.play("fall")

func _on_hazard_detector_area_entered(_area: Area2D) -> void:
	died.emit()

func _on_dash_timer_timeout() -> void:
	dashing = false

func _on_dash_again_timer_timeout() -> void:
	can_dash = true
