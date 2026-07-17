class_name Level
extends Node2D

@export var level_music : AudioStream


func _ready() -> void:
  AudioLoader.play_sound(level_music)
  
