extends CollisionObject3D
class_name Door

enum AnimType { SLIDE, HINGE }

signal on_open
signal on_close
signal on_locked
signal on_unlocked
signal on_locked_attempt

## Remains open for specified amount of seconds. Will remain open indefinitely if set to 0.0.
@export_range(0.0, 60.0) var remain_open_time := 0.0
@export var door_mesh_node : Node3D
@export var reparent_mesh := true

@export_group("Default State")
@export var start_open := false
@export var start_locked := false

@export_group("Animation")
@export var anim_type := AnimType.SLIDE
@export var anim_open_time := .5
@export var anim_close_time := .5
@export var anim_hinge_rotation := HingeRotation.EITHER
@export var animation : AnimationPlayer

enum HingeRotation {EITHER, FRONT, BACK}

var _locked = false
var _last_interaction_facing_front = true

@onready var collider : CollisionShape3D = get_node("CollisionShape3D")
@onready var timer : Timer = get_node("Timer")
@onready var root_transform : Node3D = get_node("root_transform")
@onready var mesh_parent : Node3D = root_transform.get_node("hinge/pivot") 
@onready var logger = Logger.new("door.gd: " + name)

func _ready():
	if not animation:
		animation = get_node("AnimationPlayer")
		
	if start_locked:
		lock()
	else:
		unlock()
		
	if start_open:
		open(true)
	else:
		close()
	
	if not timer.timeout.is_connected(close):
		timer.timeout.connect(close)
	
	if reparent_mesh:
		if door_mesh_node:
			door_mesh_node.reparent(mesh_parent, false)
		else:
			logger.err("Missing door_mesh_node!")

func _get_anim_name(_anim_type: AnimType):
	return "anim_door_" + AnimType.keys()[_anim_type].to_lower()

func _on_interaction(facing_front : bool):
	_last_interaction_facing_front = facing_front
	toggle_open()
	pass

func is_open() -> bool:
	return collider.disabled

func is_locked() -> bool:
	return _locked

func lock():
	if is_locked():
		return
	if is_open():
		close()
	on_locked.emit()
	_locked = true

func unlock():
	if not is_locked():
		return
	on_unlocked.emit()
	_locked = false
	
func toggle_open():
	print(str(!is_open()))
	if is_open():
		close()
	else:
		open()

func open(force := false):
	if is_open():
		return
	if not force and is_locked():
		on_locked_attempt.emit()
		return
	
	# rotate the door so that it so the animation plays *away* from the player
	if anim_type == AnimType.HINGE:
		var hinge_forward = !_last_interaction_facing_front
		if anim_hinge_rotation != HingeRotation.EITHER:
			hinge_forward = anim_hinge_rotation == HingeRotation.FRONT
		
		var flip = 1.0 if hinge_forward else -1.0
		root_transform.scale = Vector3(1.0,1.0,flip)
	
	var speed = 1.0 / anim_open_time if anim_open_time > 0 else 1000.0
	animation.play(_get_anim_name(anim_type), -1, speed)
	collider.disabled = true
	on_open.emit()
	if remain_open_time > 0.0:
		timer.start(remain_open_time)

func close():
	if not is_open():
		return
		
	var speed = 1.0 / anim_close_time if anim_close_time > 0 else 1000.0
	animation.play(_get_anim_name(anim_type), -1, -speed, true)
	collider.set_deferred("disabled", false)
	on_close.emit()
	timer.stop()
