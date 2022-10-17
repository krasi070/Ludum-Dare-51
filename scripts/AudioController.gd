extends Node

const RUSTLE_PAPER: String = "rustle_paper"
const LIKE_SOUND: String = "like_sound"
const MEH_SOUND: String = "meh_sound"
const DISLIKE_SOUND: String = "dislike_sound"
const HATE_SOUND: String = "hate_sound"
const SELECTOR_NAVIGATION: String = "selector_nav"
const SELECT: String = "select"
const TIMEOUT: String = "timeout"
const BEEP_BEEP: String = "beep_beep"
const USED_CLICK: String = "used_click"


const MUSIC := preload("res://audio/music_loop.mp3")
const SFX: Dictionary = {
	RUSTLE_PAPER: preload("res://audio/paper_flip.wav"),
	LIKE_SOUND: preload("res://audio/awh.wav"),
	MEH_SOUND: preload("res://audio/okay.wav"),
	DISLIKE_SOUND: preload("res://audio/ew.wav"),
	HATE_SOUND: preload("res://audio/foff.wav"),
	SELECTOR_NAVIGATION: preload("res://audio/selector_nav2.wav"),
	SELECT: preload("res://audio/select.wav"),
	TIMEOUT: preload("res://audio/timeout.wav"),
	BEEP_BEEP: preload("res://audio/beepbeep.wav"),
	USED_CLICK: preload("res://audio/used_clicked.wav"),
}

const MUSIC_VOLUME_FIX: int = 10
const VOLUME_FIXER: Dictionary = {
	RUSTLE_PAPER: 0,
	LIKE_SOUND: -10,
	MEH_SOUND: -10,
	DISLIKE_SOUND: -10,
	HATE_SOUND: -10,
	SELECTOR_NAVIGATION: 10,
	SELECT: -10,
	TIMEOUT: 0,
	BEEP_BEEP: 0,
	USED_CLICK: 20,
}

const VOLUME: float = -30.0
const MUTE_VOLUME: float = -1000.0

var is_muted: bool = false

onready var music_player: AudioStreamPlayer = $MusicPlayer
onready var sfx_player: AudioStreamPlayer = $SfxPlayer
onready var ui_player: AudioStreamPlayer = $UiPlayer
onready var voice_player: AudioStreamPlayer = $VoicePlayer


func _ready() -> void:
	play_music()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mute"):
		if not is_muted:
			music_player.volume_db = MUTE_VOLUME
			is_muted = true
		else:
			music_player.volume_db = VOLUME
			is_muted = false


func play_ui_sound(ui_sfx: String) -> void:
	_play_sound(ui_player, ui_sfx)


func play_sfx(sfx: String) -> void:
	_play_sound(sfx_player, sfx)


func play_voice(sfx: String) -> void:
	_play_sound(voice_player, sfx)


func play_music() -> void:
	music_player.volume_db = VOLUME + MUSIC_VOLUME_FIX if not is_muted else MUTE_VOLUME
	music_player.stream = MUSIC
	music_player.play()


func _play_sound(player: AudioStreamPlayer, sfx: String) -> void:
	if not is_muted:
		player.volume_db = VOLUME + VOLUME_FIXER[sfx]
	else:
		player.volume_db = MUTE_VOLUME
	player.stream = SFX[sfx]
	player.play()
