class_name Player
extends CharacterBody2D
# A base player class
# Probably should move a lot of the logic into separate components

signal died

@export_category("Movement Variables")
@export var speed : float = 10.0
@export var jump_height : float = 100.0:
  set(val):
    jump_height = val
    jump_velocity = (( 2.0 * jump_height) / jump_time_to_peak) * -1.0
    jump_gravity = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
    fall_gravity = ((-2.0 * jump_height) / (jump_time_to_fall * jump_time_to_fall)) * -1.0
@export var jump_time_to_peak : float = 1.0:
  set(val):
    jump_time_to_peak = val
    jump_velocity = (( 2.0 * jump_height) / jump_time_to_peak) * -1.0
    jump_gravity = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@export var jump_time_to_fall : float = 1.0:
  set(val):
    jump_time_to_fall = val
    fall_gravity = ((-2.0 * jump_height) / (jump_time_to_fall * jump_time_to_fall)) * -1.0

@export_category("Node References")
@export var visuals : Node2D
@export var coyote_timer : Timer
@export var jump_buffer_timer : Timer
@export var spike_layer : TileMapLayer

@export_category("Other References")
@export var jump_sound : AudioStream
@export var landing_sound : AudioStream
@export var death_sound : AudioStream


@onready var jump_velocity : float = (( 2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity  : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity  : float = ((-2.0 * jump_height) / (jump_time_to_fall * jump_time_to_fall)) * -1.0

var _was_on_floor : bool = true


func die() -> void:
  AudioLoader.play_sound(death_sound)
  died.emit()


func _physics_process(delta: float) -> void:
  velocity.x = Input.get_axis("left", "right") * speed
  velocity.y += _get_gravity() * delta
  _handle_jump()

  move_and_slide()


func _process(_delta: float) -> void:
  _visual_flip()


func _handle_jump() -> void:
  if is_on_floor():
    if _was_on_floor == false:
      AudioLoader.play_sound(landing_sound)
      _was_on_floor = true
    if Input.is_action_just_pressed("jump") || (jump_buffer_timer.time_left > 0.0 && Input.is_action_pressed("jump")):
      _jump()

  else:
    if _was_on_floor == true:
      _was_on_floor = false
      coyote_timer.start()
    if Input.is_action_just_pressed("jump") :
      if coyote_timer.time_left > 0.0:
        _jump()
      else:
        jump_buffer_timer.start()


func _jump() -> void:
  AudioLoader.play_sound(jump_sound)
  _was_on_floor = false
  velocity.y = jump_velocity
  if coyote_timer.time_left > 0.0:
    coyote_timer.stop()
  if jump_buffer_timer.time_left > 0.0:
    jump_buffer_timer.stop()


func _visual_flip() -> void:
  if velocity.x < 0.0:
    visuals.scale.x = -1.0
  elif velocity.x > 0.0:
    visuals.scale.x = 1.0


func _get_gravity() -> float:
  return jump_gravity if velocity.y < 0.0 else fall_gravity
