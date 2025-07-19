extends RigidBody2D

@export var player_path: NodePath
@export var arrow_scene: PackedScene
@export var move_speed: float = 60.0
@export var preferred_distance: float = 300.0
@export var minimum_distance: float = 150.0
@export var gravity: float = 500.0

@onready var shoot_timer = $ShootTimer
@onready var player = get_node(player_path)
var is_in_zone = false

func _ready():
	shoot_timer.wait_time = 2.0
	shoot_timer.start()
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)

	# Use full control of movement
	custom_integrator = true

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if not player:
		return

	# Get current velocity
	var lv = state.linear_velocity

	# Apply gravity manually (Y axis)
	lv.y += gravity * state.step

	# Distance & direction
	var to_player = player.global_position - global_position
	var distance = to_player.length()

	# Face the player
	look_at(player.global_position)

	# Only move horizontally
	if distance < minimum_distance:
		lv.x = -sign(to_player.x) * move_speed
	elif distance > preferred_distance:
		lv.x = sign(to_player.x) * move_speed
	else:
		lv.x = 0

	state.linear_velocity = lv

func _on_shoot_timer_timeout():
	if not player or not is_instance_valid(player):
		return

	var arrow = arrow_scene.instantiate()
	get_parent().add_child(arrow)
	arrow.global_position = global_position
	arrow.rotation = (player.global_position - global_position).angle()

	if arrow.has_method("set_direction"):
		arrow.set_direction((player.global_position - global_position).normalized())


func _on_area_2d_body_entered(body):
	if body == self:
		is_in_zone = true

func _on_area_2d_body_exited(body):
	if body == self:
		is_in_zone = false
