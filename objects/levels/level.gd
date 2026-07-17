class_name Level
extends Node2D

@export var level_music : AudioStream


func _ready() -> void:
  if AudioLoader.current_music.stream != level_music:
    AudioLoader.play_music(level_music)
  
