extends Control
# Main menu script that controls entire main menu. 
# Settings menu is implemented through its own script though

@export var scene_selector : Control
@export var play_button : Button
@export var settings_button : Button
@export var exit_button : Button
@export var settings_menu : Control
@export var hidden_nodes : Array[Node] = []

@export var main_menu_music : AudioStream
@export var hover_sound : AudioStream
@export var selecting_sound : AudioStream
@export var player_data : PlayerData


func _ready() -> void:
  AudioLoader.play_music(main_menu_music)

  play_button.mouse_entered.connect(func() : AudioLoader.play_sound(hover_sound))
  play_button.pressed.connect(_on_play_button_pressed)
  settings_button.mouse_entered.connect(func() : AudioLoader.play_sound(hover_sound))
  settings_button.pressed.connect(_on_settings_button_pressed)
  exit_button.mouse_entered.connect(func() : AudioLoader.play_sound(hover_sound))
  exit_button.pressed.connect(_on_exit_button_pressed)
  if player_data.level_progress >= 4:
    for i in range(hidden_nodes.size()):
      hidden_nodes[i].visible = true



func _on_play_button_pressed() -> void:
  AudioLoader.play_sound(selecting_sound)
  scene_selector.visible = true


func _on_settings_button_pressed() -> void:
  AudioLoader.play_sound(selecting_sound)
  settings_menu.visible = true


func _on_exit_button_pressed() -> void:
  AudioLoader.play_sound(selecting_sound)
  get_tree().quit()
