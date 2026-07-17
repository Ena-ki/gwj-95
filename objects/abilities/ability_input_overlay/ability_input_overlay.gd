class_name AbilityInputOveray
extends CanvasLayer

@export var dash : Dash
@export var big_jump : BigJump
@export var dash_code_left : String = "AAA"
@export var dash_code_right : String = "DDD"
@export var jump_code : String = "DDD"
@export var line_edit : LineEdit


func _ready() -> void:
  line_edit.text_changed.connect(_on_line_edit_text_changed)


func _process(_delta: float) -> void:
  if Input.is_action_just_pressed("code_input"):
    _start_editing()
  if Input.is_action_just_released("code_input"):
    _exit_editing()



func _on_line_edit_text_changed(text : String) -> void:
  if text.length() > 3:
    _exit_editing()
    return
  print(text)
  if text == dash_code_left:
    dash.dash_left()
    _exit_editing()
  if text == dash_code_right:
    dash.dash_right()
    _exit_editing()
  if text == jump_code:
    big_jump.big_jump()
    _exit_editing()


func _start_editing() -> void:
  line_edit.edit()
  visible = true
  line_edit.text = ""
  Engine.time_scale = 0.1


func _exit_editing() -> void:
  Engine.time_scale = 1.0
  line_edit.unedit()
  visible = false
