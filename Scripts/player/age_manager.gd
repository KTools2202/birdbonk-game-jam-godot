extends Node

@onready var cave_man = $"../Caveman"
@onready var medieval_man = $"../Medieval man"
@onready var industrial_man = $"../Industrial man"
@onready var animation_player = $"../AnimationPlayer"

var normal_size := true


func handle_input():
	if Global.lvl != 1:
		return

	if Input.is_action_just_pressed("stone_age"):
		set_stone_age()
	elif Input.is_action_just_pressed("medieval_age") && Global.lvl <= 2:
		set_medieval_age()
	elif Input.is_action_just_pressed("industrial_age") && Global.lvl <= 3:
		set_industrial_age()


func set_stone_age():
	Global.stone_age = true
	Global.medieval_age = false
	Global.industrial_age = false
	cave_man.show()
	medieval_man.hide()
	industrial_man.hide()
	reset_size()


func set_medieval_age():
	Global.stone_age = false
	Global.medieval_age = true
	Global.industrial_age = false
	cave_man.hide()
	medieval_man.show()
	industrial_man.hide()
	reset_size()


func set_industrial_age():
	Global.stone_age = false
	Global.medieval_age = false
	Global.industrial_age = true
	cave_man.hide()
	medieval_man.hide()
	industrial_man.show()
	reset_size()


func reset_size():
	if not normal_size:
		animation_player.play("Normal Size")
		normal_size = true
