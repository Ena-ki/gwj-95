extends Node


func play_sound(audio : AudioStream):
  var player := AudioStreamPlayer.new()
  player.stream = audio
  player.playing = true
  player.finished.connect(player.queue_free)
  get_tree().current_scene.add_child(player)



