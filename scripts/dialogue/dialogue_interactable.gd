extends Interactable3D
class_name DialogueInteractable

signal on_dialogue_start(title: String)

@export var dialogue_settings: DialogueSettings = DialogueSettings.new()
@export var restrict_player_input := true
@export var debug_verbose: bool = false

@onready var logger := Logger.new(name)

func _ready() -> void:
	interacted.connect(_on_interact)
	if debug_verbose:
		logger.log("_on_body_entered has been connected to the body_entered signal.")

func _on_interact() -> void:
	if debug_verbose:
		logger.log("_on_interact signalled")
	
	on_dialogue_start.emit(dialogue_settings.dialogue_start)
	DialogueManager.show_dialogue(dialogue_settings);
