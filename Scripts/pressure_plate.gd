extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var animation_player: AnimationPlayer = $AnimatableBody2D/AnimationPlayer
@onready var animatable_body_2d: AnimatableBody2D = $AnimatableBody2D

@export var plate_down = false
@export var lock_on_activate: bool = false  # Lock plate when activated?

@export var bridge: NodePath  # Assign your bridge node here
var bridge_node: Node = null

func _ready() -> void:
	if bridge != null:
		bridge_node = get_node(bridge)

func _on_area_2d_body_entered(body) -> void:
	# Only trigger if the body is a player or enemy
	if not body.is_in_group("player") and not body.is_in_group("enemy"):
		return

	if not plate_down:
		print("Activated by:", body)
		plate_down = true
		animation_player.play("Plate Down")

		if bridge_node != null and bridge_node.has_node("AnimationPlayer"):
			var bridge_anim = bridge_node.get_node("AnimationPlayer")
			bridge_anim.play("Fall")

		if lock_on_activate:
			area_2d.monitoring = false  # Lock: ignore exit


func _on_area_2d_body_exited(body) -> void:
	if lock_on_activate:
		return

	if not body.is_in_group("player") and not body.is_in_group("enemy"):
		return

	if plate_down:
		print("Deactivated by:", body)
		plate_down = false
		animation_player.play("Plate Up")

		if bridge_node != null and bridge_node.has_node("AnimationPlayer"):
			var bridge_anim = bridge_node.get_node("AnimationPlayer")
			bridge_anim.play_backwards("Fall")
