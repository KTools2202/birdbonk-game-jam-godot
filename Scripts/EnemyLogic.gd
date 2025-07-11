extends Node

@export var parent_body: RigidBody2D

#@onready var terrain: TileMapLayer = parent_body.get_node_or_null(".../Terrains/Terrian2")
@onready var sfx: AudioStreamPlayer = parent_body.get_node_or_null("../AudioStreamPlayer")
@onready var ray_cast_down: RayCast2D = parent_body.get_node_or_null("RayCastDown")
@onready var animation_player: AnimationPlayer = parent_body.get_node_or_null("AnimationPlayer")
@onready var sprite_2d: Sprite2D = parent_body.get_node_or_null("Sprite2D")
@onready var launch_timer: Timer = parent_body.get_node_or_null("Launch Timer")
@onready var player: CharacterBody2D = parent_body.get_node_or_null("../../Player")

var collider
@export var run_speed: float = 10.0
@export var float_speed: float = 50.0  # Speed of floating towards the player
@export var jump_power: float = -25.0
var time_out: bool = false
var shaking: bool = false

func _ready() -> void:
	assert(parent_body != null, "parent_body must be assigned in inspector!")
	launch_timer.timeout.connect(_on_launch_timer_timeout)
	animation_player.play("RESET")

func _physics_process(delta: float) -> void:
	if Global.stone_age:
		handle_stone_age()
	elif Global.medieval_age and Global.EnemyinRange:
		if Input.is_action_pressed("Ability"):
			float_toward_player(delta)

func float_toward_player(delta: float) -> void:
	var stop_distance: float = 20.0
	var direction: Vector2 = player.global_position - parent_body.global_position
	var distance: float = direction.length()

	if distance > stop_distance:
		parent_body.gravity_scale = 0.0

		var force_direction: Vector2 = direction.normalized()
		var desired_velocity: Vector2 = force_direction * float_speed

		var velocity_difference: Vector2 = desired_velocity - parent_body.linear_velocity
		var force_to_apply: Vector2 = velocity_difference * parent_body.mass / delta

		parent_body.apply_central_force(force_to_apply)
	else:
		parent_body.gravity_scale = 1.0
		parent_body.linear_velocity = Vector2.ZERO

func handle_stone_age():
	if Global.EnemyinRange:
		if Input.is_action_just_pressed("Ability"):
			Global.launch_power = 0
			animation_player.play("Enemy Shake")

		if Input.is_action_pressed("Ability"):
			Global.launch_power += 0.5
			Global.launch_power = min(Global.launch_power, 30)

		if Input.is_action_just_released("Ability"):
			Global.launched = true
			launch_timer.start()

			if player.global_position.x < parent_body.global_position.x:
				scared_right()
			else:
				scared_left()

	elif not Global.EnemyinRange and not Global.launched:
		animation_player.play("RESET")

	if Global.launched and time_out and ray_cast_down.is_colliding():
		animation_player.play("RESET")
		Global.launched = false
		time_out = false

func scared_right():
	parent_body.apply_impulse(Vector2(run_speed, jump_power) * Global.launch_power)

func scared_left():
	parent_body.apply_impulse(Vector2(-run_speed, jump_power) * Global.launch_power)

func _on_launch_timer_timeout() -> void:
	time_out = true
