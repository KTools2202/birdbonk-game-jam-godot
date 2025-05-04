extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var hit_sound: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
@onready var hit_sound_stream: AudioStream = preload("res://Music and SFX/hit-rock-02-266304.mp3")

var is_holding = false
var speed = 500  # Speed for aiming and flight
var flying = false
var yPos: float
var defaultPos = -50
var throw_dir = Vector2.ZERO
var held_mouse_position = Vector2.ZERO
var thrown_position = Vector2.ZERO

const COLLISION_LAYER_MASK = 1 << 11  

func _ready() -> void:
	# Initialize spear under player
	position = Vector2(0, defaultPos)
	yPos = position.y
	hit_sound.stream = hit_sound_stream
	hit_sound.volume_db = 0  # Base volume, falloff will control perceived loudness
	hit_sound.attenuation = 1.5
	hit_sound.max_distance = 800
	add_child(hit_sound)

func _physics_process(_delta: float) -> void:
	# Show/hide spear based on global state
	visible = Global.weapon1 and Global.stone_age

	# While aiming: attach spear to player and rotate toward cursor
	if is_holding and not flying:
		var target_global = get_global_mouse_position()
		look_at(target_global)
		rotation = (target_global - global_position).angle()
		position = Vector2(0, defaultPos)
		queue_redraw()

	# When attack released and not flying, throw spear
	if Input.is_action_just_released("attack") and is_holding and not flying:
		held_mouse_position = get_global_mouse_position()
		throw_dir = (held_mouse_position - global_position).normalized()
		thrown_position = global_position
		flying = true
		is_holding = false
		queue_redraw()

	# While flying: move spear independently
	if flying:
		thrown_position += throw_dir * speed * _delta
		global_position = thrown_position
		rotation = throw_dir.angle()

		# Reset immediately if hit terrain
		if should_reset():
			if not hit_sound.playing:
				hit_sound.global_position = global_position
				hit_sound.play()
			reset_spear()

	# Start aiming
	if Input.is_action_just_pressed("attack") and not flying:
		is_holding = true
		queue_redraw()

	# Manual reset
	if Input.is_action_just_pressed("Reload"):
		reset_spear()
		queue_redraw()

func get_global_y_lock() -> float:
	return get_parent().global_position.y + yPos

func reset_spear():
	position = Vector2(0, defaultPos)
	rotation = 0
	flying = false
	is_holding = false
	thrown_position = global_position
	queue_redraw()

func should_reset() -> bool:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.new()
	query.from = global_position
	query.to = global_position + throw_dir * 20  # Increased ray length
	query.collide_with_areas = false
	query.collide_with_bodies = true
	query.collision_mask = COLLISION_LAYER_MASK
	query.exclude = [self, get_parent()]
	var result = space_state.intersect_ray(query)
	if result:
		print("Hit: ", result.collider)
		return true
	return false

func _draw():
	if is_holding and not flying:
		var end_pos = to_local(get_global_mouse_position())
		draw_line(Vector2.ZERO, end_pos.normalized() * 20, Color.RED, 1.5)
	elif flying:
		draw_line(Vector2.ZERO, to_local(global_position + throw_dir * 20), Color.RED, 2)
