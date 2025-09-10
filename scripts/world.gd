extends Node

@onready var player: Player = get_node(NodePath("Player"))
@onready var room_manager : = get_node(NodePath("Rooms"))
@export var default_start_node_id := "S2"

var logger := Logger.new("world")

#TODO config option to set / change chain flags?
var debug_config : DebugConfig
var debug_config_path := "res://local/debug-config.tres"
var debug_room_spawn_path := "door_enter"

func format_entry_node_room(id : String):
	id = id.to_upper()
	if id == "START":
		id = default_start_node_id.to_upper()
	return "room_{id}".format({"id": id})

func _ready() -> void:
	var load_from_chain = true
	if OS.is_debug_build():
		load_debug_config()
		if debug_config:
			if try_move_player_to_room_id(debug_config.spawn_room_id):
				load_from_chain = false
	if load_from_chain:
		var id = Chain3Adapter._entry_door_id
		if id == "START":
			id = default_start_node_id.to_upper()
		try_move_player_to_room_id(format_entry_node_room(id))
	
	Global.send_player_to_room.connect(try_move_player_to_room_id)

func load_debug_config():
	if ResourceLoader.exists(debug_config_path):
		debug_config = load(debug_config_path)
		
func try_move_player_to_room_id(room_id: String):
	var success = false
	for room in room_manager.rooms:
		if room.name == room_id:
			var room_transform = room.get_node(NodePath(debug_room_spawn_path)) as Node3D
			if room_transform:
				room.enter()
				player.global_position = room_transform.global_position + Vector3.UP
				player.set_global_rotation_y(room_transform.global_rotation.y)
				logger.log("Moved player to room " + room_id)
				success = true
			else:
				logger.err("Failed to move player to room " + room_id + ". Room requires Node3D named: " + debug_room_spawn_path)
			return success
	if room_id != "":
		logger.err("Failed to move player to room " + room_id + ". Room does not exist.")
	return success
