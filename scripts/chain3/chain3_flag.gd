extends Node
class_name Chain3Flag

@export var flag : String
@export var type := FLAG_TYPE.STANDARD

signal on_flag_changed(is_set:bool)

enum FLAG_TYPE {STANDARD, LOCAL, INTERNAL}

func _ready():
	Chain3Adapter.flags_changed.connect(_on_flag_changed_notification)
	
func _on_flag_changed_notification(flags: Array, change_type: Chain3AdapterClass.FlagChangeType):
	if not flags.has(flag):
		return
	if change_type == Chain3AdapterClass.FlagChangeType.CREATED:
		on_flag_changed.emit(true)
	else:
		on_flag_changed.emit(false)
	
func set_flag():
	match type:
		FLAG_TYPE.STANDARD:
			Chain3Adapter.set_flag(flag)
		FLAG_TYPE.LOCAL:
			Chain3Adapter.set_local_flag(flag)
		FLAG_TYPE.INTERNAL:
			Chain3Adapter.set_internal_flag(flag)

func unset_flag():
	
	match type:
		FLAG_TYPE.STANDARD:
			Chain3Adapter.unset_flag(flag)
		FLAG_TYPE.LOCAL:
			Chain3Adapter.unset_local_flag(flag)
		FLAG_TYPE.INTERNAL:
			Chain3Adapter.unset_internal_flag(flag)

func is_flag_set() -> bool:
	match type:
		FLAG_TYPE.STANDARD:
			return Chain3Adapter.is_flag_set(flag)
		FLAG_TYPE.LOCAL:
			return Chain3Adapter.is_local_flag_set(flag)
		FLAG_TYPE.INTERNAL:
			return Chain3Adapter.is_internal_flag_set(flag)
	return false
