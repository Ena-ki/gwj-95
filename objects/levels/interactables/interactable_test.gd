extends Node2D

func _on_interactable_component_exited() -> void:
  print("seeya")


func _on_interactable_component_entered() -> void:
  print("in range")


func _on_interactable_component_interacted() -> void:
  print("heello")
