extends Node
class_name DialoguePlayer

signal on_play_dialogue()

@export var settings := DialogueSettings.new()
@export var player_settings := DialoguePlayerSettings.new()
var timer := Timer.new()
var _shown: bool = false
var current_balloon
var dialogue_state := {
	"interaction_index": 0
}

func _init(dialogue_settings := settings, dialogue_player_settings := player_settings):
	settings = dialogue_settings
	player_settings = dialogue_player_settings
	
func _ready():
	add_child(timer)
	timer.one_shot = false
	timer.timeout.connect(cycle_next)

func play_dialogue() -> void:
	if current_balloon:
		if current_balloon.dialogueLabel.is_typing:
			current_balloon.dialogueLabel.skip_typing()
		else:
			cycle_next()
		return
		
	if not player_settings.is_repeatable:
		if _shown:
			return
		_shown = true
	
	current_balloon = DialogueManager.show_dialogue(settings, [dialogue_state.duplicate(true)]);
	current_balloon.OnNext.connect(func(_line): restart_timer())
	restart_timer()
	on_play_dialogue.emit()
	dialogue_state.interaction_index += 1

func restart_timer():
	if player_settings.next_after_seconds > 0:
		timer.start(player_settings.next_after_seconds)

func cycle_next():
	if not current_balloon:
		return
	current_balloon.Next()
