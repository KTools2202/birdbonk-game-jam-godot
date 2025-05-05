extends Area2D

@onready var death_timer: Timer = $"Death Timer"

func _process(delta: float) -> void:
	pass
	

func _on_body_entered(body: CharacterBody2D) -> void:
	death_timer.start()
	

func _on_death_timer_timeout() -> void:
	get_tree().reload_current_scene()
