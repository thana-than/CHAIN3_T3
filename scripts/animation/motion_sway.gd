# This class gives the ability to manipulate the camera in a swaying manner to give the illusion of being ill
# or dissociated.
extends Node3D

@export var amplitude : float = 0.001 # meters
@export var frequency : float = 0.75  # in hz
@export var roll_amount : float = 5e-3 # degrees
var _enabled: bool = false
@export var enabled: bool = _enabled:
	set(value):
		_set_enable_disable(value)
	get:
		return _enabled

var _current_total_transform: float = 0.0
var t: float = 0.0

@onready var _player: Player = get_owner() as Player
#@onready var _logger := Logger.new(name)

func set_enable_disable(value: bool):
	enabled = value

func _set_enable_disable(value: bool):
	_player.reset_head_rotation()
	_player.head.translate(Vector3(0., 0., -_current_total_transform))
	_enabled = value
	

func _process(delta: float) -> void:
	if not _enabled:
		return
	if not _player:
		return
	t += delta * frequency * TAU
	var sway = sin(t) * amplitude
	_current_total_transform += sway
	_player.head.translate(Vector3(0., 0., sway))
	_player.head.rotate_z(deg_to_rad(sin(t) * roll_amount))
