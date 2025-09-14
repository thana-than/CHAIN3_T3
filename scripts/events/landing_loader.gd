extends Node3D

signal on_activate

@export var scene_no_disc : PackedScene
@export var scene_has_disc : PackedScene
@export var disc_flag := "S2_GameCollected"

@export var activate_immediate_doors := ["T4", "U1"]

var loaded_scene : Node3D

func _ready():
	if Chain3Adapter.is_flag_set(disc_flag):
		loaded_scene = scene_has_disc.instantiate()
	else:
		loaded_scene = scene_no_disc.instantiate()
	
	add_child(loaded_scene)
	
	var can_activate_immediately = activate_immediate_doors.has(Chain3Adapter.get_entry_door_id().to_upper())
	if OS.is_debug_build() and Global.debug_config.spawn_room_id != "":
		can_activate_immediately = true

	if can_activate_immediately:
		activate.call_deferred()
		

func activate():
	on_activate.emit()
	loaded_scene.activate()
