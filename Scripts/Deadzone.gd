extends Area2D

@onready var death_timer: Timer = $"Death Timer"

func _process(_delta: float) -> void:
	pass
	

func _on_body_entered(_body: CharacterBody2D) -> void:
	if _body.name == "Player":
		death_timer.start()


func _on_death_timer_timeout() -> void:
	LevelManager.restart_current_level()
