class_name LabelInfo extends Label3D

@onready var anim: AnimationPlayer = $AnimationPlayer
var shown: bool = false

func show_message(message: String, where: Vector3):
	visible = true
	text = message
	position = where
