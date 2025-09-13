@tool
extends EditorInspectorPlugin

func _can_handle(obj) -> bool:
	return obj is DecalWithAlpha

func _parse_begin(obj) -> void:
	add_custom_control(HSeparator.new())

	var hb := HBoxContainer.new()
	var btn := Button.new()
	btn.alignment = HORIZONTAL_ALIGNMENT_CENTER
	btn.text = "Bake Alpha → Albedo"
	btn.tooltip_text = "Combine opacity_tex into albedo_tex alpha and assign to this Decal."
	btn.pressed.connect(func ():
		_bake_alpha_to_albedo(obj)
		var ei := EditorInterface
		var insp := ei.get_inspector()
		if insp:
			insp.queue_redraw()
	)
	hb.add_child(btn)
	add_custom_control(hb)

func _bake_alpha_to_albedo(decal: DecalWithAlpha) -> void:
	if ((decal.albedo_tex == null) or (decal.opacity_tex == null)):
		return
	
	var img = decal.albedo_tex.get_image()
	var opacity = decal.opacity_tex.get_image()
	
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
			img.set_pixel(x, y, rgb)
	var itex := ImageTexture.create_from_image(img)
	decal.set_texture(Decal.DecalTexture.TEXTURE_ALBEDO, itex)
