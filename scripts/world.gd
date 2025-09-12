extends Node

@export var default_start_node_id := "S2"

var logger := Logger.new("world")

#TODO config option to set / change chain flags?
var local_path := "res://local/"
var debug_config_path := local_path + "debug-config.tres"
var debug_room_spawn_path := "door_enter"
var dev_room_name := "_dev_room"
var rooms_path := "res://scenes/rooms/"
var dev_room_path := local_path + dev_room_name + ".tscn"

var room_name = "Rooms"

@onready var player: Player = get_node(NodePath("Player"))
@onready var room_manager : = get_node(NodePath(room_name))

func format_entry_node_room(id : String):
	id = id.to_upper()
	if id == "START":
		id = default_start_node_id.to_upper()
	return "room_{id}".format({"id": id})
	
func _enter_tree() -> void:
	_try_spawn_dev_room()

func _ready() -> void:
	var load_from_chain = true
	if OS.is_debug_build():
		var _room_id = Global.debug_config.spawn_room_id
		if Global.debug_config.spawn_in_dev_room:
			_room_id = dev_room_name
		if try_move_player_to_room_id(_room_id):
			load_from_chain = false
	if load_from_chain:
		var id = Chain3Adapter._entry_door_id
		if id == "START":
			id = default_start_node_id.to_upper()
		try_move_player_to_room_id(format_entry_node_room(id))
	
	Global.send_player_to_room.connect(try_move_player_to_room_id)

func _try_spawn_dev_room():
	if not OS.is_debug_build():
		return
		
	var _path = local_path + dev_room_name + ".tscn"
	if not ResourceLoader.exists(_path):
		_path = rooms_path + dev_room_name + ".tscn"
	if not ResourceLoader.exists(_path):
		logger.err("Dev room failed to load at path: " + _path)
		return
		
	var _room_manager = get_node(NodePath(room_name))
	var _dev_room = load(_path).instantiate()
	_room_manager.add_child(_dev_room)
	logger.log("Spawned dev room from path " + _path)
		
func try_move_player_to_room_id(room_id: String):
	var success = false
	for room in room_manager.rooms:
		if room.name == room_id:
			var room_transform = room.get_node(debug_room_spawn_path) as Node3D
			if room_transform:
				room.enter()
				player.global_position = room_transform.global_position + Vector3.UP
				player.set_global_rotation_y(room_transform.global_rotation.y)
				player.reset_head_rotation()
				player.velocity = Vector3.ZERO
				logger.log("Moved player to room " + room_id)
				success = true
			else:
				logger.err("Failed to move player to room " + room_id + ". Room requires Node3D named: " + debug_room_spawn_path)
			return success
	if room_id != "":
		logger.err("Failed to move player to room " + room_id + ". Room does not exist.")
	return success
