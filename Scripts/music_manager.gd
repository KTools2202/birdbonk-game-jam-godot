extends Node

@onready var menu_music: AudioStreamPlayer = $MenuMusic
@onready var game_music: AudioStreamPlayer = $GameMusic

# Fading settings
var fade_speed := 5.0  # dB per second
var fading_in: AudioStreamPlayer = null
var fading_out: AudioStreamPlayer = null
var current_track: String = ""  # "menu" or "game"

func _ready():
	menu_music.volume_db = -80
	game_music.volume_db = -80

	menu_music.stream_paused = false
	game_music.stream_paused = false
	menu_music.bus = "Music"
	game_music.bus = "Music"

	menu_music.loop = true
	game_music.loop = true

	set_process(false)

func play_music_for_level(level: int):
	var target := "menu" if level == 1 else "game"
	if target == current_track:
		return

	if target == "menu":
		_start_fade(menu_music, game_music)
		current_track = "menu"
	else:
		_start_fade(game_music, menu_music)
		current_track = "game"

func _start_fade(fade_in: AudioStreamPlayer, fade_out: AudioStreamPlayer):
	fading_in = fade_in
	fading_out = fade_out

	if not fading_in.playing:
		fading_in.volume_db = -80
		fading_in.play()

	set_process(true)

func _process(delta):
	if fading_in:
		fading_in.volume_db = min(fading_in.volume_db + fade_speed * delta, 0)

	if fading_out:
		fading_out.volume_db = max(fading_out.volume_db - fade_speed * delta, -80)

	if fading_out and fading_out.volume_db <= -79.9:
		fading_out.stop()
		fading_out = null

	if fading_in and fading_in.volume_db >= -0.1 and not fading_out:
		var bus_idx = AudioServer.get_bus_index("Music")
		var final_volume_db = AudioServer.get_bus_volume_db(bus_idx)
		fading_in.volume_db = final_volume_db
		fading_in = null
		set_process(false)
