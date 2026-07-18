class_name BigJump
extends Node2D

@export var jump_target : Player
@export var jump_multiplier : float = 2.0



func _process(_delta: float) -> void:
  if Input.is_action_just_pressed("debug_4"):
    big_jump()



func big_jump() -> void:
  if jump_target.is_on_floor():
    jump_target.velocity.y = jump_target.jump_velocity * jump_multiplier * 0.8
