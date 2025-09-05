extends Node3D
class_name PortalSpawner

var prefab_portal = preload("res://scenes/objects/obj_portal.tscn")
var current_portal: Portal3D

func spawn_portal() -> void:
	if current_portal:
		remove_portal()
	current_portal = prefab_portal.instantiate() as Portal3D
	current_portal.deactivate()
	add_child(current_portal)
	current_portal.transform = Transform3D.IDENTITY

func link(other_portal_spawner: PortalSpawner) -> void:
	get_portal().exit_portal = other_portal_spawner.get_portal()
	current_portal.activate()

func remove_portal() -> void:
	if current_portal:
		current_portal.queue_free()
		current_portal = null

func get_portal() -> Portal3D:
	if current_portal == null:
		spawn_portal()
	return current_portal
