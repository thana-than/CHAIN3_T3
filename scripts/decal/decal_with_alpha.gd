class_name DecalWithAlpha
extends Decal

var _albedo_tex: Texture2D
var _opacity_tex: Texture2D


@export var albedo_tex: Texture2D:
	set(value):
		_albedo_tex = value
	get:
		return _albedo_tex

@export var opacity_tex: Texture2D:
	set(value):
		_opacity_tex = value
	get:
		return _opacity_tex
