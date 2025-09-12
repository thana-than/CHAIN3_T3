@tool
extends ShaderMaterial
class_name TextureFrameMaterial

@export var texture : Texture2D:
	set(_texture):
		texture = _texture
		_update_shader_parameters()
	get:
		return texture

@export var emission_texture : Texture2D:
	set(_texture):
		emission_texture = _texture
		_update_shader_parameters()
	get:
		return emission_texture
		
@export var frames := 1:
	set(_frames):
		frames = max(1, _frames)
		_update_shader_parameters()
	get:
		return frames
		
@export var speed := 1:
	set(_speed):
		speed = _speed
		_update_shader_parameters()
	get:
		return speed
		
@export var direction := Direction.HORIZONTAL:
	set(_direction):
		direction = _direction
		_update_shader_parameters()
	get:
		return direction
		
const _shader_path := "res://ursc/spatial/standard/standard_opaque_repeating.gdshader"
enum Direction {HORIZONTAL, VERTICAL}

func _init():
	_update_shader_parameters()
	
func _update_shader_parameters():
	if not shader:
		shader = preload(_shader_path)
	#var mult_vector := Vector2.RIGHT if direction == Direction.HORIZONTAL else Vector2.UP
	var mult_vector := Vector2(float(direction == Direction.HORIZONTAL), float(direction == Direction.VERTICAL))
	set_shader_parameter("uv_scroll_frames", frames * mult_vector)
	set_shader_parameter("uv_scroll_speed", speed * mult_vector)
	set_shader_parameter("uv_scale", mult_vector + Vector2(mult_vector.y, mult_vector.x) / frames)
	set_shader_parameter("albedo_texture", texture)
	set_shader_parameter("emission_texture", emission_texture)
	set_shader_parameter("use_emission_texture", emission_texture != null)
	#set_shader_parameter("")
