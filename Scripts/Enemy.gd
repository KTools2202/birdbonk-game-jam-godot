extends RigidBody2D

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var terrain: TileMapLayer = $"../Terrain"
@onready var sfx: AudioStreamPlayer = $"../AudioStreamPlayer"
@onready var ray_cast_down: RayCast2D = $RayCastDown
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var launch_timer: Timer = $"Launch Timer"


var collider
var run_speed = 10
var jump_power = -25
var launch_power = 0
var launched = false
var time_out = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("RESET")
	



func _physics_process(delta: float) -> void:
	
		
	
	if Global.stone_age == true:
		
		
		
		if Input.is_action_just_pressed("Ability"):
			launch_power = 0
		
		
		# Starts animation 
		if Input.is_action_just_pressed("Ability"):
			
			if ray_cast_left.is_colliding() or ray_cast_right.is_colliding():
				animation_player.play("Enemy Shake")
			
		if Input.is_action_pressed("Ability"):
			launch_power += 1
		
		
		
		#Starts timer when launched to prevent imediate animation stop
		if Input.is_action_just_released("Ability"):
			launched = true
			launch_timer.start()
			
			
			
			#Caps launch power at 30
			if launch_power > 30:
				launch_power = 30
			
			if ray_cast_left.is_colliding():
				scared_right()
				
		
			if ray_cast_right.is_colliding():
				scared_left()
		
		if launched == true && time_out == true && ray_cast_down.is_colliding():
				animation_player.play("RESET")
				launched = false
				time_out = false
			

	if Global.medieval_age == true:
		
		if Input.is_action_just_pressed("Ability"):
			launch_power = 0
		
		if Input.is_action_pressed("Ability"):
			launch_power += 1
		
		if Input.is_action_just_released("Ability"):
			
			
			if launch_power > 30:
				launch_power = 30

			#Medieval Man ability attracts people
			if ray_cast_left.is_colliding():
				attract_Right()
				
			if ray_cast_right.is_colliding():
				attract_Left()
	
func scared_right():
	apply_impulse(Vector2(run_speed, jump_power) * launch_power)
	
func scared_left():
	apply_impulse(Vector2(-run_speed, jump_power) * launch_power)
	
func attract_Right():
	apply_impulse(Vector2(-run_speed, jump_power) * launch_power)

func attract_Left():
	apply_impulse(Vector2(run_speed, jump_power) * launch_power)
	
	
func _on_launch_timer_timeout() -> void:
	time_out = true
