class_name SettingsColorItem
extends OptionButton

@export var shader : ShaderMaterial
@export var palettes : Array[ColorPaletteItem]
@export var player_data : PlayerData


func _ready() -> void:
  item_selected.connect(_on_item_selected)
  for i in range(palettes.size()):
    add_item(palettes[i].palette_name, i)
  select(player_data.current_palette_id)


func _on_item_selected(i : int) -> void:
  player_data.current_palette = palettes[i]
  player_data.current_palette_id = i
  print(get_item_text(i))
  print(palettes[i].palette_name)
  shader.set_shader_parameter("color_map", player_data.current_palette.palette)
