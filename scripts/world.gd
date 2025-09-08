extends Node

@onready var player: Player = get_node(NodePath("Player"))
@onready var room_manager : = get_node(NodePath("Train"))

var logger := Logger.new("world")

#TODO config option to set / change chain flags?
var debug_config : DebugConfig
var debug_config_path := "res://local/debug-config.tres"
var debug_room_spawn_path := "door_enter"

func _ready() -> void:
	if OS.is_debug_build():
		load_debug_config()
		if debug_config:
			try_move_player_to_room_id(debug_config.spawn_room_id)

func load_debug_config():
	if ResourceLoader.exists(debug_config_path):
		debug_config = load(debug_config_path)
		
func try_move_player_to_room_id(room_id: String):
	for room in room_manager.rooms:
		if room.name == room_id:
			var room_transform = room.get_node(NodePath(debug_room_spawn_path)) as Node3D
			if room_transform:
				room.enter()
				player.global_position = room_transform.global_position + Vector3.UP
				#TODO rotation mapping
				#player.global_rotation = -room_transform.global_rotation
				player.translate(Vector3.FORWARD)
				logger.log("Moved player to room " + room_id)
			else:
				logger.err("Failed to move player to room " + room_id + ". Room requires Node3D named: " + debug_room_spawn_path)
			return
	if room_id != "":
		logger.err("Failed to move player to room " + room_id + ". Room does not exist.")
