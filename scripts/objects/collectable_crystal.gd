@tool
extends Interactable3D
class_name CollectableCrystal

signal on_collect

@export var collect_flag: String
@export var crystal_mesh: MeshInstance3D:
	set(_mesh):
		crystal_mesh = _mesh
		refresh_color(color)
	get:
		return crystal_mesh

@export var color: Color:
	set(_color):
		color = _color
		refresh_color(_color)
	get:
		return color
		
@export var light: Light3D:
	set(_light):
		light = _light
		refresh_light_color(light_color)
	get:
		return light
		
@export var light_color: Color:
	set(_color):
		light_color = _color
		refresh_light_color(light_color)
	get:
		return light_color

var mat_instance: ShaderMaterial
var emission_param := "emission_color"
var has_been_collected = false

@onready var obj_root := get_node("obj")
@onready var flag_controller: Chain3Flag = get_node("Chain3Flag")

func _ready():
	if Engine.is_editor_hint():
		return
		
	flag_controller.flag = collect_flag
	if flag_controller.is_flag_set():
		queue_free()
		return

	interacted.connect(collect)
	flag_controller.on_flag_changed.connect(_on_flag_changed)

func _on_flag_changed(is_set : bool):
	if has_been_collected:
		return
	if is_set:
		queue_free()

func collect():
	has_been_collected = true
	flag_controller.set_flag()
	on_collect.emit()

func refresh_color(_color):
	if not crystal_mesh:
		return

	if not mat_instance:
		mat_instance = crystal_mesh.mesh.surface_get_material(0).duplicate()
	
	mat_instance.set_shader_parameter(emission_param, _color)
	crystal_mesh.material_override = mat_instance
	
func refresh_light_color(_color):
	if not light:
		return
	light.light_color = _color
