extends Area2D
class_name SpikesComponent


signal hit
func _ready() -> void:
  body_entered.connect(on_hit)

func on_hit(body):
  if body is Player:
    hit.emit()
