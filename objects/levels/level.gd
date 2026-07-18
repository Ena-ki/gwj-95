class_name Level
extends Node2D

@export var level_music : AudioStream
@export var player : Player
@export var spawnpoint : Node2D

@export var level_number : int = -1
@export var player_data : PlayerData

var play_time : float = 0.0


func _ready() -> void:
  tree_exiting.connect(_on_tree_exiting)
  player.died.connect(reset_level)
  reset_level()

  if !AudioLoader.current_music || AudioLoader.current_music.stream != level_music:
    AudioLoader.play_music(level_music)


func _process(delta: float) -> void:
  play_time += delta
  

func reset_level() -> void:
  player.position = spawnpoint.position

func _on_tree_exiting() -> void:
  if player_data.level_progress < level_number + 1:
    player_data.level_progress = level_number + 1
