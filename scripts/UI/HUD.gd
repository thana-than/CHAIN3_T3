extends Control

@onready var crosshair : InteractionCrosshair = get_node(NodePath("Crosshair"))

func _interactor_on_focus(_interactable: Interactable3D) -> void:
	crosshair.update_crosshair(Interaction.Type.INTERACT)

func _interactor_on_unfocus(_interactable: Interactable3D) -> void:
	crosshair.update_crosshair(Interaction.Type.NONE)
