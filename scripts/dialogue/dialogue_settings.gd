extends Resource
class_name DialogueSettings

@export var balloon_scene: PackedScene = preload("res://assets/dialogue/styles/gothic_silent_hill/Balloon.tscn")
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"
@export var audio_ignore_player_name := "Slater"
@export var audio_stop_delay := 1.0
