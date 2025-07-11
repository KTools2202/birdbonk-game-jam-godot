extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var open = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.platedown1 == true && open == false:
		animation_player.play("Open")
		open = true
	if open == true && Global.platedown1 == false:
		animation_player.play("Close")
		open = false
	
