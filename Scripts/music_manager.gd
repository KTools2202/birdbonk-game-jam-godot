extends Node

@onready var menu_music: AudioStreamPlayer = $MenuMusic
@onready var game_music: AudioStreamPlayer = $GameMusic

var fade_speed := 80.0  # dB per second

var fading_in: AudioStreamPlayer = null
var fading_out: AudioStreamPlayer = null

var is_menu := true

var switch_timer := 0.0
var switch_interval := 40.0  # seconds per track


func _ready() -> void:
	menu_music.volume_db = 0
	menu_music.play()
	game_music.volume_db = -80
	game_music.stop()

	fading_in = menu_music
	fading_out = null

	switch_timer = 0.0

	set_process(true)


func _process(delta: float) -> void:
	# Update timer
	switch_timer += delta

	# Handle fading
	if fading_in:
		fading_in.volume_db = min(fading_in.volume_db + fade_speed * delta, 0)

	if fading_out:
		fading_out.volume_db = max(fading_out.volume_db - fade_speed * delta, -50)
		if fading_out.volume_db <= -49.9:
			fading_out.stop()
			fading_out = null

	# Switch music when timer hits interval
	if switch_timer >= switch_interval:
		switch_timer = 0.0
		is_menu = !is_menu

		if is_menu:
			_start_fade(menu_music, game_music)
			print("Switching to MENU")
		else:
			_start_fade(game_music, menu_music)
			print("Switching to GAME")


func _start_fade(fade_in: AudioStreamPlayer, fade_out: AudioStreamPlayer) -> void:
	fading_in = fade_in
	fading_out = fade_out

	if fading_in and not fading_in.playing:
		fading_in.volume_db = -50
		fading_in.play()

	if fading_out and fading_out.playing:
		fading_out.volume_db = 0
