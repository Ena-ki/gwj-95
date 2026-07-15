extends Control
# Main menu script that controls entire main menu. 
# Settings menu is implemented through its own script though

@export var scene_selector : Control
@export var play_button : Button
@export var settings_button : Button
@export var exit_button : Button
@export var settings_menu : Control


func _ready() -> void:
  play_button.pressed.connect(_on_play_button_pressed)
  settings_button.pressed.connect(_on_settings_button_pressed)
  exit_button.pressed.connect(_on_exit_button_pressed)


func _on_play_button_pressed() -> void:
  scene_selector.visible = true


func _on_settings_button_pressed() -> void:
  settings_menu.visible = true


func _on_exit_button_pressed() -> void:
  get_tree().quit()
