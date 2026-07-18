extends Area2D

@export var blocks_to_erase : Array[Vector2i]
@export var map : TileMapLayer
@export var collect_sound : AudioStream


func _ready() -> void:
  body_entered.connect(_on_body_entered)


func _on_body_entered(body : Node2D) -> void:
  if body is not Player:
    return

  AudioLoader.play_sound(collect_sound)
  for i in range(blocks_to_erase.size()):
    map.set_cell(blocks_to_erase[i], -1)
  queue_free()

