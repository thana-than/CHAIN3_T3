extends Node3D

@onready var spawner : Spawner = get_node("landing_outside_skybox_root")
@onready var screen : TV = get_node("obj_large_screen")

var viewport : SubViewport

func activate():
	if viewport:
		return
		
	viewport = spawner.spawn() as SubViewport
	viewport.get_child(0).global_transform = global_transform
	var shader_mat = screen.screen_material as ShaderMaterial
	shader_mat.set_shader_parameter("albedo_texture", viewport.get_texture())
