extends Node
class_name TimerComponent


var is_running: bool = false
var start_usec: int = 0
var accum_pause_usec: int = 0
var pause_started_usec: int = 0


var records: Array[Dictionary] = []
var current_level: String = ""

func _process(delta: float) -> void:
  if is_running:
    emit_signal("tick", get_elapsed_usec())


func get_elapsed_usec():
  pass
