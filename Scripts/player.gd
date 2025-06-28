extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const JUMP_BUFFER = 0.15
const COYOTE_TIME = 0.1
const BOOST_SPEED = 50
const MAX_BHOP_SPEED = 400.0
const SPEED_GAIN = 20.0
const AIR_CONTROL = 2000.0  # Strong air control factor

@onready var cave_man: Sprite2D = $Caveman
@onready var medieval_man: Sprite2D = $"Medieval man"
@onready var industrial_man: Sprite2D = $"Industrial man"
@onready var area_2d: Area2D = $Area2D
@onready var player: CharacterBody2D = $"."
@onready var timer: Timer = $Timer


var jump_buffer_timer = 0.0
var coyote_timer = 0.0
var size_stage = 1
var time_out = false
var shrinking = false

func _ready() -> void:
	stone_age()
	medieval_man.hide()
	industrial_man.hide()

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
		pass

	move_and_slide()

	# Weapon toggle
	if Input.is_action_just_pressed("weapon_change"):
		Global.weapon1 = not Global.weapon1
		Global.weapon2 = not Global.weapon2
	
	if Global.lvl == 1:
	
	# Age switch
		if Input.is_action_just_pressed("stone_age"):
			stone_age()
			
		if Input.is_action_just_pressed("medieval_age"):
			medieval_age()
			
		if Input.is_action_just_pressed("industrial_age"):
			industrial_age()
			
	if Input.is_action_just_pressed("Restart"):
		get_tree().reload_current_scene()
		
	if Global.industrial_age == true:
		
		if Input.is_action_just_pressed("Ability"):
			if size_stage == 1:
				shrink()
				timer.start()
				
			if size_stage == 2:
				grow()
				timer.start()
				
			if size_stage == 3:
				normal_size()
				timer.start()
			
			if time_out == true:
				if size_stage <= 2:
					size_stage += 1
				elif size_stage >= 3:
					size_stage = 1
			
			if shrinking == true:
				scale.x -= 0.1
				scale.y -= 0.1
				if scale.x && scale.y == 0.25:
					shrinking = false

func stone_age():
	normal_size()
	Global.stone_age = true
	Global.medieval_age = false
	Global.industrial_age = false
	print("Stone Age")
	cave_man.show()
	medieval_man.hide()
	industrial_man.hide()

func medieval_age():
	normal_size()
	Global.stone_age = false
	Global.medieval_age = true
	Global.industrial_age = false
	print("Medieval Age")
	cave_man.hide()
	medieval_man.show()
	industrial_man.hide()

func industrial_age():
	size_stage = 1
	normal_size()
	Global.stone_age = false
	Global.medieval_age = false
	Global.industrial_age = true
	print("Industrial Age")
	cave_man.hide()
	medieval_man.hide()
	industrial_man.show()

func _on_area_2d_body_entered(_body: RigidBody2D) -> void:
	print ("Body entered")
	Global.EnemyinRange = true

func _on_area_2d_body_exited(_body: RigidBody2D) -> void:
	print ("Body exited")
	Global.EnemyinRange = false

func shrink():
	print ("Small")
	shrinking = true


func grow():
	print ("Big")
	player.scale.x = 0.75
	player.scale.y = 0.75


func normal_size():
	print ("Normal")
	player.scale.x = 0.592
	player.scale.y = 0.5
