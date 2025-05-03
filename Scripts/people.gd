extends RigidBody2D

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var terrain: TileMapLayer = $"../Terrain"
@onready var sfx: AudioStreamPlayer = $"../AudioStreamPlayer"
@onready var ray_cast_down: RayCast2D = $RayCastDown

var collider
var run_speed = 10
var jump_power = -25
var launch_power = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func _physics_process(delta: float) -> void:
	
	
	if Global.stone_age == true:
		
		if Input.is_action_just_pressed("Ability"):
			sfx.play()
		
		if Input.is_action_just_pressed("Ability"):
			Global.use_ability = true
			
			
			
		if Input.is_action_pressed("Ability"):
			launch_power += 1
		
		if Input.is_action_just_released("Ability"):
			print (launch_power)
		
			if launch_power > 30:
				launch_power = 30
			
			if ray_cast_left.is_colliding():
				scared_right()
				
		
			if ray_cast_right.is_colliding():
				scared_left()
	
			

	if Global.medieval_age == true:
		if Input.is_action_pressed("Ability"):
			Global.use_ability = true
	
			#Caveman ability repels people
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
