extends Control

@export var resume_button : Button
@export var settings_button : Button
@export var main_menu_button : Button

@export var settings_menu : Control
@export_file("*.tscn") var main_menu_scene : String
@export_file("*.tscn") var transition_scene : String


func _unhandled_input(event: InputEvent) -> void:
  if event.is_action_pressed("ui_cancel"):
    visible = !visible


func _ready() -> void:
  resume_button.pressed.connect(_on_resume_button_pressed)
  settings_button.pressed.connect(_on_settings_button_pressed)
  main_menu_button.pressed.connect(_on_main_menu_button_pressed)


func _on_resume_button_pressed() -> void:
  visible = false


func _on_settings_button_pressed() -> void:
  settings_menu.visible = true


func _on_main_menu_button_pressed() -> void:
  SceneLoader.change_scene(main_menu_scene, transition_scene)
