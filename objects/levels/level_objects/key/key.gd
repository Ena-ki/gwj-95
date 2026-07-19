class_name Key
extends Area2D

@export var blocks_to_erase_1 : Vector2i
@export var blocks_to_erase_2 : Vector2i
@export var spawnpoint : Node2D

@export var map : TileMapLayer
@export var collect_sound : AudioStream


func _ready() -> void:
  body_entered.connect(_on_body_entered)


func _on_body_entered(body : Node2D) -> void:
  if body is not Player:
    return

  AudioLoader.play_sound(collect_sound, -5)
  spawnpoint.position = position
  for i in range(abs(blocks_to_erase_1[0] - blocks_to_erase_2[0]) + 1):
    for j in range(abs(blocks_to_erase_1[1] - blocks_to_erase_2[1]) + 1):
      print(Vector2i(blocks_to_erase_1[0] + i, blocks_to_erase_1[1] + j))
      map.set_cell(Vector2i(blocks_to_erase_1[0] + i, blocks_to_erase_1[1] + j), -1)
  queue_free()
