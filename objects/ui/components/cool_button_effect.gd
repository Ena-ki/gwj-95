class_name CoolButtonEffect
extends Node
# Basic button effect implemented as a component
# Works by putting it as a child of a button
# Yes I used magic numbers, yes I used onready, yes it's ugly


var one_tween : Tween
var loop_tween : Tween

@onready var button : Button = get_parent()

func _ready() -> void:
  button.mouse_entered.connect(_on_button_mouse_entered)
  button.mouse_exited.connect(_on_button_mouse_exited)


func _on_button_mouse_entered():
  if one_tween:
    one_tween.kill()
  one_tween = create_tween()
  if loop_tween:
    loop_tween.kill()
  loop_tween = create_tween().set_loops()
  loop_tween.tween_property(button, "offset_transform_rotation",  0.087, 0.2).set_trans(Tween.TRANS_SINE)
  loop_tween.tween_property(button, "offset_transform_rotation", -0.087, 0.2).set_trans(Tween.TRANS_SINE)
  one_tween.tween_property(button, "offset_transform_scale:x", 1.1, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
  one_tween.parallel().tween_property(button, "offset_transform_scale:y", 1.1, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)


func _on_button_mouse_exited():
  if one_tween:
    one_tween.kill()
  one_tween = create_tween()
  loop_tween.kill()
  one_tween.tween_property(button, "offset_transform_scale:x", 1.0, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
  one_tween.parallel().tween_property(button, "offset_transform_scale:y", 1.0, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
  one_tween.parallel().tween_property(button, "offset_transform_rotation", 0.0, 0.1).set_trans(Tween.TRANS_SINE)
