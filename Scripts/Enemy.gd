extends RigidBody2D

@onready var terrain: TileMapLayer = $".../Terrains/Terrian2"
@onready var sfx: AudioStreamPlayer = $"../AudioStreamPlayer"
@onready var ray_cast_down: RayCast2D = $RayCastDown
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var launch_timer: Timer = $"Launch Timer"
@onready var player: CharacterBody2D = $"../../Player"
@onready var enemy: RigidBody2D = $"."
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
var last_direction = ""  # "left", "right", or ""
@onready var trail_particles: CPUParticles2D = $CPUParticles2D

var collider
@export var run_speed = 10
@export var float_speed = 50  # Speed of floating towards the player
@export var jump_power = -25
@export var time_out = false
@export var shaking = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("RESET")
	
func _process(delta: float) -> void:
	if ray_cast_left.is_colliding() and last_direction != "left":
		last_direction = "left"
		print("LEFT")
		ChargeLeft()
	elif ray_cast_right.is_colliding() and last_direction != "right":
		last_direction = "right"
		print("RIGHT")
		ChargeRight()
	elif not ray_cast_left.is_colliding() and not ray_cast_right.is_colliding():
		last_direction = ""  # Reset when nothing is hit
		
func _physics_process(delta: float) -> void:
	if Global.stone_age == true:
		# Implement launch mechanics as before
		handle_stone_age()
	elif Global.medieval_age == true and Global.EnemyinRange == true:
		# Make the enemy float toward the player if right-click is held
		if Input.is_action_pressed("Ability"):
			float_toward_player(delta)  # Pass delta for smooth frame-based movement
		
	trail_particles.emitting = not ray_cast_down.is_colliding()
func float_toward_player(_delta: float) -> void:
	# Calculate direction to the player
	var direction_to_player = (player.global_position - global_position).normalized()
	#print ("Sliding")
	# Set linear velocity to move toward the player
	apply_impulse(direction_to_player * float_speed) 
	
	
func handle_stone_age():
	if player.area_2d.get_overlapping_bodies().has(self):
		if Input.is_action_just_pressed("Ability"):
			Global.launch_power = 0
			animation_player.play("Enemy Shake")

		elif Input.is_action_pressed("Ability"):
			Global.launch_power += 0.5

		elif Input.is_action_just_released("Ability"):
			# Clamp launch power before launching
			Global.launch_power = clamp(Global.launch_power, 0, 30)

			Global.launched = true
			launch_timer.start()

			if player.global_position.x < enemy.global_position.x:
				scared_right()
			else:
				scared_left()
	else:
		if not Global.launched:
			animation_player.play("RESET")

	# Reset state once landed
	if Global.launched and time_out and ray_cast_down.is_colliding():
		animation_player.play("RESET")
		Global.launched = false
		time_out = false

		
	elif Global.EnemyinRange == false && Global.launched == false:
		animation_player.play("RESET")
		
		
		
	if Global.launched == true && time_out == true && ray_cast_down.is_colliding():
		animation_player.play("RESET")
		Global.launched = false
		time_out = false
	
		
func scared_right():
	apply_impulse(Vector2(run_speed, jump_power) * Global.launch_power)

func scared_left():
	apply_impulse(Vector2(-run_speed, jump_power) * Global.launch_power)
	
func ChargeRight():
	#apply_impulse(Vector2(run_speed, 0))
	pass

func ChargeLeft():
	#apply_impulse(Vector2(-run_speed, 0))
	pass
	
func _on_launch_timer_timeout() -> void:
	time_out = true
