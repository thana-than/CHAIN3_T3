extends Node3D
class_name Chain3ExitTrigger

@export var door_ref : ChainDoor

func call_exit():
	Chain3Adapter.exit_via_door(door_ref.door_id)
