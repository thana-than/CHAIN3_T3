extends Node3D

@export var footstep_events: Array[String] = []
@export var pitch_jitter: float = 0.08

@onready var _logger := Logger.new(name)
var controller: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	controller = get_parent() as Player
	if controller:
		controller.stepped.connect(_on_stepped)

func _on_stepped() -> void:
	if footstep_events.is_empty():
		return
	
	var event_path: String = footstep_events.pick_random()
	var instance := FmodServer.create_event_instance(event_path)
	if instance == null:
		_logger.err("Could not instantiate instance from foot step event at path: {event_path}".format({"event_path": event_path}))
		return
	
	instance.set_pitch(1.0 + randf_range(-pitch_jitter, pitch_jitter))
	instance.set_3d_attributes(controller.transform)
	
	instance.start()
	instance.release()
