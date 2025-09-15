extends Panel
class_name Menu

signal on_open
signal on_close

@export var focus_on_open := Control

func _open():
	get_tree().paused = true
	if focus_on_open:
		focus_on_open.grab_focus.call_deferred()
	on_open.emit()

func _close():
	get_tree().paused = false
	on_close.emit()
	queue_free()

## Quit the game by exiting through the door we initially entered through
func command_call_application_quit():
	Chain3Adapter.exit_via_door(Chain3Adapter.get_entry_door_id())
