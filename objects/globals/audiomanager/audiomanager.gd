extends Node
class_name Audio_Manager

const MUSIC_BUS = "Music"
const SFX_BUS = "SFX"

var music_player: AudioStreamPlayer2D
var curr_music: AudioStream

var sfx_pool: Array[AudioStreamPlayer2D] = []
var sfx_count: int = 12
var sfx_ind: int = 0

func _ready() -> void:
  music_player = AudioStreamPlayer2D.new()
  music_player.bus = MUSIC_BUS
  add_child(music_player)
  
  for i in sfx_count:
    var p = AudioStreamPlayer2D.new()
    p.bus = SFX_BUS
    add_child(p)
    sfx_pool.append(p)

func play_sfx(stream: AudioStreamPlayer2D, pitch: float = 1.0, volume: float = 1.0):
  if not stream:
    return
  var player = sfx_pool[sfx_ind]
  sfx_ind = (sfx_ind + 1) % sfx_pool.size()
  
  player.stream = stream
  player.pitch_scale = pitch
  player.volume_db = volume
  player.play()
  
func play_music():
  pass
