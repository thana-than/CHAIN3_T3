extends Node
#TODO audio section with FMOD
#TODO control section for mouse sensitivity

#region Fields
var _section_display = "Display"
var _section_audio = "Audio"
var _section_controls = "Controls"

var _setting_prop_prefix = "setting_"

var logger := Logger.new("Settings")
#endregion

#region Properties

## option_ prefixed parameters is set on _ready() as they indicate a shortcut to another setting
var option_fullscreen: bool:
	set(fullscreen):
		setting_window_mode = DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN if fullscreen else DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN
	get:
		return setting_window_mode == DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN || setting_window_mode == DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN

var setting_window_mode: DisplayServer.WindowMode:
	set(window_mode):
		Config.set_value(_section_display, "window_mode", window_mode)
		DisplayServer.window_set_mode(window_mode)
	get:
		return Config.get_value(_section_display, "window_mode", DisplayServer.window_get_mode())
		
var setting_window_size: Vector2i:
	set(window_size):
		Config.set_value(_section_display, "window_size", window_size)
		DisplayServer.window_set_size(window_size)
	get:
		return Config.get_value(_section_display, "window_size", DisplayServer.window_get_size())

var setting_screen_index: int:
	set(screen_index):
		Config.set_value(_section_display, "screen_index", screen_index)
		center_window()
	get:
		return Config.get_value(_section_display, "screen_index", DisplayServer.get_primary_screen())
		
var setting_joystick_sensitivity : float:
	set(sensitivity):
		Config.set_value(_section_controls, "joystick_sensitivity", sensitivity)
	get:
		return Config.get_value(_section_controls, "joystick_sensitivity", 1.0)
		
var setting_mouse_sensitivity : float:
	set(sensitivity):
		Config.set_value(_section_controls, "mouse_sensitivity", sensitivity)
	get:
		return Config.get_value(_section_controls, "mouse_sensitivity", 2.0)
		
var setting_master_volume : float:
	set(volume):
		Config.set_value(_section_audio, "volume_master", volume)
		set_volume("Master Volume", volume)
	get:
		return Config.get_value(_section_audio, "volume_master", 1.0)
		
var setting_music_volume : float:
	set(volume):
		Config.set_value(_section_audio, "volume_music", volume)
		set_volume("Music Volume", volume)
	get:
		return Config.get_value(_section_audio, "volume_music", 0.7)

var setting_sfx_volume : float:
	set(volume):
		Config.set_value(_section_audio, "volume_sfx", volume)
		set_volume("SFX Volume", volume)
	get:
		return Config.get_value(_section_audio, "volume_sfx", 0.7)
#endregion

#region Methods
func _enter_tree():
	reload()
	
func set_volume(_name : String, _value: float):
	while not FmodManager.is_ready:
		await get_tree().process_frame
	var path = "vca:/" + _name
	var vca = FmodServer.get_vca(path)
	if not vca:
		logger.err("Could not find FMOD VCA at path: " + path)
		return
	vca.volume = _value
	
func center_window():
	var screen = setting_screen_index
	var screen_pos = DisplayServer.screen_get_position(screen)
	var screen_size = DisplayServer.screen_get_size(screen)
	var window_size = DisplayServer.window_get_size()
	var centered = screen_pos + (screen_size - window_size) / 2
	DisplayServer.window_set_current_screen(screen)
	DisplayServer.window_set_position(centered)
	
func reload():
	# Trigger all the settters for every property with the setting prefix
	for prop in get_property_list():
		if prop.name.begins_with(_setting_prop_prefix):
			self.set(prop.name, self.get(prop.name))

func save():
	Config.save_config()
#endregion
