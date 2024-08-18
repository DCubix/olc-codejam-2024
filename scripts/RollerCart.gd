extends RigidBody3D

@onready var mkLeftBrake: Marker3D = $left_brake
@onready var mkRightBrake: Marker3D = $right_brake
@onready var mkSteer: Marker3D = $steer
@onready var mkBackSteer: Marker3D = $steer_back

@onready var cartModel: Node3D = $roller_cart_model
var cartAnim: AnimationTree

@onready var charModel: Node3D = $character
var charAnim: AnimationTree

@export var BrakingForce : float = 20
@export var SpeedAid : float = 25
@export var MaxWheelAngle : float = 45
@export var MaxVelocity : float = 35
@export var MaxAngularVelocity : float = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cartAnim = cartModel.get_node("AnimationTree")
	charAnim = charModel.get_node("AnimationTree")


func fix_drift(ref: Marker3D, power: float = 1.0):
	var vel = abs(linear_velocity.length())
	var state = PhysicsServer3D.body_get_direct_state(get_rid())
	
	var steerVec = ref.global_transform.basis.x
		
	var backWheelsVel = state.get_velocity_at_local_position(ref.position)
	var rightVec = steerVec
	var driftForce = backWheelsVel.dot(rightVec) * vel
	
	if abs(driftForce) <= 1e-5:
		driftForce = 0.0
	
	var driftVec = -steerVec * driftForce * power
	apply_force(driftVec, ref.position)
	DebugDraw3D.draw_arrow_ray(ref.global_position, driftVec.normalized(), driftVec.length(), Color.CYAN, 0.1)


func _physics_process(delta: float) -> void:
	var groundRaycast: RayCast3D = $RayCast3D
	var grounded = groundRaycast.is_colliding()

	var brakingLeft = Input.is_action_pressed("gi_brake_left")
	var brakingRight = Input.is_action_pressed("gi_brake_right")
	
	if abs(angular_velocity.length()) > MaxAngularVelocity:
		angular_velocity = angular_velocity.normalized() * MaxAngularVelocity
	
	var vel = abs(linear_velocity.length())
	if vel > MaxVelocity:
		linear_velocity = linear_velocity.normalized()
		linear_velocity *= MaxVelocity
		vel = MaxVelocity

	if grounded:
		var friction = -global_transform.basis.z * BrakingForce * vel * delta
		if brakingLeft:
			apply_force(friction, mkLeftBrake.position)
			DebugDraw3D.draw_arrow_ray(mkLeftBrake.global_position, friction.normalized(), friction.length(), Color.RED, 0.1)
		if brakingRight:
			apply_force(friction, mkRightBrake.position)
			DebugDraw3D.draw_arrow_ray(mkRightBrake.global_position, friction.normalized(), friction.length(), Color.RED, 0.1)

		var steer = Input.get_axis("gi_steer_left", "gi_steer_right")

		var maxWheelAngleRad = deg_to_rad(MaxWheelAngle) * -steer
		var steerVec = global_transform.basis.z.rotated(Vector3.UP, maxWheelAngleRad)
		var steerForce = steerVec * vel * abs(steer) * 30.0
		DebugDraw3D.draw_arrow_ray(mkSteer.global_position, steerForce, 1, Color.YELLOW, 0.1)

		apply_force(steerForce, mkSteer.position)
		fix_drift(mkBackSteer, 10.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var steer = Input.get_axis("gi_steer_left", "gi_steer_right")
	cartAnim.set("parameters/steering/blend_amount", steer)
	charAnim.set("parameters/steering/blend_amount", steer)
	
	var brakingLeftP = Input.is_action_just_pressed("gi_brake_left")
	var brakingRightP = Input.is_action_just_pressed("gi_brake_right")
	var brakingLeftR = Input.is_action_just_released("gi_brake_left")
	var brakingRightR = Input.is_action_just_released("gi_brake_right")
	
	if brakingLeftP:
		cartAnim.set("parameters/brake_left/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		charAnim.set("parameters/brake/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		charAnim.set("parameters/brake_dir/blend_position", -1.0)
	elif brakingLeftR:
		cartAnim.set("parameters/brake_left/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FADE_OUT)
		charAnim.set("parameters/brake/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FADE_OUT)
		charAnim.set("parameters/brake_dir/blend_position", 0.0)

	if brakingRightP:
		cartAnim.set("parameters/brake_right/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		charAnim.set("parameters/brake/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		charAnim.set("parameters/brake_dir/blend_position", 1.0)
	elif brakingRightR:
		cartAnim.set("parameters/brake_right/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FADE_OUT)
		charAnim.set("parameters/brake/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FADE_OUT)
		charAnim.set("parameters/brake_dir/blend_position", 0.0)
