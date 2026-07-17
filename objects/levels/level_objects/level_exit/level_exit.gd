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


func _exit_tree() -> void:
  Engine.time_scale = 1.0
