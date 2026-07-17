class_name AbilityInputOveray
extends CanvasLayer

@export var dash : Dash
@export var big_jump : BigJump
@export var dash_code_left : String = "AAA"
@export var dash_code_right : String = "DDD"
@export var jump_code : String = "DDD"
@export var line_edit : LineEdit

@export var input_sound : AudioStream
@export var correct_code_sound : AudioStream
@export var wrong_code_sound : AudioStream


#preventing holding, don't remove
#idk how this works either
func _input(event: InputEvent) -> void:
  if line_edit.has_focus() and event is InputEventKey and event.echo:
    get_viewport().set_input_as_handled()


func _ready() -> void:
  line_edit.text_changed.connect(_on_line_edit_text_changed)


func _process(_delta: float) -> void:
  if Input.is_action_just_pressed("code_input"):
    _start_editing()
  if Input.is_action_just_released("code_input"):
    _exit_editing()



func _on_line_edit_text_changed(text : String) -> void:
  if text.length() > 3:
    AudioLoader.play_sound(wrong_code_sound, 1.0, true)
    _exit_editing()
    return
  AudioLoader.play_sound(input_sound, -2.0, true)

  if text == dash_code_left:
    dash.dash_left()
    AudioLoader.play_sound(correct_code_sound, 1.0, true)
    _exit_editing()
  if text == dash_code_right:
    dash.dash_right()
    AudioLoader.play_sound(correct_code_sound, 1.0, true)
    _exit_editing()
  if text == jump_code:
    big_jump.big_jump()
    AudioLoader.play_sound(correct_code_sound, 1.0, true)
    _exit_editing()


func _start_editing() -> void:
  line_edit.edit()
  visible = true
  line_edit.text = ""
  Engine.time_scale = 0.1
  AudioServer.set_bus_effect_enabled(1, 0, true)


func _exit_editing() -> void:
  Engine.time_scale = 1.0
  AudioServer.set_bus_effect_enabled(1, 0, false)
  line_edit.unedit()
  visible = false
