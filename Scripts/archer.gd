extends RigidBody2D

@export var arrow_scene: PackedScene
@export var move_speed: float = 60.0
@export var preferred_distance: float = 300.0
@export var minimum_distance: float = 150.0
@export var float_speed = 50
@export var run_speed = 10
@export var jump_power = -25
@export var bow_rotation_speed: float = 1.0  # radians per second, adjust as needed

const COLLISION_LAYER_MASK = 1 << 11  # or whatever layer your terrain uses


@onready var terrain: TileMapLayer = $".../Terrains/Terrian2"
@onready var sfx: AudioStreamPlayer = $"../AudioStreamPlayer"
@onready var ray_cast_down: RayCast2D = $RayCastDown
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var launch_timer: Timer = $"Launch Timer"
@onready var shoot_timer: Timer = $"ShootTimer"
@onready var player: CharacterBody2D = ($"../../Player")
@onready var bow_pivot: Node2D = $BowPivot
@onready var bow: Node2D = $BowPivot/Bow



var collider
@export var time_out = false
@export var shaking = false

func _ready() -> void:
	animation_player.play("RESET")
	shoot_timer.wait_time = 2.0
	shoot_timer.start()
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	lock_rotation = true
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
	var target_angle = (player.global_position - bow_pivot.global_position).angle()
	
	# Slowly interpolate bow_pivot rotation toward target_angle + spinning
	bow_pivot.rotation = lerp_angle(bow_pivot.rotation, target_angle, 0.1) + bow_rotation_speed * delta
func handle_stone_age():
	if Global.EnemyinRange == true:
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
				
	elif Global.EnemyinRange == false and Global.launched == false:
		animation_player.play("RESET")
	
	if Global.launched == true and time_out == true and ray_cast_down.is_colliding():
		animation_player.play("RESET")
		Global.launched = false
		time_out = false


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

	var movement = Vector2.ZERO
	if distance < minimum_distance:
		movement = -to_player.normalized() * move_speed
	elif distance > preferred_distance:
		movement = to_player.normalized() * move_speed

	apply_central_force(movement)

func _on_shoot_timer_timeout():
	if not player or not is_instance_valid(player):
		return

	var arrow = arrow_scene.instantiate()
	get_parent().add_child(arrow)

	# Get the direction from Bow to Player
	var direction = (player.global_position - bow.global_position).normalized()

	# Rotate Bow node only (not the whole body)
	bow_pivot.rotation = (player.global_position - bow_pivot.global_position).angle()

	# Spawn arrow at the Bow position
	arrow.global_position = bow.global_position
	arrow.rotation = direction.angle()

	# Optional: Set arrow movement direction
	if arrow.has_method("set_direction"):
		arrow.set_direction(direction)
