extends CharacterBody2D

var Swinging = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	queue_free()
	
	if Global.weapon2 == true && Global.stone_age == true:
		show()
	else:
		hide()
	
	if Input.is_action_just_pressed("attack"):
		rotation_degrees = -45
		Swinging = true 
		
	if Swinging == true && rotation_degrees < 45:
		rotate(0.2)
		
	
	if rotation_degrees == 45:
		Swinging = false
