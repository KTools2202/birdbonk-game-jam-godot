extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer

func _ready():
	timer.start()
	modulate.a = 0.6  # Set semi-transparent
	sprite.material = preload("res://Sprites/fade_material.tres")

func _on_Timer_timeout():
	queue_free()
