extends CanvasLayer

signal on_menu_open
signal on_menu_close

var _pause_menu := preload("res://scenes/objects/UI/pause_menu.tscn")
var instanced_menu : Menu

var _last_mouse_mode := Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event.is_action_pressed("ui_pause"):
		toggle_pause()

func toggle_pause():
	if instanced_menu:
		instanced_menu._close()
	else:
		open_menu(_pause_menu)
		
func _menu_close_event():
	on_menu_close.emit()
	Input.set_mouse_mode(_last_mouse_mode)

func open_menu(_menu : PackedScene):
	if instanced_menu:
		instanced_menu._close()
		
	instanced_menu = _menu.instantiate()
	add_child(instanced_menu)
	instanced_menu._open()
	
	_last_mouse_mode = Input.mouse_mode
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	on_menu_open.emit()
	instanced_menu.on_close.connect(_menu_close_event)
