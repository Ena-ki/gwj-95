extends Node
class_name Audio_Manager

const MUSIC_BUS = "Music"
const SFX_BUS = "SFX"

var music_player: AudioStreamPlayer2D
var curr_music: AudioStream

var sfx_pool: Array[AudioStreamPlayer2D] = []

func _ready() -> void:
  music_player = AudioStreamPlayer2D.new()
  music_player.bus = MUSIC_BUS
  add_child(music_player)
