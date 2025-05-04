extends CharacterBody2D

var Swinging = false
var swing_timer = 0.0
const SWING_DURATION = 0.5

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Global.weapon2 == true && Global.stone_age == true:
		show()
	else:
		hide()

	if Input.is_action_just_pressed("attack") and not Swinging:
		rotation_degrees = -45
		Swinging = true
		swing_timer = SWING_DURATION

	if Swinging:
		if rotation_degrees < 45:
			rotate(0.2)
		swing_timer -= delta
		if swing_timer <= 0.0:
			Swinging = false
			rotation_degrees = 0
