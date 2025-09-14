extends AudioEmitter
class_name DialogueAudio

var _audio_preload : AudioEventResource = preload("res://assets/resources/audio_events/SFX_Dialogue.tres")

var dialogue_settings : DialogueSettings
var dialogue_player : DialoguePlayer
var dialogue_audio : AudioEventResource

var stop_timer : Timer

func _init(_dialogue_settings, _dialogue_player, _dialogue_audio = _audio_preload):
	dialogue_settings = _dialogue_settings
	dialogue_player = _dialogue_player
	dialogue_audio = _dialogue_audio
	
func _ready() -> void:
	if not audio_event_resource:
		audio_event_resource = dialogue_audio
		
	stop_timer = Timer.new()
	stop_timer.wait_time = dialogue_settings.audio_stop_delay
	stop_timer.one_shot = true
	add_child(stop_timer)
	
	dialogue_player.on_line_start.connect(try_start_audio)
	dialogue_player.on_line_end.connect(stop_timer.start)
	stop_timer.timeout.connect(stop)
	super._ready()

func try_start_audio():
	if (dialogue_player.current_balloon.dialogueLine.Character == dialogue_settings.audio_ignore_player_name):
		return
	stop_timer.stop()
	play()
