extends FPSController3D
class_name Player

## Example script that extends [CharacterController3D] through 
## [FPSController3D].
## 
## This is just an example, and should be used as a basis for creating your 
## own version using the controller's [b]move()[/b] function.
## 
## This player contains the inputs that will be used in the function 
## [b]move()[/b] in [b]_physics_process()[/b].
## The input process only happens when mouse is in capture mode.
## This script also adds submerged and emerged signals to change the 
## [Environment] when we are in the water.

@export var input_back_action_name := "move_backward"
@export var input_forward_action_name := "move_forward"
@export var input_left_action_name := "move_left"
@export var input_right_action_name := "move_right"
@export var input_look_down_action_name := "look_down"
@export var input_look_up_action_name := "look_up"
@export var input_look_left_action_name := "look_left"
@export var input_look_right_action_name := "look_right"
@export var input_sprint_action_name := "move_sprint"
@export var input_jump_action_name := "move_jump"
@export var input_crouch_action_name := "move_crouch"
@export var input_fly_mode_action_name := "move_fly_mode"

@export var underwater_env: Environment

@onready var interactor : RayCastInteractor3D = get_node("Head/RayCastInteractor")

var input_enabled := true:
	set(enabled):
		input_enabled = enabled
		_set_look_enabled_effects(look_enabled)
		_set_move_enabled_effects(move_enabled)
		_set_interact_enabled_effects(interact_enabled)
	get:
		return input_enabled

var look_enabled := true:
	set(enabled):
		look_enabled = enabled
		_set_look_enabled_effects(look_enabled)
	get:
		return input_enabled and look_enabled

var move_enabled := true:
	set(enabled):
		move_enabled = enabled
		_set_move_enabled_effects(move_enabled)
	get:
		return input_enabled and move_enabled

var interact_enabled := true:
	set(enabled):
		interact_enabled = enabled
		_set_interact_enabled_effects(interact_enabled)
	get:
		return input_enabled and interact_enabled

func set_input_enabled(enabled := true):
	input_enabled = enabled

func set_move_enabled(enabled := true):
	move_enabled = enabled
	
func set_look_enabled(enabled := true):
	look_enabled = enabled

func set_interact_enabled(enabled := true):
	interact_enabled = enabled

func _set_look_enabled_effects(_mouse_look_enabled):
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if _mouse_look_enabled else Input.MOUSE_MODE_VISIBLE)

func _set_move_enabled_effects(_move_enabled):
	pass

func _set_interact_enabled_effects(_interact_enabled):
	interactor.enabled = _interact_enabled
func _ready():
	_set_look_enabled_effects(look_enabled)
	_set_move_enabled_effects(move_enabled)
	_set_interact_enabled_effects(interact_enabled)
	setup()
	#emerged.connect(_on_controller_emerged.bind())
	#submerged.connect(_on_controller_subemerged.bind())

func _notification(notification):
	match notification:
		NOTIFICATION_APPLICATION_FOCUS_IN:
			_set_look_enabled_effects(look_enabled)
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			_set_look_enabled_effects(false)
			

func _physics_process(delta):
	var is_valid_input := move_enabled
	
	if move_enabled:
		if OS.is_debug_build() and Input.is_action_just_pressed(input_fly_mode_action_name):
			fly_ability.set_active(not fly_ability.is_actived())
		var input_axis = Input.get_vector(input_left_action_name, input_right_action_name, input_back_action_name, input_forward_action_name)
		var input_jump = Input.is_action_pressed(input_jump_action_name)
		var input_crouch = Input.is_action_pressed(input_crouch_action_name)
		var input_sprint = Input.is_action_pressed(input_sprint_action_name)
		var input_swim_down = Input.is_action_pressed(input_crouch_action_name)
		var input_swim_up = Input.is_action_pressed(input_jump_action_name)
		move(delta, input_axis, input_jump, input_crouch, input_sprint, input_swim_down, input_swim_up)
	else:
		# NOTE: It is important to always call move() even if we have no inputs 
		## to process, as we still need to calculate gravity and collisions.
		move(delta)

func _process(delta):
	if not look_enabled:
		return
	var look_motion = delta * Input.get_vector(input_look_left_action_name, input_look_right_action_name, input_look_up_action_name, input_look_down_action_name)
	if look_motion != Vector2.ZERO:
		rotate_head_joystick(look_motion)

func _input(event: InputEvent) -> void:
	if not look_enabled:
		return
	# Mouse look (only if the mouse is captured).
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_head_mouse(event.screen_relative)


#func _on_controller_emerged():
	#camera.environment = null
#
#
#func _on_controller_subemerged():
	#camera.environment = underwater_env
