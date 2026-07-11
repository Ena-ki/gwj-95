extends Control
# Main menu script that controls entire main menu. 
# Settings menu is implemented through its own script though

@export_file("*.tscn") var game_scene

@export var play_button : Button
@export var settings_button : Button
@export var exit_button : Button
@export var settings_menu : Control


func _ready() -> void:
  play_button.pressed.connect(_on_play_button_pressed)
  settings_button.pressed.connect(_on_settings_button_pressed)
  exit_button.pressed.connect(_on_exit_button_pressed)


func _on_play_button_pressed() -> void:
  get_tree().change_scene_to_file(game_scene)


func _on_settings_button_pressed() -> void:
  settings_menu.visible = true


func _on_exit_button_pressed() -> void:
  get_tree().quit()
