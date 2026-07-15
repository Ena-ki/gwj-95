class_name PlayerData
extends Resource

signal level_progress_updated(level_progress : int)

@export var level_progress : int = 1:
  set(val):
    level_progress = val
    level_progress_updated.emit(val)
  get:
    return level_progress

@export var current_theme : int = 0
