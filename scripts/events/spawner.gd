extends Node3D
class_name Spawner

@export var scene : PackedScene

func spawn() -> Node:
	var node = scene.instantiate()
	add_child(node)
	return node
