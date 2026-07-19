extends Control

@export var back_button : BaseButton
@export var level_select_buttons : Array[LevelSelectButton]
@export var tooltip : TimeTooltip
@export var player_data : PlayerData

@export_file("*.tscn") var transition_scene : String = ""


@export var hover_sound : AudioStream
@export var selecting_sound : AudioStream
@export var back_sound : AudioStream


func _ready() -> void:

  for i in range(level_select_buttons.size()):
    level_select_buttons[i].mouse_entered.connect(func() : 
      #ttip logic
      if player_data.level_times.size() >= i + 1 && player_data.level_times[i]:
        tooltip.visible = true
        tooltip.show_level_time(player_data.level_times[i])
      AudioLoader.play_sound(hover_sound)
      )
    level_select_buttons[i].mouse_exited.connect(func() : tooltip.visible = false)

  for i in range(level_select_buttons.size()):
    level_select_buttons[i].pressed.connect(func() : 
      SceneLoader.change_scene(level_select_buttons[i].level_scene,transition_scene)
      AudioLoader.play_sound(selecting_sound)
    )

  back_button.pressed.connect(_on_back_button_pressed)
  back_button.mouse_entered.connect(func() : AudioLoader.play_sound(hover_sound))
  visibility_changed.connect(_on_visibility_changed)


func _on_visibility_changed() -> void:
  for i in range(level_select_buttons.size()):
    if player_data.level_progress > i:
      level_select_buttons[i].disabled = false
    else:
      level_select_buttons[i].disabled = true


func _unhandled_input(event: InputEvent) -> void:
  if event.is_action_pressed("ui_cancel") && visible:
    AudioLoader.play_sound(back_sound)
    visible = false
    get_viewport().set_input_as_handled()

    
func _on_back_button_pressed() -> void:
  AudioLoader.play_sound(back_sound, -2.0)
  visible = false
