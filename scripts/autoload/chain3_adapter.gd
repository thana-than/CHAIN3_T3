extends Node
class_name Chain3AdapterClass

var _LOGGER: Logger = Logger.new("Chain3Adapter")

# Signals
enum FlagChangeType { CREATED, DELETED }
signal flags_changed(new_flags: Array, change_type: FlagChangeType) # emits a signal when flags are changed
signal exit_requested(door_id: String) # emits a signal when someone has requested exiting through a particular door

var GAME_PREFIX := "T3"
var _chain3: Node

var _internal_flags = {}

var _entry_door_id: String
func _ready() -> void:
	# Based on the docs in CHAIN_SpawnPoint - chain3.door_id will be set to the 
	# proper door_id on start, but I can't actually see how they're doing this 
	# programmatically.....
	_chain3 = get_node_or_null("/root/chain3")
	_entry_door_id = _chain3.door_id
	_LOGGER.log("Entry door id: {}".format(_entry_door_id))

func qualify_local(_name: String) -> String:
	# Prefix the string
	return "{}_{}".format(GAME_PREFIX, _name)

## Raw functions - avoid calling unless to check for other flags

func set_flag(_name: String) -> void:
	_LOGGER.info("Setting flag with name {name}".format({"name": _name}))
	_chain3.create_flag(_name)
	flags_changed.emit([_name], FlagChangeType.CREATED)

func is_flag_set(_name: String) -> bool:
	var is_set: bool = _chain3.does_flag_exist(_name)
	_LOGGER.info("Checking if we have flag {} set - {}".format(_name, "T" if is_set else "F"))
	return is_set

func unset_flag(_name: String) -> void:
	_LOGGER.info("Unsetting flag with name {name}".format({"name": _name}))
	_chain3.delete_flag(_name)
	flags_changed.emit([_name], FlagChangeType.DELETED)

## Local functions - prefixes our own chain flags and prepands our code automatically

func set_local_flag(_name:String) -> void:
	set_flag(qualify_local(_name))

func is_local_flag_set(_name: String) -> bool:
	return is_flag_set(qualify_local(_name))
	
func unset_local_flag(_name: String) -> void:
	unset_flag(qualify_local(_name))


# Internal Functions - these flags are internal only and are not writing to chain at all.
# This is useful for stuff we want to keep in game only...
func set_internal_flag(_name: String) -> void:
	_LOGGER.log("Setting internal flag with name {}".format(_name))
	_internal_flags[_name] = true

func is_internal_flag_set(_name: String) -> bool:
	return _internal_flags.has(_name) and _internal_flags[_name]

func unset_internal_flag(_name: String) -> void:
	_LOGGER.log("Unsetting internal flag with name {}".format(_name))
	_internal_flags.erase(_name)

func get_flags() -> Array:
	var flags = _chain3.get_flags()
	flags.append_array(_internal_flags.keys())
	return flags

func get_local_flags() -> Array:
	var flags: Array = get_flags()
	var retFlags: Array = []
	for flag in flags:
		if flag.contains(GAME_PREFIX):
			retFlags.append(flag)
	return retFlags

func get_internal_flags() -> Array:
	return _internal_flags.keys()

# Defer the call so that any subscribers have the time to clean up/write
# to any flags they need.
func exit_via_door(door_id: String) -> void:
	_LOGGER.log("Exit requested via door with id: {}".format(door_id))
	exit_requested.emit(door_id)
	_chain3.call_deferred("exit_game", door_id)

func get_entry_door_id() -> String:
	return _entry_door_id
