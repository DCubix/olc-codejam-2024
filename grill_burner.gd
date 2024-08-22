class_name GrillBurner extends Interactable

var isBeingUsed: bool = false
var item: Node3D

@export var burnerStep: float = 10.0
@export var burnerDelay: float = 0.25
var timer: float = 0.0

func perform_action(player: Player) -> void:
	if not isBeingUsed and player.holdingItemObj:
		place_item_raw(player.holdingItemObj)
		player.drop()
	elif isBeingUsed and not player.holdingItemObj:
		player.grab(remove_item())

func _process(delta: float) -> void:
	timer += delta
	if timer >= burnerDelay:
		timer = 0.0
		
		if not item: return
		
		var ing: Ingredient = item.get_node("ingredient")
		ing.temperature += burnerStep
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

func remove_item() -> Node3D:
	if not isBeingUsed: return null
	isBeingUsed = false
	item.get_parent().remove_child(item)
	
	var tmp = item
	item = null
	tmp.get_node("ingredient").smokeEnabled = false
	return tmp

func place_item_raw(obj: Node3D):
	if isBeingUsed: return
	
	if item: item.queue_free()
	
	if obj.get_parent() != null:
		obj.get_parent().remove_child(obj)
	item = obj
	
	var ingred: Node3D = item.get_node("ingredient")
	if not ingred.canBeFried:
		ingred.queue_free()
		return
	
	ingred.smokeEnabled = true
	
	$burner_marker.add_child(item)
	item.position = Vector3.ZERO

	isBeingUsed = true

func place_item(type: String):
	place_item_raw(Globals.itemTypes[type].instantiate())
