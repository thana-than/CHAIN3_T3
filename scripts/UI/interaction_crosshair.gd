extends TextureRect
class_name InteractionCrosshair

@export var crosshairs: Dictionary[Interaction.Type, Texture2D] = {}

func _ready():
	update_crosshair(Interaction.Type.NONE)

func update_crosshair(type: Interaction.Type):
	if not crosshairs.has(type):
		type = Interaction.Type.INTERACT

	texture = crosshairs.get(type)
