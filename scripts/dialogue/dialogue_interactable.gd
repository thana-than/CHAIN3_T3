extends Interactable3D
class_name DialogueInteractable

@export var dialogue_settings := DialogueSettings.new()
@export var player_settings := DialoguePlayerSettings.new()
@export var debug_verbose: bool = false

@onready var dialogue_player := DialoguePlayer.new(dialogue_settings, player_settings)
@onready var logger := Logger.new(name)

func _ready() -> void:
	add_child(dialogue_player)
	interacted.connect(_on_interact)
	if debug_verbose:
		logger.log("_on_body_entered has been connected to the body_entered signal.")

func _on_interact() -> void:
	if debug_verbose:
		logger.log("_on_interact signalled")
	if dialogue_player:
		dialogue_player.play_dialogue()
