extends Interactable

@onready var selector: Selector = $"/root/Node3D/asm_selector"
var selecting: bool = false

var ingredients: Array[Node3D]
var cursor: float = 0.0

func perform_action(player: Player) -> void:
	if not selecting:
		selector.show_selector(global_position)
		player.canMove = false
		selecting = true
	else:
		player.canMove = true
		selecting = false
		var tag = selector.hide_selector()
		
		if tag == "TKO": # take out top ingredient
			_take_out_action(player)
		elif tag == "PLC": # place ingredient
			_place_ingredient_action(player)
		elif tag == "END": # finish burger
			pass

func _take_out_action(player: Player):
	if player.holdingItemObj: return
	var item = remove_back_item()
	if item:
		player.grab(item)

func _place_ingredient_action(player: Player):
	if not player.holdingItemObj: return
	var obj = player.holdingItemObj
	var ingred = obj.get_node("ingredient") as Ingredient
	place_item_raw(obj)
	obj.position.y = cursor
	obj.rotation.y = randf_range(-PI, PI)
	cursor += ingred.get_height() * 0.5 + 0.001
	player.drop()

func remove_back_item() -> Node3D:
	if ingredients.is_empty(): return null
	var item = ingredients[ingredients.size() - 1]
	var ingred = item.get_node("ingredient") as Ingredient
	item.get_parent().remove_child(item)
	ingredients.remove_at(ingredients.size() - 1)
	cursor -= ingred.get_height() * 0.5 + 0.001
	return item

func place_item_raw(obj: Node3D):
	if obj.get_parent() != null:
		obj.get_parent().remove_child(obj)
	
	$CuttingBoard/burger_board.add_child(obj)
	
	ingredients.append(obj)
	print(ingredients.size())
	
	obj.position = Vector3.ZERO
