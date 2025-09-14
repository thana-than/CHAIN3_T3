class_name AudioEmitter
extends Node3D

@export var audio_event_resource: AudioEventResource
@export var stop_mode: AUDIO_STOP_MODE = AUDIO_STOP_MODE.STOP_IMMEDIATE
@export var auto_play: bool = false
@export var debug: bool = false
@export var spacial3D : bool = true
@onready var _logger := Logger.new(name)

var _event: FmodEvent

enum AUDIO_STOP_MODE { STOP_ALLOWFADEOUT = FmodServer.FMOD_STUDIO_STOP_ALLOWFADEOUT, STOP_IMMEDIATE = FmodServer.FMOD_STUDIO_STOP_IMMEDIATE, STOP_FORCE = FmodServer.FMOD_STUDIO_STOP_FORCEINT }

func _init(_audio_event_resource: AudioEventResource = audio_event_resource):
	audio_event_resource = _audio_event_resource

func _ready() -> void:
	_setup_fmod_event()

func _setup_fmod_event() -> void:
	if debug:
		_logger.log("Audio Event Resource Name: {name}".format({"name": audio_event_resource.name}))
	_event = FmodServer.create_event_instance(audio_event_resource.name)
	_event.stop(AUDIO_STOP_MODE.STOP_IMMEDIATE)
	if auto_play:
		play()

func _process(_delta: float) -> void:
	if spacial3D and _event:
		_event.set_3d_attributes(self.global_transform)

func play() -> void:
	if not _event:
		return
	if (_event.get_playback_state() == FmodEvent.FMOD_STUDIO_PLAYBACK_PLAYING):
		self.stop()
	if debug:
		_logger.log("Playing Audio: {name}".format({"name": audio_event_resource.name}))
	_event.start()

func stop() -> void:
	if not _event:
		_logger.log("Tried to call stop, but no event set")
		return
	if debug:
		_logger.log("Stopping Audio: {name}".format({"name": audio_event_resource.name}))
	_event.stop(stop_mode)
