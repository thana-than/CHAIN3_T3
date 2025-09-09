extends Node
class_name DialoguePlayer

signal on_play_dialogue()

var custom_balloon_resource: PackedScene = preload("res://assets/dialogue/styles/gothic_silent_hill/Balloon.tscn")
var dialogue_resource: DialogueResource
var dialogue_start: String = "start"
var is_repeatable: bool = false

var _shown: bool = false

func play_dialogue() -> void:
	if not is_repeatable:
		if _shown:
			return
		_shown = true
	DialogueManager.show_dialogue_balloon_scene(custom_balloon_resource, dialogue_resource, dialogue_start);
	on_play_dialogue.emit()
