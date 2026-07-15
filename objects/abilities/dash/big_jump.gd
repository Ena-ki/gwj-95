extends Node

@export var jump_target : Node2D
@export var jump_height : float = 100.0:
  set(val):
    jump_height = val
    jump_velocity = (( 2.0 * jump_height) / jump_time_to_peak) * -1.0
@export var jump_time_to_peak : float = 1.0:
  set(val):
    jump_time_to_peak = val
    jump_velocity = (( 2.0 * jump_height) / jump_time_to_peak) * -1.0


@onready var jump_velocity : float = (( 2.0 * jump_height) / jump_time_to_peak) * -1.0


func _process(_delta: float) -> void:
  if Input.is_action_just_pressed("debug_4"):
    big_jump()



func big_jump() -> void:
  jump_target.velocity.y = jump_velocity
