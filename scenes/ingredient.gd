@tool
class_name Ingredient extends Node3D

@export_category("Config")
@export var label: String
@export_range(0, 400, 1, "suffix:C") var perfectTemperature: float
@export var canBeFried: bool

@export var smokeEnabled: bool

@onready var meshInstance: MeshInstance3D = $ingredient_col/ingredient_mesh
@onready var shader: VisualShader = preload("res://scripts/doneness.tres")
@onready var smoke: GPUParticles3D = $smoke

@export_category("Visual")
@export var mesh: ArrayMesh:
	set(value):
		if value != mesh:
			mesh = value
			update_mesh()

@export var meshWhenDone: ArrayMesh:
	set(value):
		if value != meshWhenDone:
			meshWhenDone = value
			update_mesh()

@export var textures: Array[Texture2D]:
	set(value):
		if value != textures:
			textures = value
			update_mesh()

@export_range(0, 400, 1, "suffix:C") var temperature: float:
	set(value):
		if value != temperature:
			temperature = value
			update_mesh()

func update_mesh():
	if meshInstance == null: return
	if meshWhenDone != null:
		meshInstance.mesh = mesh if temperature < perfectTemperature else meshWhenDone
	else:
		meshInstance.mesh = mesh

	var mat: ShaderMaterial = meshInstance.get_active_material(0) as ShaderMaterial
	mat.set_shader_parameter("raw_texture", textures[0] if textures.size() > 0 else null)
	mat.set_shader_parameter("done_texture", textures[1] if textures.size() > 1 else null)
	mat.set_shader_parameter("burnt_texture", textures[2] if textures.size() > 2 else null)
	
func _ready() -> void:
	var mat: ShaderMaterial = ShaderMaterial.new()
	mat.shader = shader
	meshInstance.set_surface_override_material(0, mat)
	update_mesh()

func _process(delta: float) -> void:
	var mat: ShaderMaterial = meshInstance.get_active_material(0) as ShaderMaterial
	if mat: mat.set_shader_parameter("temperature", temperature)

	if smoke:
		var pmat: ParticleProcessMaterial = smoke.process_material
		var factor = clamp(((temperature / 400.0) - 0.5) / 0.5, 0.0, 1.0)
		pmat.color = Color.WHITE.lerp(Color.BLACK, factor)

		smoke.emitting = smokeEnabled

func get_height() -> float:
	return meshInstance.get_aabb().size.y
