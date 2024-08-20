class_name FloatAnimator extends Object

var state: String = 'idle'
@export var value: float = 0.0
var time: float = 0.0

@export var duration: float = 0.2

func set_state(active: bool):
	state = 'fwd' if active else 'bkw'

func process(delta: float):
	if state == 'fwd':
		time += delta
		if time >= duration:
			time = duration
			value = 1.0
			state = 'idle'
	elif state == 'bkw':
		time -= delta
		if time <= 0.0:
			time = 0.0
			value = 0.0
			state = 'idle'

	value = time / duration
