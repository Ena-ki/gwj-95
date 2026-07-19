class_name LevelExit
extends Area2D
# In level way to switch the scenes
# Works when player enters the area

@export_file("*.tscn") var new_scene : String
@export_file("*.tscn") var transition_scene : String

@export var exit_sound : AudioStream

var _activated : bool = false
#so that it can be activated only once


func _ready() -> void:
  body_entered.connect(_on_body_entered)


func _on_body_entered(body : Node2D) -> void:
  if _activated || body is not Player:
    return

  _activated = true
  AudioLoader.play_sound(exit_sound)

  var tween := create_tween()
  tween.tween_property(Engine, "time_scale", 0.0, 0.2)

  # set level prog, set level_time
  if owner is not Level:
    push_error("level exit's owner is not a Level, owner is ", owner)
    return
  (owner as Level).finish(new_scene, transition_scene)


func _exit_tree() -> void:
  Engine.time_scale = 1.0
