extends MovementAbility3D
class_name GravityAbility3D

## Ability that changes gravity when actived

## Gravity to be multiplied when active the ability
@export var gravity_multiplier := 0.666

## Returns a gravity modifier, 
## useful for abilities that when active can change the overall gravity of the [CharacterController3D], for example the [GravityAbility3D].
func get_gravity_multiplier() -> float:
	if is_actived():
		return gravity_multiplier
	else:
		return super.get_gravity_multiplier()