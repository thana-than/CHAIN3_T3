extends Node

var save_in_debug_build = false

var _logger := Logger.new("Config Reader")
var _config := ConfigFile.new()
var _file_name := "t3.cfg"

func _enter_tree():
	load_config()
	
func get_value(section: String, key: String, default: Variant = null):
	return _config.get_value(section, key, default)

func set_value(section: String, key: String, value: Variant = null):
	_logger.log(str('Set Value: [',section,'] ',key, ': ', value))
	_config.set_value(section, key, value)
	
func load_config():
	if OS.is_debug_build():
		var dev_path = "local/" + _file_name;
		var _debug_cfg_result = _config.load("local/" + _file_name)
		if _debug_cfg_result == OK:
			_logger.log("Loaded config from path: " + dev_path)
			return
	var _cfg_result = _config.load(_file_name)
	if _cfg_result == OK:
		_logger.log("Loaded config from path: " + _file_name)
	else:
		_logger.log("No config found.")
	
func save_config():
	if not save_in_debug_build and OS.is_debug_build():
		return
		
	_logger.log("Config saved to path: " + _file_name)
	_config.save(_file_name)
