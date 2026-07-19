class_name Level
extends Node2D

signal player_reset
signal finished

@export var level_music : AudioStream
@export var player : Player
@export var spawnpoint : Node2D

@export var level_number : int = -1
@export var player_data : PlayerData

var play_time : float = 0.0


func finish(next_scene : String, transition : String) -> void:
  set_process(false)
  SceneLoader.change_scene(next_scene, transition)
  if player_data.level_progress < level_number + 1:
    player_data.level_progress = level_number + 1
  print("entering the time")
  player_data.enter_level_time(play_time, level_number)
  finished.emit()


func reset_player() -> void:
  player.position = spawnpoint.position
  player_reset.emit()


func _ready() -> void:
  player.died.connect(reset_player)
  reset_player()

  if !AudioLoader.current_music || AudioLoader.current_music.stream != level_music:
    AudioLoader.play_music(level_music)


func _process(delta: float) -> void:
  play_time += delta
