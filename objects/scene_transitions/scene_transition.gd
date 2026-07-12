class_name SceneTransition
extends CanvasLayer
# Base class for scene transitions. Only the interface is defined, so you can be free in
# what the start and start_back do

signal finished
signal back_finished


func start() -> void:
  finished.emit()


func start_back() -> void:
  back_finished.emit()
