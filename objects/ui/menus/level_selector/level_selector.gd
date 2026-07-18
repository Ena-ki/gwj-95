extends Control

@export var back_button : BaseButton
@export var level_select_buttons : Array[BaseButton]
@export_file("*.tscn") var level_scenes : Array[String] = ["","","","",""]
@export_file("*.tscn") var transition_scene : String = ""

@export var player_data : PlayerData
@export var hover_sound : AudioStream
@export var selecting_sound : AudioStream
@export var back_sound : AudioStream


func _ready() -> void:
  print(player_data.current_palette)
  for i in range(player_data.level_times.size()):
    print(player_data.level_times[i])
  for i in range(level_select_buttons.size()):
    level_select_buttons[i].mouse_entered.connect(func() : AudioLoader.play_sound(hover_sound))
  level_select_buttons[0].pressed.connect(_on_level_select_button_1_pressed)
  level_select_buttons[1].pressed.connect(_on_level_select_button_2_pressed)
  level_select_buttons[2].pressed.connect(_on_level_select_button_3_pressed)
  level_select_buttons[3].pressed.connect(_on_level_select_button_4_pressed)
  level_select_buttons[4].pressed.connect(_on_level_select_button_5_pressed)
  back_button.pressed.connect(_on_back_button_pressed)
  back_button.mouse_entered.connect(func() : AudioLoader.play_sound(hover_sound))
  visibility_changed.connect(_on_visibility_changed)


func _unhandled_input(event: InputEvent) -> void:
  if event.is_action_pressed("ui_cancel") && visible:
    AudioLoader.play_sound(back_sound)
    visible = false
    get_viewport().set_input_as_handled()


func _on_visibility_changed() -> void:
  for i in range(level_select_buttons.size()):
    if player_data.level_progress > i:
      level_select_buttons[i].disabled = false
    else:
      level_select_buttons[i].disabled = true

    
func _on_back_button_pressed() -> void:
  AudioLoader.play_sound(back_sound, -2.0)
  visible = false


func _on_level_select_button_1_pressed() -> void:
  SceneLoader.change_scene(level_scenes[0], transition_scene)
  AudioLoader.play_sound(selecting_sound)


func _on_level_select_button_2_pressed() -> void:
  SceneLoader.change_scene(level_scenes[1], transition_scene)
  AudioLoader.play_sound(selecting_sound)


func _on_level_select_button_3_pressed() -> void:
  SceneLoader.change_scene(level_scenes[2], transition_scene)
  AudioLoader.play_sound(selecting_sound)


func _on_level_select_button_4_pressed() -> void:
  SceneLoader.change_scene(level_scenes[3], transition_scene)
  AudioLoader.play_sound(selecting_sound)


func _on_level_select_button_5_pressed() -> void:
  SceneLoader.change_scene(level_scenes[4], transition_scene)
  AudioLoader.play_sound(selecting_sound)
