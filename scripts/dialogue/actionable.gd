#The purpose of this script is to be attached to an area3d and have a specified dialogue resource attached.
#The specified dialogue resource will begin playing at the specified line whenever the collision
#shape 3d is triggered.
extends Area3D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"
@export var is_repeatable: bool = false

var _shown: bool = false

# When triggered run dialogue unless this is not a repeatable trigger and 
# it has already triggered it once.
func _on_body_entered(body: Node3D) -> void:
	if not is_repeatable:
		if _shown:
			return
		_shown = true
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
