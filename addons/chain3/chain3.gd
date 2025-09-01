@tool
extends EditorPlugin

func _enter_tree() -> void:
	add_autoload_singleton("chain3", "res://addons/chain3/autoload.gd")

func _exit_tree() -> void:
	remove_autoload_singleton("chain3")
