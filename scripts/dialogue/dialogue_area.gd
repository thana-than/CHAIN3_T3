#The purpose of this script is to be attached to an area3d and have a specified dialogue resource attached.
#The specified dialogue resource will begin playing at the specified line whenever the collision
#shape 3d is triggered.
extends Area3D

@export var dialogue_settings := DialogueSettings.new()
@export var player_settings := DialoguePlayerSettings.new()
@export var debug_verbose: bool = false

@onready var dialogue_player: DialoguePlayer = DialoguePlayer.new(dialogue_settings, player_settings)
@onready var logger := Logger.new(name)

func _ready() -> void:
	add_child(dialogue_player)
	self.body_entered.connect(_on_body_entered)
	if debug_verbose:
		logger.log("_on_body_entered has been connected to the body_entered signal.")

# When triggered run dialogue unless this is not a repeatable trigger and 
# it has already triggered it once.
func _on_body_entered(body: Node3D) -> void:
	if debug_verbose:
		logger.log("_on_body_entered signalled by {name}".format({ "name": body.name }))
	if dialogue_player:
		dialogue_player.play_dialogue()
