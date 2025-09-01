class_name CHAIN_SpawnPoint
extends Node

## Chain spawn point
##
## DESCRIPTION:
##
## When a node this script is attached to enters the scene tree (that is, its
## _ready() function runs) this script checks to see if its door_id matches the
## door_id of the game the player entered your game from.
##
## If the door_id keys match, the `spawned` signal is emitted. You can use this
## signal to instantiate your player object at the location of this script's node.
##
## TO USE:
##
## 1. Attach this script to a Node2D (for 2d Games) or a Node3D (for 3d games).
## 2. Place that node in your scene where you want the player to spawn when first entering.
## 3. In the Inspector panel, set the Door ID variable to the correspond to the 
##    ID of the game the player is entering your game through. Check the CHAIN 
##    map to get the IDs.
##
## To make the player actually spawn in your scene, either:
##   a. edit this script to add a spawning function, or 
##   b. create a function in another script (probably on the parent scene) and 
##      connect the `spawned` signal from this script to that function.
##
## When writing a player spawning function, take care to match the player's position
## (or global_position) and rotation to that of the object this script is attached to.


## This signal is emitted when the containing scene is loaded and the Spawn Point's
## Door ID matches that of the game the player is entering from.
signal spawned

## Set this to the ID of the door this spawn point is associated with
@export var door_id: String


func _ready() -> void:
	if (chain3.door_id.to_lower() == door_id.to_lower()):
		spawned.emit()
