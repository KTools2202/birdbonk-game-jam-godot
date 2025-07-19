extends Node

# List of levels/scenes
var level_list := [
	"res://Scenes/menu.tscn",
	"res://Scenes/levels/Level1.tscn",
	"res://Scenes/levels/Level2.tscn",
	"res://Scenes/levels/Level 3.tscn"
]

var current_level_index := 0

func go_to_next_level():
	current_level_index += 1
	if current_level_index < level_list.size():
		SceneManager.change_scene(
			level_list[current_level_index],
			{
				"pattern": "scribbles",
				"pattern_leave": "scribbles",
				"duration": 1.0
			}
		)
	else:
		print("You finished the game!")
		SceneManager.change_scene(
			"res://Scenes/YouWin.tscn",
			{
				"pattern": "scribbles",
				"pattern_leave": "dots",
				"duration": 1.2
			}
		)

func restart_current_level():
	SceneManager.change_scene(
		level_list[current_level_index],
		{
			"pattern": "scribbles",
			"pattern_leave": "scribbles",
			"duration": 1.0
		}
	)
	
