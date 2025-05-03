extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Coyote time & jump buffer
const COYOTE_TIME = 0.2
const JUMP_BUFFER_TIME = 0.15

# State
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0


# Nodes
@onready var sprite: Sprite2D = $Sprite2D

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta


	# Update coyote timer
	if is_on_floor():
		coyote_timer = COYOTE_TIME
	else:
		coyote_timer = max(coyote_timer - delta, 0.0)

	# Update jump buffer
	if Input.is_action_just_pressed("move_up") or Input.is_action_just_pressed("jump"):
		jump_buffer_timer = JUMP_BUFFER_TIME
	else:
		jump_buffer_timer = max(jump_buffer_timer - delta, 0.0)

	# Perform jump if buffered and within coyote window
	if coyote_timer > 0.0 and jump_buffer_timer > 0.0:
		velocity.y = JUMP_VELOCITY
		coyote_timer = 0.0
		jump_buffer_timer = 0.0

	# Horizontal movement
	var direction := Input.get_axis("move_left", "move_right")
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Flip sprite
	if Input.is_action_pressed("move_left"):
		sprite.flip_h = true
	elif Input.is_action_pressed("move_right"):
		sprite.flip_h = false

	# Apply movement
	move_and_slide()


	# Weapon and age changes (outside movement/jump logic)
	if Input.is_action_just_pressed("weapon_change"):
		Global.weapon1 = !Global.weapon1
		Global.weapon2 = !Global.weapon2

	if Input.is_action_just_pressed("Change Age"):
		if Global.stone_age:
			medieval_age()
		else:
			stone_age()

	if Input.is_action_just_pressed("Reload"):
		get_tree().reload_current_scene()

func stone_age():
	Global.stone_age = true
	Global.medieval_age = false
	print("Stone Age")

func medieval_age():
	Global.stone_age = false
	Global.medieval_age = true
	print("Medieval Age")
