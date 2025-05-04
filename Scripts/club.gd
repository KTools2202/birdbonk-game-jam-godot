extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D

var Swinging = false
var swing_timer = 0.0
const SWING_DURATION = 0.5
var flipped = false
var default_x_offset = -55

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Global.weapon2 == true and Global.stone_age == true:
		show()
	else:
		hide()

	# Determine direction (assuming left/right movement keys)
	if Input.is_action_pressed("move_left"):
		flipped = true
		position.x = default_x_offset
	elif Input.is_action_pressed("move_right"):
		flipped = false
		position.x = 55

	if Input.is_action_just_pressed("attack") and not Swinging:
		Swinging = true
		swing_timer = SWING_DURATION
		rotation_degrees = 45 if flipped else -45

	if Swinging:
		if flipped:
			if rotation_degrees > -45:
				rotate(-0.2)
		else:
			if rotation_degrees < 45:
				rotate(0.2)

		swing_timer -= delta
		if swing_timer <= 0.0:
			Swinging = false
			rotation_degrees = 0
