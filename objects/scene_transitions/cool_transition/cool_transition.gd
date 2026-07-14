extends SceneTransition

@export var animation_player : AnimationPlayer


func start() -> void:
  animation_player.play("start")
  await animation_player.animation_finished
  finished.emit()


func start_back() -> void:
  animation_player.play("start_back")
  await animation_player.animation_finished
  back_finished.emit()


func _process(_delta: float) -> void:
  animation_player.speed_scale = 1.0 / Engine.time_scale
