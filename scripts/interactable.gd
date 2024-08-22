class_name Interactable extends Node3D

@export var regionName: String = "Region"
@export var itemType: String

func perform_action(player: Player) -> void:
	player.grab(Globals.itemTypes[itemType].instantiate())
