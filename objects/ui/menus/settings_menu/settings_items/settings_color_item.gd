class_name SettingsColorItem
extends HBoxContainer

@export var shader : ShaderMaterial
@export var style_base : Array[Color] = [Color.BLACK, Color.RED, Color.BLUE, Color.WHITE]
@export var style_base_button : BaseButton
@export var style_1 : Array[Color] = [Color.BLACK, Color.RED, Color.BLUE, Color.WHITE]
@export var style_1_button : BaseButton


func _ready() -> void:
  style_base_button.pressed.connect(_on_style_base_button_pressed)
  style_1_button.pressed.connect(_on_style_1_button_pressed)


func _on_style_base_button_pressed() -> void:
  shader.set_shader_parameter("color_map", style_base)


func _on_style_1_button_pressed() -> void:
  shader.set_shader_parameter("color_map", style_1)
