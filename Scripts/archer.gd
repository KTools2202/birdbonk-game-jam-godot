extends RigidBody2D

@export var arrow_scene: PackedScene
@export var move_speed: float = 60.0
@export var preferred_distance: float = 300.0
@export var minimum_distance: float = 150.0
@export var float_speed = 50
@export var run_speed = 10
@export var jump_power = -25
const COLLISION_LAYER_MASK = 1 << 11  # or whatever layer your terrain uses


@onready var terrain: TileMapLayer = $".../Terrains/Terrian2"
@onready var sfx: AudioStreamPlayer = $"../AudioStreamPlayer"
@onready var bubble: Area2D = $Bubble
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var launch_timer: Timer = $"Launch Timer"
@onready var shoot_timer: Timer = $"ShootTimer"
@onready var player: CharacterBody2D = ($"../../Player")

var collider
@export var time_out = false
@export var shaking = false

func _ready() -> void:
	animation_player.play("RESET")
	shoot_timer.wait_time = 2.0
	shoot_timer.start()
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
func _on_launch_timer_timeout() -> void:
	time_out = true
func _physics_process(delta: float) -> void:
	if not player: return

	if Global.stone_age:
		handle_stone_age()

	elif Global.medieval_age and Global.EnemyinRange:
		if Input.is_action_pressed("Ability"):
			float_toward_player(delta)

	# Archer AI movement (always active)
	handle_archer_movement(delta)

func handle_stone_age():
	if Input.is_action_just_pressed("Ability"):
		Global.launch_power = 0
		animation_player.play("Enemy Shake")

	if Input.is_action_pressed("Ability"):
		Global.launch_power += 0.5
		if Global.launch_power > 30:
			Global.launch_power = 30

	if Input.is_action_just_released("Ability"):
		Global.launched = true
		launch_timer.start()
		if player.global_position.x < global_position.x:
			scared_right()
		else:
			scared_left()

	if Global.launched and time_out and bubble_detected():
		animation_player.play("RESET")
		Global.launched = false
		time_out = false
func bubble_detected() -> bool:
	for body in bubble.get_overlapping_bodies():
		if body.collision_layer & COLLISION_LAYER_MASK != 0:
			return true
	return false

func float_toward_player(_delta: float) -> void:
	var direction = (player.global_position - global_position).normalized()
	apply_impulse(direction * float_speed)

func scared_right():
	apply_impulse(Vector2(run_speed, jump_power) * Global.launch_power)

func scared_left():
	apply_impulse(Vector2(-run_speed, jump_power) * Global.launch_power)



func handle_archer_movement(delta: float) -> void:
	var to_player = player.global_position - global_position
	var distance = to_player.length()
	look_at(player.global_position)

	var movement = Vector2.ZERO
	if distance < minimum_distance:
		movement = -to_player.normalized() * move_speed
	elif distance > preferred_distance:
		movement = to_player.normalized() * move_speed

	# Apply movement via force (RigidBody2D)
	apply_central_force(movement)

func _on_shoot_timer_timeout():
	if not player or not is_instance_valid(player):
		return

	var arrow = arrow_scene.instantiate()
	get_parent().add_child(arrow)
	arrow.global_position = global_position
	arrow.rotation = (player.global_position - global_position).angle()

	if arrow.has_method("set_direction"):
		arrow.set_direction((player.global_position - global_position).normalized())
