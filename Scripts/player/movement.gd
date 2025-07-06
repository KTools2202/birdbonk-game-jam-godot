extends Node

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var JUMP_BUFFER = 0.15
@export var COYOTE_TIME = 0.1
@export var MAX_BHOP_SPEED = 400.0
@export var SPEED_GAIN = 20.0
@export var AIR_CONTROL = 2000.0

var jump_buffer_timer = 0.0
var coyote_timer = 0.0

func physics_move(player: CharacterBody2D, delta: float) -> void:
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta
	if not player.is_on_floor():
		coyote_timer -= delta
	else:
		coyote_timer = COYOTE_TIME

	if Input.is_action_pressed("move_up") or Input.is_action_pressed("jump"):
		jump_buffer_timer = JUMP_BUFFER

	if jump_buffer_timer > 0 and coyote_timer > 0:
		jump_buffer_timer = 0
		player.velocity.y = JUMP_VELOCITY
		var axis = Input.get_axis("move_left", "move_right")
		if axis != 0:
			player.velocity.x += SPEED_GAIN * sign(axis)
			player.velocity.x = clamp(player.velocity.x, -MAX_BHOP_SPEED, MAX_BHOP_SPEED)

	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta

	var dir := Input.get_axis("move_left", "move_right")
	if player.is_on_floor():
		if dir:
			if abs(player.velocity.x) < SPEED:
				player.velocity.x = dir * SPEED
		else:
			player.velocity.x = move_toward(player.velocity.x, 0, SPEED)
	else:
		player.velocity.x = move_toward(player.velocity.x, dir * MAX_BHOP_SPEED, AIR_CONTROL * delta)

	player.move_and_slide()
