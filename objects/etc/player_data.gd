class_name PlayerData
extends Resource

signal level_progress_updated(level_progress : int)

@export var level_progress : int = 1:
  set(val):
    level_progress = val
    level_progress_updated.emit(val)
  get:
    return level_progress

@export var current_palette : ColorPaletteItem #grep current_theme
@export var current_palette_id : int = 0
@export var level_times : Array[float] = []
