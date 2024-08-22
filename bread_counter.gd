extends Interactable

@onready var breadSelector: Selector = $"/root/Node3D/bread_selector"

var selectingBread: bool = false

func perform_action(player: Player) -> void:
	if not selectingBread and not player.holdingItemObj:
		breadSelector.show_selector(global_position)
		player.canMove = false
		selectingBread = true
	else:
		player.canMove = true
		selectingBread = false
		var tag = breadSelector.hide_selector()
		player.grab(Globals.itemTypes[tag].instantiate())
