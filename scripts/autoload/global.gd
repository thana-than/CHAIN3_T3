extends Node

@warning_ignore_start("UNUSED_SIGNAL")

signal send_player_to_room(room_name : String)

@warning_ignore_restore("UNUSED_SIGNAL")

var player : Player

var debug_config := DebugConfig.new()
var debug_config_path := "res://local/debug-config.tres"

func _ready():
	load_debug_config()

func load_debug_config():
	if ResourceLoader.exists(debug_config_path):
		debug_config = load(debug_config_path)
