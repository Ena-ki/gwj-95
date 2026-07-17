class_name Level
extends Node2D

@export var level_music : AudioStream
@export var player : Player
@export var spawnpoint : Node2D


func _ready() -> void:
  player.died.connect(reset_level)
  reset_level()
  if AudioLoader.current_music.stream != level_music:
    AudioLoader.play_music(level_music)
  

func reset_level() -> void:
  player.position = spawnpoint.position
