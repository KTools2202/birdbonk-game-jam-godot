extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const JUMP_BUFFER = 0.15
const COYOTE_TIME = 0.1
const BOOST_SPEED = 50
const MAX_BHOP_SPEED = 600.0
const SPEED_GAIN = 20.0
const AIR_CONTROL = 2000.0  # Strong air control factor

@onready var sprite: Sprite2D = $Sprite2D

var jump_buffer_timer = 0.0
var coyote_timer = 0.0

func _ready() -> void:
	stone_age()

func _physics_process(delta: float) -> void:
	# Timers
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta
	if not is_on_floor():
		coyote_timer -= delta
	else:
		coyote_timer = COYOTE_TIME

	# Buffer jump input
	if Input.is_action_pressed("move_up") or Input.is_action_pressed("jump"):
		jump_buffer_timer = JUMP_BUFFER

	# Perform buffered jump if grounded (or within coyote time)
	if jump_buffer_timer > 0 and coyote_timer > 0:
		jump_buffer_timer = 0
		velocity.y = JUMP_VELOCITY
		if Input.get_axis("move_left", "move_right") != 0:
			velocity.x += SPEED_GAIN * sign(Input.get_axis("move_left", "move_right"))
			velocity.x = clamp(velocity.x, -MAX_BHOP_SPEED, MAX_BHOP_SPEED)

	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Movement input
	var direction := Input.get_axis("move_left", "move_right")
	if is_on_floor():
		if direction:
			if abs(velocity.x) < SPEED:
				velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		# Apply more responsive air control
		velocity.x = move_toward(velocity.x, direction * MAX_BHOP_SPEED, AIR_CONTROL * delta)

	if Input.is_action_pressed("move_left"):
		sprite.flip_h = true

	move_and_slide()

	# Weapon toggle
	if Input.is_action_just_pressed("weapon_change"):
		Global.weapon1 = not Global.weapon1
		Global.weapon2 = not Global.weapon2

	# Age switch
	if Input.is_action_just_pressed("Change Age"):
		if Global.stone_age:
			medieval_age()
		else:
			stone_age()

	if Input.is_action_just_pressed("Restart"):
		get_tree().reload_current_scene()

func stone_age():
	Global.stone_age = true
	Global.medieval_age = false
	print("Stone Age")

func medieval_age():
	Global.stone_age = false
	Global.medieval_age = true
	print("Medieval Age")
