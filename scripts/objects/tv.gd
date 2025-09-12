@tool
extends Node3D
class_name TV

@export var screen_mesh : MeshInstance3D:
	set(_mesh):
		screen_mesh = _mesh
		if screen_mesh:
			screen_mesh.material_override = screen_material
	get:
		return screen_mesh

@export var screen_material : Material:
	set(_mat):
		screen_material = _mat
		if screen_mesh:
			screen_mesh.material_override = screen_material
	get:
		return screen_material
