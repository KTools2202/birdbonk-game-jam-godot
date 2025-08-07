extends Node

# List of scenes in order
var level_list := [
	"res://Scenes/menu.tscn",
	"res://Scenes/levels/Cutscene.tscn",
	"res://Scenes/levels/Level1.tscn",
	"res://Scenes/levels/Level2.tscn",
	"res://Scenes/levels/Level 3.tscn"
]

var current_level_index := 0


func go_to_next_level():
	current_level_index += 1
	if current_level_index < level_list.size():
		#_play_music_for_level(current_level_index)
		_change_to_scene(level_list[current_level_index])
	else:
		print("You finished the game!")
		_change_to_scene("res://Scenes/levels/YouWin.tscn", "dots")


func restart_current_level():
	#_play_music_for_level(current_level_index)
	_change_to_scene(level_list[current_level_index])


func _change_to_scene(path: String, transition_pattern := "scribbles"):
	SceneManager.change_scene(
		path, {"pattern": transition_pattern, "pattern_leave": "scribbles", "duration": 1.0}
	)
