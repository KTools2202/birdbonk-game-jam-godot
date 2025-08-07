# pause_menu.gd
extends CanvasLayer

@onready var resume_button = $CenterContainer/VBoxContainer/ResumeButton
@onready var quit_button = $CenterContainer/VBoxContainer/QuitButton
@onready var main_menu_button = $CenterContainer/VBoxContainer/MainMenuButton


func _ready():
	hide()
	resume_button.pressed.connect(toggle_pause_menu)
	quit_button.pressed.connect(_on_quit_button_pressed)
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause_menu()


func toggle_pause_menu():
	get_tree().paused = !get_tree().paused
	visible = get_tree().paused

	if visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_quit_button_pressed():
	get_tree().quit()


func _on_main_menu_button_pressed():
	# Make sure to unpause before changing scenes
	get_tree().paused = false
	# Explicitly hide the menu
	visible = false  # Added this line
	# Reset mouse mode for game (important when leaving pause menu)
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # Added this line

	# Reset the level count in your progression manager
	# Replace 'LevelProgressionManager' with the actual name you gave your Autoload
	LevelManager.current_level_index = 0

	# Change to the main menu scene
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
