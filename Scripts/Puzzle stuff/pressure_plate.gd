extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var animation_player: AnimationPlayer = $AnimatableBody2D/AnimationPlayer
@onready var animatable_body_2d: AnimatableBody2D = $AnimatableBody2D

@export var plate_down: bool = false
@export var lock_on_activate: bool = false

@export var bridge: NodePath
@export var bridge_activate_anim: String = "Fall"
@export var bridge_deactivate_anim: String = "Fall"
@export var plate_down_anim: String = "Plate Down"
@export var plate_up_anim: String = "Plate Up"

var bridge_node: Node = null
var body_count: int = 0  # Track how many valid bodies are on the plate

func _ready() -> void:
	if bridge != null:
		bridge_node = get_node(bridge)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Restart"):
		_reset_plate()

func _on_area_2d_body_entered(body) -> void:
	if not body.is_in_group("player") and not body.is_in_group("enemy"):
		return

	body_count += 1
	print("Body entered:", body, "Total bodies:", body_count)

	if not plate_down:
		plate_down = true
		animation_player.play(plate_down_anim)

		if bridge_node != null and bridge_node.has_node("AnimationPlayer"):
			var bridge_anim = bridge_node.get_node("AnimationPlayer")
			bridge_anim.play(bridge_activate_anim)

		if lock_on_activate:
			area_2d.monitoring = false

		if Global.lvl == 1:
			Global.HatchOpen1 = true

func _on_area_2d_body_exited(body) -> void:
	if lock_on_activate:
		return

	if not body.is_in_group("player") and not body.is_in_group("enemy"):
		return

	body_count = max(body_count - 1, 0)
	print("Body exited:", body, "Remaining bodies:", body_count)

	if body_count == 0 and plate_down:
		plate_down = false
		animation_player.play(plate_up_anim)

		if bridge_node != null and bridge_node.has_node("AnimationPlayer"):
			var bridge_anim = bridge_node.get_node("AnimationPlayer")
			bridge_anim.play_backwards(bridge_deactivate_anim)

func _reset_plate() -> void:
	if plate_down:
		print("Resetting plate and hatch")
		plate_down = false
		body_count = 0
		animation_player.play(plate_up_anim)

		if bridge_node != null and bridge_node.has_node("AnimationPlayer"):
			var bridge_anim = bridge_node.get_node("AnimationPlayer")
			bridge_anim.play_backwards(bridge_deactivate_anim)

		Global.HatchOpen1 = false

		if lock_on_activate:
			area_2d.monitoring = true
