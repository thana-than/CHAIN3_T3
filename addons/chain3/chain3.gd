@tool
extends EditorPlugin

var streaming_assets_plugin = preload("res://addons/chain3/CHAIN_StreamingAssetsExport.gd").new()
func _enter_tree() -> void:
	add_autoload_singleton("chain3", "res://addons/chain3/autoload.gd")
	add_export_plugin(streaming_assets_plugin)

func _exit_tree() -> void:
	remove_autoload_singleton("chain3")
	remove_export_plugin(streaming_assets_plugin)
