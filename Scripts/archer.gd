extends RigidBody2D

@export var arrow_scene: PackedScene
@export var move_speed: float = 60.0
@export var preferred_distance: float = 300.0
@export var minimum_distance: float = 150.0
@export var bow_rotation_speed: float = 1.0
@export var player_path: NodePath  # ← Player path exposed

@onready var shoot_timer: Timer = $ShootTimer
@onready var bow_pivot: Node2D = $BowPivot
@onready var bow: Node2D = $BowPivot/Bow
@onready var enemy_logic: Node = $EnemyLogic

var player: CharacterBody2D

func _ready() -> void:
	if player_path != null and player_path != NodePath(""):
		player = get_node(player_path) as CharacterBody2D
		enemy_logic.player_path = player_path  # pass path down!
	else:
		push_error("Parent node: player_path not assigned!")

	shoot_timer.wait_time = 2.0
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	shoot_timer.start()

func _physics_process(delta: float) -> void:
	if not player:
		return

	# Base logic from EnemyLogic
	if Global.stone_age:
		enemy_logic.handle_stone_age()
	elif Global.medieval_age and Global.EnemyinRange:
		if Input.is_action_pressed("Ability"):
			enemy_logic.float_toward_player()

	# Archer-specific behavior
	handle_archer_movement()
	aim_bow(delta)

func handle_archer_movement() -> void:
	var to_player = player.global_position - global_position
	var distance = to_player.length()
	var movement = Vector2.ZERO

	if distance < minimum_distance:
		movement = -to_player.normalized() * move_speed
	elif distance > preferred_distance:
		movement = to_player.normalized() * move_speed

	apply_central_force(movement)

func aim_bow(delta: float) -> void:
	var target_angle = (player.global_position - bow_pivot.global_position).angle()
	bow_pivot.rotation = lerp_angle(bow_pivot.rotation, target_angle, 0.1) + bow_rotation_speed * delta

func _on_shoot_timer_timeout() -> void:
	if not is_instance_valid(player):
		return

	var arrow = arrow_scene.instantiate()
	get_parent().add_child(arrow)

	var direction = (player.global_position - bow.global_position).normalized()

	bow_pivot.rotation = direction.angle()
	arrow.global_position = bow.global_position
	arrow.rotation = direction.angle()

	if arrow.has_method("set_direction"):
		arrow.set_direction(direction)
