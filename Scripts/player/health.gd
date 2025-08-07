extends Node
@onready var collision_shape_2d: CollisionShape2D = %GettinghitAREA
@export var max_health: int = 100
var current_health: int

signal health_changed(current: int, max: int)
signal died
signal hit(damage_amount: int)


func _ready() -> void:
	current_health = max_health


func take_damage(amount: int) -> void:
	if current_health <= 0:
		return

	current_health = max(current_health - amount, 0)
	emit_signal("hit", amount)  # ✅ Signal that the player was hit
	emit_signal("health_changed", current_health, max_health)

	if current_health == 0:
		die()

	current_health = max(current_health - amount, 0)
	emit_signal("health_changed", current_health, max_health)

	if current_health == 0:
		die()


func heal(amount: int) -> void:
	if current_health >= 0:
		return

	current_health = min(current_health + amount, max_health)
	emit_signal("health_changed", current_health, max_health)


func die() -> void:
	emit_signal("died")
	print("Player died.")
	LevelManager.restart_current_level()
	# You can add death animation, disable input, etc. here
