class_name Grill extends Interactable

@onready var burnerPositions: Array[Marker3D] = [
	$burner1, $burner2, $burner3
]

var burnerState: Array[bool] = [ false, false, false ]
var burnerItems: Array[Node3D] = [ null, null, null ]

@export var grillStep: float = 10.0
@export var grillDelay: float = 0.25
var timer: float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	if timer >= grillDelay:
		timer = 0.0
		
		for i in burnerItems.size():
			var obj = burnerItems[i]
			if not obj: continue
			
			var ing: Ingredient = obj.get_node("ingredient")
			ing.temperature += grillStep
			ing.temperature = clamp(ing.temperature, 0.0, 400.0)
			
			var temp = int(ing.temperature)
			if temp >= int(ing.perfectTemperature)-6 and temp <= int(ing.perfectTemperature):
				show_reaction(Reaction.ReactionType.DONE, ing)

			if temp >= 216 and temp <= 220:
				show_reaction(Reaction.ReactionType.WARNING, ing)
			
			if temp >= 386 and temp <= 390:
				show_reaction(Reaction.ReactionType.BIOHAZARD, ing)

func show_reaction(type: Reaction.ReactionType, ing: Ingredient):
	var reac: Reaction = ing.get_node("reaction")
	reac.react(type)

func get_free_burner() -> int:
	for i in range(burnerState.size()):
		if not burnerState[i]:
			return i
	return -1

func remove_item(index: int) -> Node3D:
	if not burnerState[index]: return null
	burnerState[index] = false
	burnerItems[index].get_parent().remove_child(burnerItems[index])
	
	var tmp = burnerItems[index]
	burnerItems[index] = null
	tmp.get_node("ingredient").smokeEnabled = false
	return tmp

func place_item_raw(obj: Node3D):
	var burnerID = get_free_burner()
	if burnerID == -1: return
	
	var burnerPos = burnerPositions[burnerID]
	
	if burnerItems[burnerID]:
		burnerItems[burnerID].queue_free()
	
	if obj.get_parent() != null:
		obj.get_parent().remove_child(obj)
	burnerItems[burnerID] = obj
	
	var ingred: Node3D = burnerItems[burnerID].get_node("ingredient")
	if not ingred.canBeFried:
		ingred.queue_free()
		return
	
	ingred.smokeEnabled = true
	
	burnerPos.add_child(burnerItems[burnerID])
	burnerItems[burnerID].position = Vector3.ZERO

	burnerState[burnerID] = true

func place_item(type: String):
	place_item_raw(Globals.itemTypes[type].instantiate())
