extends Control

# --- Main Menu Buttons ---
@onready var start_button = $CenterContainer/VBoxContainer/StartButton2
@onready var settings_button = $CenterContainer/VBoxContainer/SettingsButton2
@onready var quit_button = $CenterContainer/VBoxContainer/QuitButton2
# NEW: Reference for the credits button
@onready var credits_button = $CenterContainer/VBoxContainer/CreditsButton2
# NEW: Reference to the container for showing/hiding main buttons
@onready var main_buttons_container = $CenterContainer

# --- Panels ---
@onready var settings_panel = $SettingsPanel
# NEW: Reference to the Credits panel, following your path structure
@onready var credits_panel = $SettingsPanel2

# --- Panel Buttons and Controls ---
@onready var back_button = $SettingsPanel/CenterContainer/VBoxContainer/BackButton
# NEW: Assuming the back button inside Credits has this path
@onready var credits_back_button = $SettingsPanel2/BackButton

@onready var music_slider = $SettingsPanel/CenterContainer/VBoxContainer/MusicVolumeSlider
@onready var sfx_slider = $SettingsPanel/CenterContainer/VBoxContainer/SFXVolumeSlider
@onready var fullscreen_button = $SettingsPanel/CenterContainer/VBoxContainer/FullScreenToggle


func _ready():
	# Hide panels at start
	settings_panel.visible = false
	credits_panel.visible = false

	# Initialize UI from settings
	music_slider.value = SettingsManager.music_volume
	sfx_slider.value = SettingsManager.sfx_volume
	fullscreen_button.text = "Mode: %s" % ("Fullscreen" if SettingsManager.fullscreen else "Windowed")

	# Connect main menu signals
	start_button.pressed.connect(_on_start_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	# NEW: Connect the credits button signal
	credits_button.pressed.connect(_on_credits_pressed)
	
	# Connect panel signals
	# Both back buttons will now use the same function to return to the menu
	back_button.pressed.connect(_on_back_to_main_pressed)
	credits_back_button.pressed.connect(_on_back_to_main_pressed)
	
	music_slider.value_changed.connect(_on_music_volume_changed)
	sfx_slider.value_changed.connect(_on_sfx_volume_changed)
	fullscreen_button.pressed.connect(_on_fullscreen_toggled)


func _on_start_pressed():
	print("Start Game")
	LevelManager.go_to_next_level()

func _on_settings_pressed():
	main_buttons_container.visible = false
	settings_panel.visible = true

# NEW: Function to show the credits panel
func _on_credits_pressed():
	main_buttons_container.visible = false
	credits_panel.visible = true

func _on_quit_pressed():
	get_tree().quit()

# MODIFIED: A single function for all back buttons
func _on_back_to_main_pressed():
	# Hide all panels and show the main menu buttons again
	main_buttons_container.visible = true
	settings_panel.visible = false
	credits_panel.visible = false

func _on_music_volume_changed(value: float):
	SettingsManager.set_music_volume(value)

func _on_sfx_volume_changed(value: float):
	SettingsManager.set_sfx_volume(value)

func _on_fullscreen_toggled():
	SettingsManager.toggle_fullscreen()
	fullscreen_button.text = "Mode: %s" % ("Fullscreen" if SettingsManager.fullscreen else "Windowed")
