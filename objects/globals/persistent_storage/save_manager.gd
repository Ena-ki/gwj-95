extends Node

const PATH = "user://save.json"

func save_game(data: Dictionary):
  var file = FileAccess.open(PATH, FileAccess.WRITE)
  file.store_string(JSON.stringify(data, "\t"))
  file.close()

func load_game() -> Dictionary:
  if not FileAccess.file_exists(PATH):
    return {}
  
  var file = FileAccess.open(PATH, FileAccess.READ)
  var content = file.get_as_text()
  var json = JSON.new()
  var error = json.parse(content)
  if error == OK:
    return json.get_data()
  else:
    print("Failed to save")
    return {}
