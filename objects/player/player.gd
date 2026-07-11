class_name Player
extends CharacterBody2D
# A base player class

@export_category("Movement Variables")
@export var speed : float = 10.0
@export var jump_height : float = 100.0
@export var jump_time_to_peak : float = 1.0
@export var jump_time_to_fall : float = 1.0

@onready var jump_velocity : float = (( 2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity  : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity  : float = ((-2.0 * jump_height) / (jump_time_to_fall * jump_time_to_fall)) * -1.0


func _physics_process(delta: float) -> void:
  velocity.x = Input.get_axis("left", "right") * speed
  if Input.is_action_just_pressed("jump"):
    velocity.y += jump_velocity
  velocity.y += _get_gravity() * delta

  move_and_slide()


func _get_gravity() -> float:
  return jump_gravity if velocity.y < 0.0 else fall_gravity
