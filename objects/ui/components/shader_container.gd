class_name ShaderContainer
extends CanvasLayer


func _ready() -> void:
  visible = true
  

func _unhandled_input(event: InputEvent) -> void:
  if event.is_action_pressed("debug_1"):
    visible = !visible
