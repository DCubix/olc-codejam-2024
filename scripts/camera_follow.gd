extends Camera3D

@export var target: Node3D

var offset: Vector3

func _ready():
	offset = global_position - target.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var target_axis = target.global_transform.basis.z
	var off = offset.rotated(Vector3.UP, target.global_rotation.y)
	
	global_position = lerp(global_position, target.global_position + off, 0.03)
	var xform = global_transform.looking_at(target.global_position)
	global_transform = global_transform.interpolate_with(xform, 0.1)
