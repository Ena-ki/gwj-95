extends Node2D
class_name SpawnpointComponent

const FACING_DIRECTION = 1
@export var check_point_id: String = ""

func _ready() -> void:
  activate()
  

func activate():
  SpawnpointManager.set_active_spawnpoint(self)

func get_spawn_pos():
  return global_position
