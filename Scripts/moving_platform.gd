extends Node2D


@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player_2.play("Moving Platform")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
