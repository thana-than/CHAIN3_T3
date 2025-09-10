extends Node3D

@export var room : Room

signal on_activate

func activate():
	on_activate.emit()
