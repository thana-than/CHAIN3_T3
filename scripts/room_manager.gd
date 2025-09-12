extends Node
class_name RoomManager

var active_room: Room
var rooms: Array[Room]

var last_cull_position : Vector3
@export var cull_distance_delta := 5.0 

func _enter_tree() -> void:
	rooms = []
	var index = 0
	for child in get_children():
		if child is Room:
			rooms.append(child)
			child.room_index = index
			bind_room(child)
			index += 1
	
func _process(_delta):
	var pos = _get_cull_position()
	if pos.distance_squared_to(last_cull_position) > cull_distance_delta * cull_distance_delta:
		room_culling(pos)

func bind_room(room: Room) -> void:
	room.entered.connect(_on_room_entered.bind(room))

func _on_room_entered(room) -> void:
	if active_room == room:
		return
	active_room = room
	room_culling()
	
func _get_cull_position():
	return get_viewport().get_camera_3d().global_position
	
func activate_room(room: Room, activate: bool = true):
	if room.is_inside_tree() == activate:
		return
	if activate:
		add_child(room)
	else:
		remove_child(room)

func room_culling(position : Vector3 = _get_cull_position()) -> void:
	for room in rooms:
		var distance = room.cull_position.distance_squared_to(position)
		var within_distance = distance <= room.cull_distance * room.cull_distance
		activate_room(room, within_distance or room == active_room)
	last_cull_position = position
