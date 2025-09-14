extends Node3D

@export var position_speed : Vector3
@export var scale_speed : Vector3
@export var rotation_speed : Vector3

func process(delta):
	position += position_speed * delta
	scale += scale_speed * delta
	rotation += rotation_speed * delta
