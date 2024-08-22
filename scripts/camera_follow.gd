extends Camera3D

@export var target: Node3D
@export var offsetY: float = 0.0
@export var lerpFactor: float = 0.2

var offsetVec: Vector3

func _ready():
	offsetVec = (global_position - target.global_position)
	offsetVec.y += offsetY

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = lerp(global_position, target.global_position + offsetVec, lerpFactor)
