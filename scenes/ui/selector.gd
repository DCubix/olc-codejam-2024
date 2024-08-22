class_name Selector extends Node3D

var selectorItemPrefab = preload("res://scenes/selector_item.tscn")

@export var items: Array[SelectorItem]:
	set(value):
		if items != value:
			items = value
			_update_items()
@export var selected: int

@export var animation: float
			
var itemObjs: Array[Node3D]
var lerpedAngle: float = 0.0
var canSelect: bool = false
var wasGlobalDescLabelVisible: bool = false

func show_selector(pos: Vector3):
	$AnimationPlayer.play("popup")
	global_position = pos
	global_position.y = 10.0
	canSelect = true
	
	# hide global desc label if visible
	var lbl = $"/root/Node3D/region_name"
	wasGlobalDescLabelVisible = lbl.visible
	if lbl.visible:
		lbl.visible = false

func hide_selector() -> String:
	$AnimationPlayer.play_backwards("popup")
	canSelect = false

	var lbl = $"/root/Node3D/region_name"
	lbl.visible = wasGlobalDescLabelVisible

	return get_selection()

func get_selection() -> String:
	return items[selected].tag

func _init(items_content:Array[SelectorItem]=[]):
	items = items_content

func _process(delta: float) -> void:
	var angleStep = (PI * 2.0) / items.size()
	var angle = angleStep * selected + PI/2
	lerpedAngle = lerp_angle(lerpedAngle, angle, 0.3)
	$arrow.rotation.x = -lerpedAngle
	
	for i in itemObjs.size():
		var ob = itemObjs[i]
		var desc: Label3D = ob.get_node("selector_desc")
		desc.visible = true if selected == i else false
		ob.scale = Vector3(1.3, 1.3, 1.3) if selected == i else Vector3.ONE
		ob.scale *= animation
	
	if not Engine.is_editor_hint():
		#if Input.is_action_just_pressed("gi_cancel"):
			#hide_selector()
		
		if Input.is_action_just_pressed("gi_left"):
			selected -= 1
			if selected < 0: selected = items.size() - 1
		elif Input.is_action_just_pressed("gi_right"):
			selected += 1
			if selected > items.size() - 1: selected = 0

func _update_items():
	if items.is_empty():
		for obj in itemObjs:
			obj.queue_free()
			itemObjs = []
		return
	var radius = 1.5 + (-$arrow/arrow_mesh.position.z)
	var angleStep = (PI * 2.0) / items.size()
	var angle = 0.0
	for it in items:
		var x = cos(angle - PI/2) * radius
		var y = sin(angle - PI/2) * radius
		_spawn_icon(it.description, it.icon, Vector3(0.0, y, x))
		angle += angleStep

func _spawn_icon(description: String, texture: Texture2D, pos: Vector3):
	var si = selectorItemPrefab.instantiate()
	
	var desc: Label3D = si.get_node("selector_desc")
	var spr: Sprite3D = si.get_node("selector_sprite")
	
	desc.text = description
	desc.visible = false
	spr.texture = texture
	
	add_child(si)
	si.position = pos
	itemObjs.append(si)
