extends CharacterBody3D

@export var Gravity: float = 9.8
@export var Speed: float = 20.0
@export var TurnSpeed: float = 10.0

var animBlend: FloatAnimator
var anim: AnimationTree;

var facingAngle: float = 0

@export var RightHandItem: Node3D
var rightHandItemHolder: Marker3D

func _ready() -> void:
	anim = $character.get_node("AnimationTree")
	animBlend = FloatAnimator.new()
	rightHandItemHolder = $character/dude_skel/Skeleton3D/right_hand_att/right_hand_item
	
	if RightHandItem != null:
		RightHandItem.get_parent().remove_child(RightHandItem)
		rightHandItemHolder.add_child(RightHandItem)

func _process(delta: float) -> void:
	animBlend.process(delta)

func _physics_process(delta: float) -> void:
	velocity.y -= Gravity * delta
	
	var horAxis = Input.get_axis("gi_left", "gi_right")
	
	facingAngle += horAxis * TurnSpeed * delta
	var vec = Vector3(cos(facingAngle + PI/2), 0, sin(facingAngle + PI/2))
	
	DebugDraw3D.draw_arrow_ray(position, vec, 3, Color.AQUA, 0.15)
	
	var fwd = Input.get_action_strength("gi_forward")
	if Input.is_action_pressed("gi_forward"):
		velocity.x = vec.x * Speed * delta * fwd
		velocity.z = vec.z * Speed * delta * fwd
		anim.set("parameters/run/blend_amount", fwd * animBlend.value)
		animBlend.set_state(true)
	else:
		velocity.x = 0
		velocity.z = 0
		anim.set("parameters/run/blend_amount", animBlend.value)
		animBlend.set_state(false)

	rotation.y = -facingAngle
	
	move_and_slide()
