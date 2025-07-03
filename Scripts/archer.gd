extends RigidBody2D

@export var arrow_scene: PackedScene
@export var move_speed: float = 60.0
@export var preferred_distance: float = 300.0
@export var minimum_distance: float = 150.0
@export var float_speed = 50
@export var run_speed = 10
@export var jump_power = -25

@onready var terrain: TileMapLayer = $".../Terrains/Terrian2"
@onready var sfx: AudioStreamPlayer = $"../AudioStreamPlayer"
@onready var ray_cast_down: RayCast2D = $RayCastDown
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var launch_timer: Timer = $"Launch Timer"
@onready var shoot_timer: Timer = $ShootTimer
@onready var player: CharacterBody2D = ($"../../Player")
@onready var enemy: RigidBody2D = $"."


var collider
@export var time_out = false
@export var shaking = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("RESET")

func _physics_process(delta: float) -> void:
	if Global.stone_age == true:
		# Implement launch mechanics as before
		handle_stone_age()

	elif Global.medieval_age == true and Global.EnemyinRange == true:
		# Make the enemy float toward the player if right-click is held
		if Input.is_action_pressed("Ability"):
			float_toward_player(delta)  # Pass delta for smooth frame-based movement
		

func float_toward_player(_delta: float) -> void:
	# Calculate direction to the player
	var direction_to_player = (player.global_position - global_position).normalized()
	#print ("Sliding")
	# Set linear velocity to move toward the player
	apply_impulse(direction_to_player * float_speed) 
	
	
func handle_stone_age():
	
	if Input.is_action_just_pressed("Ability"):
		Global.launch_power = 0

	# Starts animation 
	if Input.is_action_just_pressed("Ability"):
		animation_player.play("Enemy Shake")
		
	if Input.is_action_pressed("Ability"):
		Global.launch_power += 0.5

	# Starts timer when launched to prevent immediate animation stop
	if Input.is_action_just_released("Ability"):
		Global.launched = true
		launch_timer.start()
		print ("launched: ", Global.launched)
		print ("time out:", time_out)
		print ("raycast colliding: ", ray_cast_down.is_colliding())
		
		if player.global_position.x < enemy.global_position.x:
			scared_right()
		else:
			scared_left()
			
		# Caps launch power at 30
		if Global.launch_power > 30:
			Global.launch_power = 30
		
	if Global.launched == true && time_out == true && ray_cast_down.is_colliding():
		animation_player.play("RESET")
		Global.launched = false
		time_out = false
		
func scared_right():
	apply_impulse(Vector2(run_speed, jump_power) * Global.launch_power)

func scared_left():
	apply_impulse(Vector2(-run_speed, jump_power) * Global.launch_power)

func _on_launch_timer_timeout() -> void:
	time_out = true
