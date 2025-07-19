extends CharacterBody2D

@onready var movement = $Movement
@onready var age_manager = $AgeManager
@onready var abilities = $Abilities
@onready var health = $Health
@onready var timer = $Timer
@onready var area_2d = $Area2D
@onready var hp_bar = $HPBar  # Optional if you added a health bar

# Export the launch power bar so you can assign it in the editor
@export var launch_power_bar: ProgressBar

func _ready() -> void:
	add_to_group("player")
	age_manager.set_stone_age()
	timer.timeout.connect(abilities.on_timer_timeout)
	health.health_changed.connect(_on_health_changed)
	health.died.connect(_on_player_died)
	
	if hp_bar:
		hp_bar.max_value = health.max_health
		hp_bar.value = health.current_health
	
	# Only set if launch_power_bar exists
	if launch_power_bar:
		launch_power_bar.value = 0
	else:
		print("LaunchPowerBar not assigned")

func _physics_process(delta: float) -> void:
	movement.physics_move(self, delta)
	age_manager.handle_input()
	abilities.handle_input()

func _on_area_2d_body_entered(_body: RigidBody2D) -> void:
	Global.EnemyinRange = true

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Restart"):
		LevelManager.restart_current_level()

func _on_area_2d_body_exited(_body: RigidBody2D) -> void:
	Global.EnemyinRange = false

func _on_health_changed(current: int, max: int) -> void:
	if hp_bar:
		hp_bar.value = current
		hp_bar.max_value = max  # In case max health changes

func _on_player_died() -> void:
	print("Do death animation, game over, etc.")
