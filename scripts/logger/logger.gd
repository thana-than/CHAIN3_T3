# A simple logging class that enables a better logging experience for better debugging/filtering
# Can be instantiated like so: `logger: Logger = new Logger('subsystem')`
class_name Logger extends Node

var _system: String

## When initializing this class make certain to initialize with a system tag.
func _init(system: String) -> void:
	_system = system

## Helper class for fetching prefix based on subsystem and current time.
func _get_prefix() -> String:
	var date_time := Time.get_datetime_dict_from_system()
	var prefix := "[%02d:%02d:%02d] [%s]" % [ date_time.hour, date_time.minute, date_time.second, _system ]
	return prefix

## Log a message - should be used for information.
func log(message: String) -> void:
	var prefix := _get_prefix()
	print("%s - %s" % [prefix, message])

## Log error messages using printerr
func err(message: String) -> void:
	var prefix := _get_prefix()
	printerr("%s - %s" % [prefix, message])
