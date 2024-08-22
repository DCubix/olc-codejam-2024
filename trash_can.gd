extends Interactable

func perform_action(player: Player) -> void:
	var obj = player.holdingItemObj
	if not obj: return

	if obj.get_parent() != null:
		obj.get_parent().remove_child(obj)
	obj.queue_free()
	player.drop()
