extends Node3D

@export var footstep_event: AudioEventResource = preload("res://assets/resources/audio_events/SFX_Player_Footsteps.tres")

@onready var _logger := Logger.new(name)

var _event: FmodEvent
var controller: Player

func _ready() -> void:
	_setup_fmod_event()
	controller = get_parent() as Player
	if controller:
		controller.stepped.connect(_on_stepped)

func _setup_fmod_event() -> void:
	_event = FmodServer.create_event_instance(footstep_event.name)
	_event.set_3d_attributes(self.global_transform)
	_event.stop(FmodServer.FMOD_STUDIO_STOP_IMMEDIATE)

func _on_stepped() -> void:
	if not _event:
		return
	if (_event.get_playback_state() == FmodEvent.FMOD_STUDIO_PLAYBACK_PLAYING):
		_event.stop(FmodServer.FMOD_STUDIO_STOP_IMMEDIATE)
	_event.start()
