extends Marker3D
class_name HeadMovement3D

## Node that moves the character's head
## To move just call the function [b]rotate_camera[/b]

## Mouse sensitivity of rotation move
@export var mouse_sensitivity := 2.0
@export var joystick_sentitivity := 1.0

## Vertical angle limit of rotation move
@export var vertical_angle_limit := 90.0

## Actual rotation of movement
var actual_rotation := Vector3()

func _ready() -> void:
	actual_rotation.y = get_owner().rotation.y


## Define mouse sensitivity
func set_mouse_sensitivity(sensitivity):
	mouse_sensitivity = sensitivity
	
func set_joystick_sentitivity(sensitivity):
	joystick_sentitivity = sensitivity


## Define vertical angle limit for rotation movement of head
func set_vertical_angle_limit(limit : float):
	vertical_angle_limit = deg_to_rad(limit)


## Rotates the head of the character that contains the camera used by 
## [FPSController3D].
## Vector2 is sent with reference to the input of a mouse as an example
func rotate_camera_mouse(mouse_axis : Vector2) -> void:
	rotate_camera(mouse_axis, mouse_sensitivity/1000.0)

func rotate_camera_joystick(joystick_axis : Vector2) -> void:
	rotate_camera(joystick_axis, joystick_sentitivity * 3.33)
	
func rotate_camera(_axis : Vector2, _sensitivity : float) -> void:
		# Horizontal mouse look.
	actual_rotation.y -= _axis.x * _sensitivity
	# Vertical mouse look.
	actual_rotation.x = clamp(actual_rotation.x - _axis.y * _sensitivity, -vertical_angle_limit, vertical_angle_limit)
	
	get_owner().rotation.y = actual_rotation.y
	rotation.x = actual_rotation.x
