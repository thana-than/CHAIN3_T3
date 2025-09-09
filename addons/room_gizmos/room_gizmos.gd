@tool
extends EditorPlugin

#region Fields
var eds : EditorSelection
var selected_rooms : Array[Room] = []
#endregion

#region Gizmos Function 
func draw_room_gizmos(room : Room):
	var cull_root = room.get_node("cull_root")
	
	# Draw cull_distance
	DebugDraw3D.draw_sphere(cull_root.global_position, room.cull_distance, Color.LIGHT_GRAY)
#endregion

#region Plugin Methods
func _enter_tree():
	eds = get_editor_interface().get_selection()
	eds.selection_changed.connect(_on_selection_changed)
	
func _exit_tree():
	if eds:
		eds.selection_changed.disconnect(_on_selection_changed)

func _on_selection_changed():
	selected_rooms.clear()
	var sel = eds.get_selected_nodes()
	for node in sel:
		if node as Room:
			selected_rooms.append(node)
	
func _process(_delta):
	if not Engine.is_editor_hint():
		return
	for room in selected_rooms:
		draw_room_gizmos(room)
#region
