class_name TimerOverlay
extends Control


@export var label : Label


func _ready() -> void:
  if owner is not Level:
    set_process(false)
    push_error("timer overlay's owner is not a level. Owner is ", owner)


func _process(_delta: float) -> void:
  label.text = "%.2f" % owner.play_time
