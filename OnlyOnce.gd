class_name OnlyOnce extends Node

@export var condition: Callable
@export var action: Callable

var conditionMet: bool = false

func _init(condition: Callable, action: Callable):
	self.condition = condition
	self.action = action

func poll():
	if not conditionMet and condition.call():
		action.call()
		conditionMet = true
