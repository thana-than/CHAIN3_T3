@tool

extends Node3D

@export var spacing := Vector3(0.0,0.0,1.0):
	set(_spacing):
		spacing = _spacing
		_update_spacing()
	get:
		return spacing
		
@export var anchor := Vector3(0.5,0.5,0.5):
	set(_anchor):
		anchor = _anchor
		_update_spacing()
	get:
		return anchor
		
func _ready():
	child_order_changed.connect(_update_spacing)

func _update_spacing():
	var child_count = get_child_count()
	var max_dist = spacing * (child_count - 1.0)
	for i in child_count:
		var child = get_child(i) as Node3D
		if not child:
			continue
	
		child.position = spacing * i - max_dist * anchor
