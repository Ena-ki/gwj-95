extends Area2D
class_name InteractableComponent


var entity_in_range = null
var can_interact := true

signal interacted
signal entered
signal exited

func _ready() -> void:
  '''
  WIP but thinking there should be a signal here to reactivate can_interact after the interaction is done
  Maybe whip out a small timer after the interaction is done, once the timer is done player can interact again
  '''
  body_entered.connect(_on_body_entered)
  body_exited.connect(_on_body_exited)


func _unhandled_input(event: InputEvent) -> void:
  if entity_in_range and Input.is_action_just_pressed("interact") and can_interact:
    can_interact = false
    interacted.emit()
    get_viewport().set_input_as_handled()
    

func _on_body_entered(body: Node):
  if body is Player:
    entered.emit()
    entity_in_range = body


func _on_body_exited(body: Node):
  if body is Player:
    exited.emit()
    entity_in_range = null
