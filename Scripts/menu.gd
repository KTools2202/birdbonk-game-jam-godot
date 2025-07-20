extends Control

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

	# Initialize UI from settings
	music_slider.value = SettingsManager.music_volume
	sfx_slider.value = SettingsManager.sfx_volume
	fullscreen_button.text = "Mode: %s" % ("Fullscreen" if SettingsManager.fullscreen else "Windowed")

	# Connect signals
	fullscreen_button.pressed.connect(_on_fullscreen_toggled)
	start_button.pressed.connect(_on_start_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	back_button.pressed.connect(_on_back_pressed)
	music_slider.value_changed.connect(_on_music_volume_changed)
	sfx_slider.value_changed.connect(_on_sfx_volume_changed)

func _on_start_pressed():
	print("Start Game")
	LevelManager.go_to_next_level()

func _on_settings_pressed():
	settings_panel.visible = true

func _on_quit_pressed():
	get_tree().quit()

func _on_back_pressed():
	settings_panel.visible = false

func _on_music_volume_changed(value: float):
	SettingsManager.set_music_volume(value)

func _on_sfx_volume_changed(value: float):
	SettingsManager.set_sfx_volume(value)

func _on_fullscreen_toggled():
	SettingsManager.toggle_fullscreen()
	fullscreen_button.text = "Mode: %s" % ("Fullscreen" if SettingsManager.fullscreen else "Windowed")
