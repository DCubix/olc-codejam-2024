class_name Player extends CharacterBody3D

@onready var displayInfo: LabelInfo = $"/root/Node3D/region_name"
@onready var itemHolder: Marker3D = $character/dude_skel/Skeleton3D/right_hand_att/holding

@export var Gravity: float = 9.8
@export var Speed: float = 20.0
@export var TurnSpeed: float = 10.0

@export var canMove: bool = true

var animBlend: FloatAnimator
var anim: AnimationTree;

var facingAngle: float = 0
var isHoldingItem: bool = false

@export var RightHandItem: Node3D
var rightHandItemHolder: Marker3D
var holdingItemObj: Node3D

func _ready() -> void:
	anim = $character.get_node("AnimationTree")
	animBlend = FloatAnimator.new()
	rightHandItemHolder = $character/dude_skel/Skeleton3D/right_hand_att/right_hand_item

	if RightHandItem != null:
		RightHandItem.reparent.call_deferred(rightHandItemHolder, false)
		RightHandItem.position = Vector3.ZERO

func _process(delta: float) -> void:
	animBlend.process(delta)
	
	var interactCast: RayCast3D = $region_cast
	if interactCast.is_colliding():
		var col: Interactable = interactCast.get_collider() as Interactable
		if Input.is_action_just_pressed("gi_take"):
			col.perform_action(self)
	else:
		displayInfo.visible = false

func _physics_process(delta: float) -> void:
	velocity.y -= Gravity * delta
	
	if canMove:
		var horAxis = Input.get_axis("gi_left", "gi_right")
		facingAngle += horAxis * TurnSpeed * delta

	var vec = Vector3(cos(facingAngle + PI/2), 0, sin(facingAngle + PI/2))
	
	var fwd = Input.get_action_strength("gi_forward")
	if Input.is_action_pressed("gi_forward") and canMove:
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

func clear_item():
	isHoldingItem = false
	anim.set("parameters/hold/blend_amount", 0.0)
	if holdingItemObj != null:
		holdingItemObj = null

func grab(obj: Node3D):
	if not obj: return
	
	holdingItemObj = obj
	
	itemHolder.add_child(holdingItemObj)
	holdingItemObj.position = Vector3.ZERO
	
	# disable collision
	holdingItemObj.get_node("ingredient/ingredient_col/ingredient_shape").disabled = true
	
	anim.set("parameters/hold/blend_amount", 1.0)
	anim.set("parameters/flip/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

	isHoldingItem = true

func drop():
	clear_item()
	anim.set("parameters/hold/blend_amount", 0.0)
	anim.set("parameters/flip/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
