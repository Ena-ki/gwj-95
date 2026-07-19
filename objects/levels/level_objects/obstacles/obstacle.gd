class_name Obstacle
extends Area2D


func _ready() -> void:
  body_entered.connect(_on_body_entered)
  


func _on_body_entered(body : Node2D) -> void:
  if body is not Player:
    return

  body.die()
