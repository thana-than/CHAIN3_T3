extends Node
class_name DialoguePlayer

signal on_play_dialogue()
signal on_next_dialogue()
signal on_line_start()
signal on_line_end()

@export var settings := DialogueSettings.new()
@export var player_settings := DialoguePlayerSettings.new()
var end_dialogue_timer := Timer.new()
var _shown: bool = false
var current_balloon
var dialogue_state := {
	"interaction_index": 0
}

func _init(dialogue_settings := settings, dialogue_player_settings := player_settings):
	settings = dialogue_settings
	player_settings = dialogue_player_settings
	
func _ready():
	add_child(end_dialogue_timer)
	end_dialogue_timer.one_shot = true
	end_dialogue_timer.timeout.connect(end_dialogue)

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
	end_dialogue_timer.stop()
	on_play_dialogue.emit()
	dialogue_state.interaction_index += 1
	await current_balloon.ready
	current_balloon.dialogueLabel.started_typing.connect(on_line_start.emit)
	current_balloon.dialogueLabel.finished_typing.connect(line_ended)

func restart_end_dialogue_timer():
	if player_settings.stop_after_seconds > 0:
		end_dialogue_timer.start(player_settings.stop_after_seconds)

func cycle_next():
	if not current_balloon:
		return
	current_balloon.Next()
	on_next_dialogue.emit()
	
func end_dialogue():
	if current_balloon:
		DialogueManager._clear_last_dialogue()
	
func line_ended():
	restart_end_dialogue_timer()
	on_line_end.emit()
