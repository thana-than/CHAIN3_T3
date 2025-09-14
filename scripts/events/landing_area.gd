extends Node3D

@export var disable_until_active : Node3D

signal on_activate

func _ready():
	remove_child(disable_until_active)

func activate():
	if not disable_until_active.is_inside_tree():
		add_child(disable_until_active)
	on_activate.emit()
