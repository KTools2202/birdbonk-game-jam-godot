extends Node

var level_list := [
	"res://Scenes/levels/Game.tscn",
	"res://Scenes/levels/Level2.tscn",
	#"res://Scenes/levels/Level3.tscn"
]

var current_level_index := 0

func go_to_next_level():
	current_level_index += 1
	if current_level_index < level_list.size():
		get_tree().change_scene_to_file(level_list[current_level_index])
	else:
		print("You finished the game!")
		# Optionally go to end screen
		# get_tree().change_scene_to_file("res://scenes/YouWin.tscn")
