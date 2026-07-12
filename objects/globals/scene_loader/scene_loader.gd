extends Node
# SceneLoader class to make scene transitions easier
# See SceneTransition for scene transitions

var progress : Array = []
var new_scene_path : String = ""
var transition : SceneTransition


func change_scene(_new_scene_path : String, transition_path : String, use_threads : bool = true):
  #checking if it already loads anything
  var status = ResourceLoader.load_threaded_get_status(new_scene_path, progress)
  if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
    push_warning("Error during scene loading : change_scene() called during scene changing")

  #request the load
  new_scene_path = _new_scene_path
  var loading_state = ResourceLoader.load_threaded_request(new_scene_path, "", use_threads)

  #check if the scene is valid
  if loading_state != OK:
    push_error("Error during scene loading : invalid scene")
    return

  # start the transition while the loading started
  transition = load(transition_path).instantiate() as SceneTransition
  add_child(transition)
  transition.finished.connect(_on_transition_finished)
  transition.back_finished.connect(_on_transition_back_finished)
  transition.start()


func _ready() -> void:
  set_process(false)


func _process(_delta: float) -> void:
  var status = ResourceLoader.load_threaded_get_status(new_scene_path, progress)

  match status:
    ResourceLoader.THREAD_LOAD_INVALID_RESOURCE, ResourceLoader.THREAD_LOAD_FAILED:
      set_process(false)
    ResourceLoader.THREAD_LOAD_LOADED:
      var loaded_scene = ResourceLoader.load_threaded_get(new_scene_path)
      get_tree().change_scene_to_packed(loaded_scene)
      set_process(false)
      transition.start_back()


func _on_transition_finished() -> void:
  set_process(true)


func _on_transition_back_finished() -> void:
  transition.queue_free()
