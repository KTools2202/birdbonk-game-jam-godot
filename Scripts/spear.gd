extends CharacterBody2D


@onready var spear: Node2D = $"."
@onready var sprite: Sprite2D = $Sprite2D



var is_holding = false  # To track whether the button is being held down
var speed = 1000
var flying = false
var flipped = false
var thrown = false
var flyingRight = false
var flyingLeft = false
var leftLimit = -50
var rightLimit = 50
var yPos
var defaultPos = -50


func _ready() -> void:
	position.y = defaultPos

func _physics_process(delta: float) -> void:
	
	queue_free()
	
	if Global.weapon1 == true && Global.stone_age == true:
		show()
	else:
		hide()
	
	#Runs repeatedly when action pressed
	if Input.is_action_pressed("attack"):
			is_holding = true
			
	#Runs if action isn't pressed
	else:
		is_holding = false
	
	#Runs when action is released
	if Input.is_action_just_released("attack"):
		thrown = true
		is_holding = false
		
		
	# Aiming
	if is_holding == true && flipped == true:
		if position.x < rightLimit:
			position += Vector2.RIGHT * 3

	if is_holding == true && flipped == false:
		if position.x > leftLimit:
			position += Vector2.LEFT * 3
			
	if thrown:
		get_yPos()
		if flipped == false:
			flyingRight = true
			thrown = false
		else:
			flyingLeft = true
			thrown = false
			
	if flyingRight == true:
		flying = true
		position += Vector2.RIGHT * speed * delta
	
	if flyingLeft == true:
		flying = true
		position += Vector2.LEFT * speed * delta
		
	if flying == true:
		global_position.y = yPos
	
	#Flips the player when moving left or right
	if Input.is_action_pressed("move_left") && not flying:
		sprite.flip_h = true
		sprite.flip_v = true
		flipped = true
		
	if Input.is_action_pressed("move_right") && not flying:
		sprite.flip_h = false
		sprite.flip_v = false
		flipped = false
		
	if Input.is_action_just_pressed("Reload"):
		position.x = 0
		position.y = defaultPos
		flyingLeft = false
		flyingRight = false
		flying = false

# Saves y position
func get_yPos():
	yPos = global_position.y
	

	
