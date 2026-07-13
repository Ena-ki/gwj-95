extends Node2D


func _on_interactable_component_interact() -> void:
  print("heello")


func _on_interactable_component_in_range() -> void:
  print("in range")
  
  
func _on_interactable_component_out_of_range() -> void:
  print("seeya")
