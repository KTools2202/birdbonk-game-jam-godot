extends CharacterBody2D

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var terrain: TileMapLayer = $"../Terrain"

var collider
var run_speed = 250
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()
	
	if Global.stone_age == true:
		if Input.is_action_pressed("Ability"):
			Global.use_ability = true
			#Caveman ability repels people
			if ray_cast_left.is_colliding():
				position += Vector2.RIGHT * run_speed * delta
		
			if ray_cast_right.is_colliding():
				position += Vector2.LEFT * run_speed * delta
	
	if Global.medieval_age == true:
		if Input.is_action_pressed("Ability"):
			Global.use_ability = true
			#Caveman ability repels people
			if ray_cast_left.is_colliding():
				position += Vector2.LEFT * run_speed * delta
				
		
			if ray_cast_right.is_colliding():
				position += Vector2.RIGHT * run_speed * delta
			
		
	
		
