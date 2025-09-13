extends Camera3D

func _process(_delta):
	var player_cam = Global.player.get_viewport().get_camera_3d()
	global_transform = player_cam.global_transform
	scale_object_local(Vector3(-1,1,1))
