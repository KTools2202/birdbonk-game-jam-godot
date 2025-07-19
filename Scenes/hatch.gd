extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

##var open = false

##func _ready() -> void:
#	pass

##func _process(delta: float) -> void:
#	if Global.HatchOpen1 == true and open == false:
#		animation_player.play("Open")
#		open = true
#	elif Global.HatchOpen1 == false and open == true:
#		animation_player.play("Close")
#		open = false

	# Check for restart input (Tab key)
#	if Input.is_action_just_pressed("Restart"):
#		print("Restart pressed!")
#		_reset()

##func _reset():
#	Global.HatchOpen1 = false
#	animation_player.play("Close")
#	open = false
