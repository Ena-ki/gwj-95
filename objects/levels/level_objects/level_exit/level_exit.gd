class_name LevelExit
extends Area2D
# In level way to switch the scenes
# Works when player enters the area

@export_file("*.tscn") var new_scene : String
@export_file("*.tscn") var transition_file : String

@export var exit_sound : AudioStream

var _activated : bool = false


func _ready() -> void:
  body_entered.connect(_on_body_entered)


func _on_body_entered(body : Node2D) -> void:
  if body is Player and !_activated:
    AudioLoader.play_sound(exit_sound)
    _activated = true
    var tween := create_tween()
    tween.tween_property(Engine, "time_scale", 0.0, 0.2)
    SceneLoader.change_scene(new_scene, transition_file)

    # holy fuck this is ugly
    # please god let me go to heaven even though i sinned, it's 24 hours until jam ends
    if owner.player_data.level_progress < owner.level_number + 1:
      owner.player_data.level_progress = owner.level_number + 1
    if owner.player_data.level_times.size() < owner.level_number: 
      owner.player_data.level_times.resize(owner.level_number)
    if !owner.player_data.level_times[owner.level_number - 1] ||owner.player_data.level_times[owner.level_number - 1] > owner.play_time:
      print("play time is", owner.play_time)
      owner.player_data.level_times[owner.level_number - 1] = owner.play_time


func _exit_tree() -> void:
  Engine.time_scale = 1.0
