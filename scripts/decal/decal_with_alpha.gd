@tool
class_name DecalWithAlpha
extends Node3D



@export var albedo_tex: Texture2D:
	set(value):
		albedo_tex = value
		if Engine.is_editor_hint():
			_editor_apply()

@export var opacity_tex: Texture2D:
	set(value):
		opacity_tex = value
		if Engine.is_editor_hint():
			_editor_apply()

@export var decal: Decal

func _editor_apply() -> void:
	var _logger = Logger.new("DECAL WITH ALPHA")
	if not Engine.is_editor_hint():
		return
	if not decal:
		decal = Decal.new()
		add_child(decal)
		decal.owner = self.get_owner()
	
	if ((albedo_tex == null) or (opacity_tex == null)):
		return
	
	var img = albedo_tex.get_image()
	var opacity = opacity_tex.get_image()
	
	if img == null or opacity == null or img.is_empty() or opacity.is_empty():
		return
	
	if img.is_compressed():
		img.decompress()
	if opacity.is_compressed():
		opacity.decompress()
	
	if not img.get_format() in [Image.FORMAT_RGBA8, Image.FORMAT_RGBAF, Image.FORMAT_RGBAH]:
		img.convert(Image.FORMAT_RGBA8)

	
	if opacity.get_size() != img.get_size():
		opacity.resize(img.get_width(), img.get_height(), Image.INTERPOLATE_NEAREST)
	
	var w := img.get_width()
	var h := img.get_height()
	
	for y in range(h):
		for x in range(w):
			var rgb = img.get_pixel(x, y)
			var a = min(opacity.get_pixel(x, y).r, rgb.a)
			rgb.a = a
			_logger.log("R: {r}, G: {g}, B: {b}, A: {a}".format({"r": rgb.r, "g": rgb.g, "b": rgb.b, "a": rgb.a}))
			img.set_pixel(x, y, rgb)
	var itex := ImageTexture.create_from_image(img)
	decal.set_texture(Decal.DecalTexture.TEXTURE_ALBEDO, itex)
