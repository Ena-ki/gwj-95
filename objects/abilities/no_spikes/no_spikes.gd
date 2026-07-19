class_name NoSpikes
extends Node

@export var timer : Timer
@export var target : Player


func _ready() -> void:
  timer.timeout.connect(func(): 
    target.set_collision_layer_value(2, true)
    if target.spike_layer:
      target.spike_layer.visible = true
    )


func activate():
  target.set_collision_layer_value(2, false)
  if target.spike_layer:
    target.spike_layer.visible = false
  timer.start()
