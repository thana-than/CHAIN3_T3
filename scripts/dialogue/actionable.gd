#The purpose of this script is to be attached to an area3d and have a specified dialogue resource attached.
#The specified dialogue resource will begin playing at the specified line whenever the collision
#shape 3d is triggered.
extends Area3D

@export var custom_balloon_resource: PackedScene = preload("res://assets/dialogue/styles/gothic_silent_hill/Balloon.tscn")
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"
@export var is_repeatable: bool = false
@export var debug_verbose: bool = false

var _shown: bool = false
var logger: Logger = null

func _ready() -> void:
	logger = Logger.new(self.name)
	self.body_entered.connect(_on_body_entered)
	if debug_verbose:
		logger.log("_on_body_entered has been connected to the body_entered signal.")

# When triggered run dialogue unless this is not a repeatable trigger and 
# it has already triggered it once.
func _on_body_entered(body: Node3D) -> void:
	if debug_verbose:
		logger.log("_on_body_entered signalled by {name}".format({ "name": body.name }))
	if not is_repeatable:
		if _shown:
			return
		_shown = true
	DialogueManager.show_dialogue_balloon_scene(custom_balloon_resource, dialogue_resource, dialogue_start);
