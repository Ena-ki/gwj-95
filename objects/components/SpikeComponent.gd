extends Area2D
class_name SpikesComponent





func _ready() -> void:
	body_entered.connect(on_hit)

func on_hit(body):
	if body is Player and body.has_method("die"):
		body.die()
