extends AudioEmitter

var _footstep_audio_preload: AudioEventResource = preload("res://assets/resources/audio_events/SFX_Player_Footsteps.tres")
var controller: Player

func _ready() -> void:
	if not audio_event_resource:
		audio_event_resource = _footstep_audio_preload
	controller = get_parent() as Player
	if controller:
		controller.stepped.connect(_on_stepped)
	super._ready()

func _process(delta: float) -> void:
	super._process(delta)

func _on_stepped() -> void:
	if not _event:
		return
	self.play()
