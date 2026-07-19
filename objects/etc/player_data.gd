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


func enter_level_time(time : float, level_id : int):
  if level_id < 1:
    print("entered level id is less than 1")
    return
  
  if level_times.size() < level_id:
    level_times.resize(level_id)
    level_times.fill(-1)

  if level_times[level_id - 1] < 0 || level_times[level_id - 1] > time:
    level_times[level_id -1] = time
    print("entered time : ", time, " on level : ", level_id)
