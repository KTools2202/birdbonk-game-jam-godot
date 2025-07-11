extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var animation_player: AnimationPlayer = $AnimatableBody2D/AnimationPlayer
@onready var animatable_body_2d: AnimatableBody2D = $AnimatableBody2D

@export var plate_down: bool = false
@export var lock_on_activate: bool = false  # Lock plate when activated?

@export var bridge: NodePath  # Assign your bridge node here
@export var bridge_activate_anim: String = "Fall"
@export var bridge_deactivate_anim: String = "Fall"  # You can set to "Fall45" if needed
@export var plate_down_anim: String = "Plate Down"
@export var plate_up_anim: String = "Plate Up"

var bridge_node: Node = null

func _ready() -> void:
	if bridge != null:
		bridge_node = get_node(bridge)

func _on_area_2d_body_entered(body) -> void:
	if not body.is_in_group("player") and not body.is_in_group("enemy"):
		return

	if not plate_down:
		print("Activated by:", body)
		plate_down = true
		animation_player.play(plate_down_anim)

		if bridge_node != null and bridge_node.has_node("AnimationPlayer"):
			var bridge_anim = bridge_node.get_node("AnimationPlayer")
			bridge_anim.play(bridge_activate_anim)

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
		animation_player.play(plate_up_anim)

		if bridge_node != null and bridge_node.has_node("AnimationPlayer"):
			var bridge_anim = bridge_node.get_node("AnimationPlayer")
			bridge_anim.play_backwards(bridge_deactivate_anim)
