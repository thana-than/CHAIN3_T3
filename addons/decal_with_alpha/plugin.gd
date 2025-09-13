@tool
extends EditorPlugin

var _insp

func _enter_tree() -> void:
	_insp = preload("res://addons/decal_with_alpha/inspector.gd").new()
	add_inspector_plugin(_insp)

func _exit_tree() -> void:
	if _insp:
		remove_inspector_plugin(_insp)
	_insp = null
