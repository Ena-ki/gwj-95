extends Node


func play_sound(audio : AudioStream, volume := 0.0):
  var player := AudioStreamPlayer.new()
  get_tree().current_scene.add_child(player)
  player.volume_db = volume
  player.stream = audio
  player.playing = true
  player.finished.connect(player.queue_free)
