extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var animation_player: AnimationPlayer = $AnimatableBody2D/AnimationPlayer
@onready var animatable_body_2d: AnimatableBody2D = $AnimatableBody2D


@export var plate_down = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body) -> void:
	if plate_down == false:
		plate_down = true
		animation_player.play("Plate Down")
		Global.platedown1 = true
	


func _on_area_2d_body_exited(body) -> void:
	if plate_down == true:
		plate_down = false
		animation_player.play("Plate Up")
		Global.platedown1 = false
