extends Node3D

signal on_activate

@export var scene_no_disc : PackedScene
@export var scene_has_disc : PackedScene
@export var disc_flag := "S2_GameCollected"

var loaded_scene : Node3D

func _ready():
	if Chain3Adapter.is_flag_set(disc_flag):
		loaded_scene = scene_has_disc.instantiate()
	else:
		loaded_scene = scene_no_disc.instantiate()
	
	add_child(loaded_scene)
		

func activate():
	on_activate.emit()
	loaded_scene.activate()
