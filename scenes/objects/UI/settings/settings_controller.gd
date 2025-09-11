extends Node
class_name SettingsController

@export var parameter := ""
var logger := Logger.new(name)
var value_key : String
	
func _ready():
	update_value_key()
	update_value()
	attach_signals()

func update_value_key():
	if "value" in self:
		value_key = "value"
	elif "button_pressed" in self:
		value_key = "button_pressed"
		
func update_value():
	if value_key:
		self[value_key] = get_value()
	
func attach_signals():
	if not value_key:
		return
	
	if "value_changed" in self:
		self["value_changed"].connect(set_value)
	elif "toggled" in self:
		self["toggled"].connect(set_value)
	elif "text_submitted" in self:
		self["text_submitted"].connect(set_value)
	elif "pressed" in self:
		self["pressed"].connect(set_value)
	
func get_value() -> Variant:
	if parameter in Settings:
		return Settings[parameter]
	elif parameter != "":
		logger.err(str("Parameter name ", parameter, " does not exist in Settings class.") )
	
	return null

func set_value(value: Variant = self[value_key]):
	if parameter in Settings:
		Settings[parameter] = value
	elif parameter != "":
		logger.err(str("Parameter name ", parameter, " does not exist in Settings class.") )
	
	return null
