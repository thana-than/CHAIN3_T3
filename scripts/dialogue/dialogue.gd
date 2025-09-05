extends Node

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("_debug_test_dialogue"):
		DialogueManager.show_example_dialogue_balloon(load("res://dialogue/test_001.dialogue"), "start")
		return
