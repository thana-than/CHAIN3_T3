extends Node3D
class_name HeadLookAtController

@export var skeleton: Skeleton3D
@export var head_bone_name: String = "mixamorig1_Head"
@export var interactable: DialogueInteractable
@export var influence: float = 0.8
@export var forward_axis: SkeletonModifier3D.BoneAxis = SkeletonModifier3D.BoneAxis.BONE_AXIS_PLUS_Z

@export_group("Look At Parameters")
@export var turn_duration: float = 0.15 # seconds to ease toward target
@export var transition_type: Tween.TransitionType = Tween.TRANS_SINE
@export var ease_type: Tween.EaseType = Tween.EASE_OUT
@export var follow_seconds: float = 3.0

var _look_mod : LookAtModifier3D
var _timer: Timer
var _player: Player
var _target: Node3D

func _ready() -> void:
	_player = Global.player as Player
	if not _player:
		push_warning("No Player found in Global.player")
	if not skeleton:
		push_warning("Skeleton3D not set in {}".format(self.name))
		return
	if not interactable:
		push_warning("No DialogueInteractable set in {}".format(self.name))
		return
	
	# Add look at modifier 3d
	_look_mod = LookAtModifier3D.new()
	skeleton.add_child(_look_mod)
	_look_mod.bone_name = head_bone_name
	_look_mod.forward_axis = forward_axis
	_look_mod.active = false
	
	# timer for follow_seconds > 0.0
	_timer = Timer.new()
	_timer.one_shot = true
	_timer.name = "HeadLookTimer"
	add_child(_timer)
	_timer.timeout.connect(clear_look)
	
	# connect interactable signal to _on_interact
	interactable.interacted.connect(_on_interacted)

#region public api

func set_target_look_at(target: Node3D) -> void:
	if not _look_mod:
		return
	if not target:
		return
	
	_target = target
	_look_mod.target_node = _target.get_path()
	_look_mod.influence = influence
	_look_mod.active = true
	
	
	if follow_seconds > 0.0:
		_start_timer(follow_seconds)
	return

func clear_look() -> void:
	if not _look_mod:
		return
	
	_look_mod.active = false
	_timer.stop()

#endregion

func _on_interacted() -> void:
	if not _player:
		return
	var head_node := _player.head as Node3D
	if head_node:
		set_target_look_at(head_node)

func _start_timer(seconds: float) -> void:
	_timer.stop()
	_timer.wait_time = seconds
	_timer.start()
