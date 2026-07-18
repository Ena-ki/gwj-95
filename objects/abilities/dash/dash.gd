class_name Dash
extends Node2D

@export var dash_target : Node2D
@export var ray : RayCast2D
@export var top_ray : RayCast2D
@export var bot_ray : RayCast2D

@export var dash_distance : float = 256
@export var dash_margin : float = 16
@export var dash_glitch_effect : PackedScene


func _ready() -> void:
  top_ray.position.y += dash_margin
  bot_ray.position.y -= dash_margin


func _process(_delta: float) -> void:
  if Input.is_action_just_pressed("debug_2"):
    dash_right()
  if Input.is_action_just_pressed("debug_3"):
    dash_left()


func dash_right() -> void:
  ray.target_position.x = dash_distance + dash_margin
  top_ray.target_position.x = dash_distance + dash_margin
  bot_ray.target_position.x = dash_distance + dash_margin
  ray.force_raycast_update()
  top_ray.force_raycast_update()
  bot_ray.force_raycast_update()

  var col_point = dash_distance + dash_margin
  if ray.is_colliding():
    col_point = min(col_point, ray.get_collision_point().x - global_position.x)
  if top_ray.is_colliding():
    col_point = min(col_point, top_ray.get_collision_point().x - global_position.x)
  if bot_ray.is_colliding():
    col_point = min(col_point, bot_ray.get_collision_point().x - global_position.x)

  _spawn_dash_effect(global_position)
  _spawn_dash_effect(Vector2(global_position.x + max(0.0, col_point - dash_margin), global_position.y))
  dash_target.position.x += max(0.0, col_point - dash_margin)



func dash_left() -> void:
  var ray_target_pos = -(dash_distance + dash_margin)
  ray.target_position.x = ray_target_pos 
  top_ray.target_position.x = ray_target_pos
  bot_ray.target_position.x = ray_target_pos
  ray.force_raycast_update()
  top_ray.force_raycast_update()
  bot_ray.force_raycast_update()


  var col_point = - (dash_distance + dash_margin)
  if ray.is_colliding():
    col_point = max(col_point, ray.get_collision_point().x - global_position.x)
  if top_ray.is_colliding():
    col_point = max(col_point, top_ray.get_collision_point().x - global_position.x)
  if bot_ray.is_colliding():
    col_point = max(col_point, bot_ray.get_collision_point().x - global_position.x)

  _spawn_dash_effect(global_position)
  _spawn_dash_effect(Vector2(global_position.x + min(0.0, col_point + dash_margin), global_position.y))
  dash_target.position.x += min(0.0, col_point + dash_margin)


func _spawn_dash_effect(pos : Vector2 ):
  var dash_effect := dash_glitch_effect.instantiate() as CPUParticles2D
  get_tree().current_scene.add_child(dash_effect)
  dash_effect.position = pos
  dash_effect.finished.connect(dash_effect.queue_free)
  dash_effect.emitting = true
