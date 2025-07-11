extends CharacterBody2D

@export var player_path: NodePath
@export var arrow_scene: PackedScene
@export var move_speed: float = 60.0
@export var preferred_distance: float = 300.0
@export var minimum_distance: float = 150.0

@onready var shoot_timer = $ShootTimer
@onready var player = get_node(player_path)

func _ready():
	shoot_timer.wait_time = 2.0  # seconds between shots
	shoot_timer.start()
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)

func _physics_process(delta):
	if not player: return

	var to_player = player.global_position - global_position
	var distance = to_player.length()

	# Face player
	look_at(player.global_position)

	# Move away if too close
	if distance < minimum_distance:
		velocity = -to_player.normalized() * move_speed
	elif distance > preferred_distance:
		# Move closer if too far (optional)
		velocity = to_player.normalized() * move_speed
	else:
		# Stay in place if within range
		velocity = Vector2.ZERO

	move_and_slide()

func _on_shoot_timer_timeout():
	if not player or not is_instance_valid(player):
		return

	var arrow = arrow_scene.instantiate()
	get_parent().add_child(arrow)
	arrow.global_position = global_position
	arrow.rotation = (player.global_position - global_position).angle()
	
	# You can also pass velocity/direction to the arrow
	if arrow.has_method("set_direction"):
		arrow.set_direction((player.global_position - global_position).normalized())
