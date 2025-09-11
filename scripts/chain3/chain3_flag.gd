extends Node
class_name Chain3Flag

@export var flag : String
@export var type := FLAG_TYPE.STANDARD

enum FLAG_TYPE {STANDARD, LOCAL, INTERNAL}

func set_flag():
	match type:
		FLAG_TYPE.STANDARD:
			Chain3Adapter.set_flag(flag)
		FLAG_TYPE.LOCAL:
			Chain3Adapter.set_local_flag(flag)
		FLAG_TYPE.INTERNAL:
			Chain3Adapter.set_internal_flag(flag)

func is_flag_set() -> bool:
	match type:
		FLAG_TYPE.STANDARD:
			return Chain3Adapter.is_flag_set(flag)
		FLAG_TYPE.LOCAL:
			return Chain3Adapter.is_local_flag_set(flag)
		FLAG_TYPE.INTERNAL:
			return Chain3Adapter.is_internal_flag_set(flag)
	return false
