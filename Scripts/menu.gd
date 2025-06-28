extends Control
var config := ConfigFile.new()
var config_path := "res://PlayerConfigs"

@onready var settings_panel = $Control/SettingsPanel2
@onready var music_slider = $Control/SettingsPanel2/CenterContainer/VBoxContainer/MusicVolumeSlider
@onready var sfx_slider = $Control/SettingsPanel2/CenterContainer/VBoxContainer/SFXVolumeSlider
@onready var start_button = $CenterContainer/VBoxContainer/StartButton2
@onready var settings_button = $CenterContainer/VBoxContainer/SettingsButton2
@onready var quit_button = $CenterContainer/VBoxContainer/QuitButton2
@onready var back_button = $Control/SettingsPanel2/CenterContainer/VBoxContainer/BackButton
@onready var fullscreen_button = $Control/SettingsPanel2/CenterContainer/VBoxContainer/FullScreenToggle

func _ready():
	settings_panel.visible = false
	load_settings()
	fullscreen_button.pressed.connect(_on_fullscreen_toggled)
	start_button.pressed.connect(_on_start_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	back_button.pressed.connect(_on_back_pressed)

	music_slider.value_changed.connect(_on_music_volume_changed)
	sfx_slider.value_changed.connect(_on_sfx_volume_changed)

func _on_start_pressed():
	print("Start Game")
	get_tree().change_scene_to_file("res://Scenes/levels/Game.tscn") 

func _on_settings_pressed():
	settings_panel.visible = true

func _on_quit_pressed():
	get_tree().quit()
func load_settings():
	var err = config.load(config_path)
	if err != OK:
		print("No settings file found, using defaults.")
	
	else:
		var is_fullscreen = config.get_value("display", "fullscreen", false)

		DisplayServer.window_set_mode(
		DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN if is_fullscreen
		else DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN
		)

		fullscreen_button.text = "Mode: %s" % ("Fullscreen" if is_fullscreen else "Windowed")

func _on_fullscreen_toggled():
	var is_fullscreen := DisplayServer.window_get_mode() != DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN
	DisplayServer.window_set_mode(
		DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN if DisplayServer.window_get_mode() != DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN
		else DisplayServer.WindowMode.WINDOW_MODE_WINDOWED
	)
	var current_mode = DisplayServer.window_get_mode()
	var mode_name = "Fullscreen" if current_mode == DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN else "Windowed"
		# Save to config
	config.set_value("display", "fullscreen", is_fullscreen)
	config.save(config_path)
	fullscreen_button.text = "Mode: %s" % mode_name
func _on_back_pressed():
	settings_panel.visible = false

func _on_music_volume_changed(value: float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))
	print("Music volume set to:", value)

func _on_sfx_volume_changed(value: float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))
	print("SFX volume set to:", value)
