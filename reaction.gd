class_name Reaction extends Node3D

enum ReactionType {
	OFF = 0,
	DONE,
	WARNING,
	WORRIED,
	HAPPY,
	NEUTRAL,
	ANGRY,
	RAGE,
	BIOHAZARD,
	BELL,
	STAR,
	SPEECH,
	VOMIT,
	QUESTION
}

var reactionEmojis = [
	"", "👌", "⚠️", "😟", "☺️", "😐", 
	"😠", "🤬", "☣️", "🔔", "⭐", "💬",
	"🤮", "❓"
]

@export var reaction: ReactionType:
	set(value):
		if value != reaction:
			reaction = value
			react(value)

func react(type: ReactionType) -> bool:
	var anim: AnimationPlayer = $reaction_label/popup_animation
	var label: Label3D = $reaction_label

	if type == ReactionType.OFF:
		anim.stop()
		label.text = ""
		label.visible = false
		return false
	
	if reaction == type:
		return false
	reaction = type
	
	label.text = reactionEmojis[type]
	label.visible = true
	
	anim.play("popup")
	
	return true
