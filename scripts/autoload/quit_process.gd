extends Node

var _logger := Logger.new("Quit Process")

func _enter_tree():
	get_tree().set_auto_accept_quit(false)

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		_logger.log("Application quit requested.")
		Config.save_config()
		
		get_tree().quit()
