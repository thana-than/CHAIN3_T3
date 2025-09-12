extends MeshInstance3D

@export_exp_easing var curve := 1.0
@export var min_max_transparency := Vector2(0.0,1.0)
@export var min_max_distance := Vector2(0.0, 1.0)

func _process(_delta):
	var dist = clamp(global_position.distance_to(Global.player.global_position), min_max_distance.x, min_max_distance.y)
	dist = inverse_lerp(min_max_distance.x, min_max_distance.y, dist)
	transparency = lerp(min_max_transparency.x, min_max_transparency.y, ease(dist, curve))
