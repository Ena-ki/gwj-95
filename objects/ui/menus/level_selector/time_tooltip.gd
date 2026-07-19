class_name TimeTooltip
extends Control

@export var label : RichTextLabel


func _process(_delta: float) -> void:
  global_position = get_global_mouse_position()


func show_level_time(time : float) -> void:
  label.text = "best time\n %.2f" % time
