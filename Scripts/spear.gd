extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D

var is_holding = false
var speed = 500  # Speed for aiming and flight
var flying = false
var thrown = false
var yPos: float
var defaultPos = -50
var throw_dir = Vector2.ZERO
var throw_velocity = Vector2.ZERO
var return_timer = 0.0
const RETURN_DURATION = 0.5

const COLLISION_LAYER_MASK = 1 << 3  # Updated to Layer 4

@onready var hit_sound := preload("res://Music and SFX/hit-rock-02-266304.mp3")
@onready var audio_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()

func _ready() -> void:
	# Initialize spear under player
	position = Vector2(0, defaultPos)
	yPos = position.y
	add_child(audio_player)
	audio_player.stream = hit_sound
	audio_player.attenuation = 1.0
	audio_player.volume_db = 3.0  # Louder
	audio_player.max_distance = 2000.0
	audio_player.autoplay = false
	audio_player.bus = "SFX"
	audio_player.position = Vector2.ZERO

func _physics_process(delta: float) -> void:
	# Show/hide spear based on global state
	visible = Global.weapon1 and Global.stone_age

	# Input: hold and release
	if Input.is_action_just_pressed("attack") and not flying:
		is_holding = true
		return_timer = 0.0

	# Aiming: while holding, move toward cursor and rotate
	if is_holding and not flying:
		return_timer += delta
		var target_global = get_global_mouse_position()
		look_at(target_global)
		position = position.lerp(Vector2(0, defaultPos), return_timer / RETURN_DURATION)
		yPos = position.y

	# Release to throw
	if Input.is_action_just_released("attack") and is_holding and not flying and return_timer >= RETURN_DURATION:
		flying = true
		is_holding = false
		var global_pos = to_global(position)
		throw_dir = (get_global_mouse_position() - global_position).normalized()

		# Include player's velocity if same direction
		var player = get_parent()
		var player_vel = Vector2.ZERO
		if player.has_method("get_velocity"):
			player_vel = player.get_velocity()
		if sign(player_vel.x) == sign(throw_dir.x):
			throw_velocity = throw_dir * speed + Vector2(player_vel.x, 0)
		else:
			throw_velocity = throw_dir * speed

	# Flight: move along locked direction and maintain rotation
	if flying:
		var global_pos = to_global(position) + throw_velocity * delta
		global_pos.y = get_global_y_lock()
		position = to_local(global_pos)
		look_at(global_pos)
		if should_reset(global_pos):
			play_hit_sound()
			reset_spear()

	# Manual reset
	if Input.is_action_just_pressed("Reload"):
		reset_spear()

func get_global_y_lock() -> float:
	return get_parent().global_position.y + yPos

func reset_spear():
	position = Vector2(0, defaultPos)
	rotation = 0
	flying = false
	thrown = false
	return_timer = 0.0

func should_reset(global_pos: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = global_pos
	query.collide_with_areas = false
	query.collide_with_bodies = true
	query.collision_mask = COLLISION_LAYER_MASK
	query.exclude = [self, get_parent()]
	for r in space_state.intersect_point(query):
		if r.collider is TileMap:
			return true
	return false

func play_hit_sound():
	audio_player.global_position = global_position
	audio_player.play()
