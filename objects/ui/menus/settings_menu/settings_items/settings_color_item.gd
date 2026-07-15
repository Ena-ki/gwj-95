class_name SettingsColorItem
extends OptionButton

@export var shader : ShaderMaterial
@export var palettes : Array[ColorPaletteItem]


func _ready() -> void:
  item_selected.connect(_on_item_selected)
  for i in range(palettes.size()):
    add_item(palettes[i].palette_name, i)


func _on_item_selected(i : int) -> void:
  var item := palettes[i]
  print(get_item_text(i))
  print(palettes[i-1].palette_name)
  shader.set_shader_parameter("color_map", item.palette)
