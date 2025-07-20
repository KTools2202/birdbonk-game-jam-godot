extends Node

# Path to save user settings
const CONFIG_PATH := "user://player_settings.cfg"

# Settings state
var music_volume: float = 0.5
var sfx_volume: float = 0.5
var fullscreen: bool = false

# Internal config file
var config := ConfigFile.new()

func _ready():
	load_settings()
	apply_settings()

# --- Volume Control ---

func set_music_volume(value: float):
	music_volume = clampf(value, 0.0, 2.0)
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Music"),
		linear_to_db(music_volume)
	)
	save_settings()

func set_sfx_volume(value: float):
	sfx_volume = clampf(value, 0.0, 2.0)
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("SFX"),
		linear_to_db(sfx_volume)
	)
	save_settings()

# --- Fullscreen Control ---

func toggle_fullscreen():
	fullscreen = !fullscreen
	apply_fullscreen()
	save_settings()

func apply_fullscreen():
	DisplayServer.window_set_mode(
		DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN if fullscreen
		else DisplayServer.WindowMode.WINDOW_MODE_WINDOWED
	)

# --- Apply settings at game start ---

func apply_settings():
	set_music_volume(music_volume)
	set_sfx_volume(sfx_volume)
	apply_fullscreen()

# --- Load & Save Settings ---

func load_settings():
	var err = config.load(CONFIG_PATH)
	if err == OK:
		music_volume = config.get_value("audio", "music", 0.5)
		sfx_volume = config.get_value("audio", "sfx", 0.5)
		fullscreen = config.get_value("display", "fullscreen", false)
	else:
		print("SettingsManager: No config file found, using defaults.")

func save_settings():
	config.set_value("audio", "music", music_volume)
	config.set_value("audio", "sfx", sfx_volume)
	config.set_value("display", "fullscreen", fullscreen)
	config.save(CONFIG_PATH)
