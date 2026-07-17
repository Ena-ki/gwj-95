extends Node

var current_music: AudioStreamPlayer


func play_sound(audio : AudioStream, volume := 0.0):
  var player := AudioStreamPlayer.new()
  get_tree().current_scene.add_child(player)
  player.volume_db = volume
  player.stream = audio
  player.playing = true
  player.finished.connect(player.queue_free)


func play_music(audio : AudioStream, volume := 0.0) -> void:
  if current_music:
    current_music.queue_free()
  current_music = AudioStreamPlayer.new()
  add_child(current_music)
  current_music.volume_db = volume
  current_music.stream = audio
  current_music.playing = true
  current_music.finished.connect(current_music.queue_free)


func stop_music() -> void:
  if current_music:
    current_music.queue_free()
