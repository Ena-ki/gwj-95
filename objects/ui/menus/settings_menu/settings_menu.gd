extends Control
# Settings menu script


@export var back_button : Button
@export var fullscreen_button : BaseButton

@export var hover_sound : AudioStream
@export var selecting_sound : AudioStream
@export var back_sound : AudioStream


func _ready() -> void:
  back_button.mouse_entered.connect(func(): AudioLoader.play_sound(hover_sound))
  fullscreen_button.mouse_entered.connect(func(): AudioLoader.play_sound(hover_sound))

  back_button.pressed.connect(_on_back_button_pressed)
  fullscreen_button.toggled.connect(_on_fullscreen_button_toggled)
  visibility_changed.connect(_on_visibility_changed)


func _unhandled_input(event: InputEvent) -> void:
  if event.is_action_pressed("ui_cancel") && visible:
    AudioLoader.play_sound(back_sound, -2.0)
    visible = false
    get_viewport().set_input_as_handled()


func _on_visibility_changed() -> void:
  if is_visible_in_tree():
    set_process_input(true)
    set_process_unhandled_input(true)
  else:
    set_process_input(false)
    set_process_unhandled_input(false)


func _on_back_button_pressed():
  AudioLoader.play_sound(back_sound, -2.0)
  visible = false


func _on_fullscreen_button_toggled(toggled_on : bool) -> void:
  AudioLoader.play_sound(selecting_sound)
  if toggled_on:
    DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)
  else:
    DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
