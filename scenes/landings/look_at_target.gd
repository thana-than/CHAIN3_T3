extends Node3D

@export var target : Node3D

func _process(_delta):
	look_at(target.global_position, Vector3.FORWARD)
