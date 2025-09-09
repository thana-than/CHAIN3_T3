@tool
extends Node

var performance_display: PerformancesDisplay
var wait_frames := 1

func _ready():
	process_mode = PROCESS_MODE_ALWAYS
	performance_display = PerformancesDisplay.new()
	add_child(performance_display)

func _exit_tree() -> void:
	remove_child(performance_display)
	performance_display.free()

func _process(delta):
	if wait_frames > 0:
		wait_frames -= 1
		return
	
	FmodServer.update()
	
func _notification(what):
	FmodServer.notification(what)
