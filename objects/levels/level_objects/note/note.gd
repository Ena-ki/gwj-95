extends Area2D

@export var label :RichTextLabel
@export_multiline var text : String


func _ready() -> void:
  label.text = text
  label.visible = false
  body_entered.connect(
    func(body: Node2D): 
    if body is Player:
      label.visible = true
  )

  body_exited.connect(
    func(body: Node2D): 
    if body is Player:
      label.visible = false
  )
