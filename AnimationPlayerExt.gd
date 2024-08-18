class_name AnimationPlayerExt extends AnimationPlayer

var forward: bool = false
var tempName: StringName;

func play_flipper(name: StringName):
	if not forward:
		tempName = name
		play(name)
		forward = true

func _process(delta: float) -> void:
	pass
