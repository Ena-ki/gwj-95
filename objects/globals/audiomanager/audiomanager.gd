extends Node
class_name Audio_Manager

const MUSIC_BUS = "Music"
const SFX_BUS = "SFX"

var music_player: AudioStreamPlayer2D
var curr_music: AudioStream

var sfx_pool: Array[AudioStreamPlayer2D] = []
var sfx_count: int = 12
var sfx_ind: int = 0

var music_tween: Tween


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
  
func play_music(stream: AudioStream, fade: float = 1.0):
  if stream == curr_music:
    return
  
  if music_tween:
    music_tween.kill()
  
  if music_player.playing:
    music_tween = create_tween()
    music_tween.tween_property(music_player, "volume_db", -40.0, fade)
    music_tween.tween_callback(func(): start_new_track(stream, fade))
  else:
    start_new_track(stream, fade)
      
      
func start_new_track(stream: AudioStream, fade: float = 1.0):
  music_player.stream = stream
  music_player.volume_db = -40.0
  music_player.play()
  
  music_tween = create_tween()
  music_tween.tween_property(music_player, "volume_db", 0, fade)
  
  
func stop_music(fade: float = 1.0):
  if not music_player.playing:
    return
  
  if music_tween:
    music_tween.kill()
  music_tween = create_tween()
  music_tween.tween_property(music_player, "volume_db", -40.0, fade)
  music_tween.tween_callback(music_player.stop)
  curr_music = null
  
func set_bus_vol(busName: String, vol: float):
  var idx := AudioServer.get_bus_index(busName)
  if idx != -1:
    AudioServer.set_bus_volume_db(idx, vol)

func mute_bus(busName: String, mute: bool):
  var idx := AudioServer.get_bus_index(busName)
  if idx != -1:
    AudioServer.set_bus_mute(idx, mute)


  
