extends Node
class_name InteractableComponent

@export var area_2d: Area2D
var entity_in_range = null
var can_interact := true

signal interact
signal in_range
signal out_of_range

func _ready() -> void:
  '''
  WIP but thinking there should be a signal here to reactivate can_interact after the interaction is done
  Maybe whip out a small timer after the interaction is done, once the timer is done player can interact again
  
  omg I forgot you can docstrings
  '''
  area_2d.body_entered.connect(_on_body_entered)
  area_2d.body_exited.connect(_on_body_exited)


func _unhandled_input(event: InputEvent) -> void:
  if entity_in_range and Input.is_action_just_pressed("interact") and can_interact:
    can_interact = false
    interact.emit()
    get_viewport().set_input_as_handled()
    

func _on_body_entered(body: Node):
  in_range.emit()
  entity_in_range = body


func _on_body_exited(body: Node):
  if body == entity_in_range:
    out_of_range.emit()
    entity_in_range = null
