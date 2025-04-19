extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var player: CharacterBody2D = $"."
@onready var sprite: Sprite2D = $Sprite2D
@onready var spear: CharacterBody2D = $"."


func _physics_process(delta: float) -> void:
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("move_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_pressed("move_left"):
		sprite.flip_h = true
	
	move_and_slide()
	
	if Input.is_action_just_pressed("weapon_change"):
		if Global.weapon1 == true:
			Global.weapon1 = false
			Global.weapon2 = true
		else:
			Global.weapon1 = true
			Global.weapon2 = false
