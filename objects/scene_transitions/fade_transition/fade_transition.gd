extends SceneTransition
# Basic fade transition made with an animation player

@export var animation_player : AnimationPlayer


func start() -> void:
  animation_player.play("start")
  await animation_player.animation_finished
  finished.emit()


func start_back() -> void:
  animation_player.play("start_back")
  await animation_player.animation_finished
  back_finished.emit()
