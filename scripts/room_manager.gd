extends Node
class_name RoomManager

@export var surrounded_room_culling := 1

var active_room: Room
var rooms: Array[Room]

func _enter_tree() -> void:
	rooms = []
	var index = 0
	for child in get_children():
		if child is Room:
			rooms.append(child)
			child.room_index = index
			bind_room(child)
			index += 1

	room_culling()

func bind_room(room: Room) -> void:
	room.entered.connect(_on_room_entered.bind(room))

func _on_room_entered(room) -> void:
	if active_room == room:
		return

	active_room = room
	room_culling()

func room_culling() -> void:
	if active_room == null:
		return
	for i in range(len(rooms)):
		var distance = abs(i - active_room.room_index)
		if distance <= surrounded_room_culling:
			if !rooms[i].is_inside_tree():
				add_child(rooms[i])
		else:
			if rooms[i].is_inside_tree():
				remove_child(rooms[i])
