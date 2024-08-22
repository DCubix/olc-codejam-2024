extends Interactable

@onready var reaction: Reaction = $"../reaction"
@onready var selector: Selector = $"/root/Node3D/computer_selector"
var selecting: bool = false

@export var orders: Array[Order]
@export var reviews: Array[Review]

func perform_action(player: Player) -> void:
	if not selecting:
		selector.show_selector(global_position)
		player.canMove = false
		selecting = true
	else:
		player.canMove = true
		selecting = false
		var tag = selector.hide_selector()
