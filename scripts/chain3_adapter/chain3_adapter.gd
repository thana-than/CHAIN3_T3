extends Node
class_name Chain3AdapterClass

var _LOGGER: Logger = Logger.new("Chain3Adapter")

# Signals
signal flags_changed(new_flags: Array) # emits a signal when flags are changed
signal exit_requested(door_id: String) # emits a signal when someone has requested exiting through a particular door

var GAME_PREFIX := "T3"

func create_flag_local(name:String) -> void:
	pass
	
func has_flag_local(name: String) -> void:
	pass
