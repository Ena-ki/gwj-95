extends Node

signal spawnpoint_changed(spawnpoint: SpawnpointComponent)

var curr_spawnpoint

func set_active_spawnpoint(spawnpoint: SpawnpointComponent):
  if spawnpoint == curr_spawnpoint:
    return
  curr_spawnpoint = spawnpoint
  spawnpoint_changed.emit()


func get_spawnpoint_position():
  if curr_spawnpoint:
    return curr_spawnpoint.get_spawn_pos()
  return Vector2.ZERO


func respawn_player(player: Player):
  player.global_position = get_spawnpoint_position()
  if player.has_method("respawn"):
    player.respawn()
  
