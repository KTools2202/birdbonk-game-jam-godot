extends Node

@onready var animation_player = $"../AnimationPlayer"
@onready var timer = $"../Timer"
@onready var launch_power_bar: ProgressBar = $"../LaunchPowerBar"
@onready var camera_anim_player: AnimationPlayer = $"../Camera2D/AnimationPlayer"

var normal_size := true
var time_out := true

func handle_input():
	if Input.is_action_just_pressed("weapon_change"):
		Global.weapon1 = !Global.weapon1
		Global.weapon2 = !Global.weapon2
	
	if Global.stone_age and Input.is_action_pressed("Ability"):
		launch_power_bar.visible = true
		launch_power_bar.value = Global.launch_power
	else:
		launch_power_bar.visible = false
		

	if Global.industrial_age and Input.is_action_just_pressed("Ability") and time_out:
		if normal_size:
			animation_player.play("Shrink")
			camera_anim_player.play("zoom")  # Play forward to zoom in
		else:
			animation_player.play("Normal Size")
			camera_anim_player.play_backwards("zoom")  # Play backward to zoom out
		timer.start()
		normal_size = !normal_size
		time_out = false

func on_timer_timeout():
	time_out = true
