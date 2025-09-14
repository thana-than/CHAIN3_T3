class_name CHAIN_SceneSelector
extends Node
## CHAIN_SceneSelector
##
## This scene and script handle entering your game from other games in the CHAIN.
## The scene that will be loaded is bsed on the `exit.door` file created by the
## previous game the player exited from. The `exit.door` file will be stored in the
## StreamingAssets/ folder.
##
## HOW TO USE THIS SCRIPT:
##
## 1. *IMPORTANT* Set up your project as described in readme.txt. This scene should
## be set as the Main scene (that is, the first one run when your game launches).
##
## 2. In the Inspector panel, set the default_scene variable to a PackedScene that will
## serve as the default scene for your game, in the event no enter.door file is found
## upon launch.
##
## 3. In the Inspector panel, click the "Add Element" button to increase the size
## of the door_scene_array array to the number of entrances to your game. Check the 
## CHAIN map to confirm the number of connections your game has to other games.
## 
## 4. For each connection to another game, create a CHAIN_Door resource as follows:
##    a. in the FileSystem panel, right-click and choose Create New > Resource
##    b. begin typing "CHAIN_Door" and select ChainDoor when it appears.
##    c. name the file after the CHAIN connection it represents, e.g. "door_A1.tres"
##       (this is not required, but offered as a suggestion to help you keep organized.)
##    d. double-click on the door's .tres file and fill in the following variables
##       in the Inspector panel:
##       - Door ID = the Map ID of the game the player is entering from (e.g. "A1")
##       - My Scene = the scene in your game that should launch when entered from 
##         the game referenced by the Map ID
##       - Description = optional. For your reference as a developer if you need
##         space to write notes to stay organized as you manage Doors.
##   e. save the edited door.tres file using the Floppy Disk icon at the top of
##      the Inspector panel.
##   f. for more information, check out the comments in the CHAIN_Door.gd file.
##
## 5. Once you have made a Door for each connection to another game, open sceneselector.tscn
## and use the Inspector panel to add each door.tres file to the Door Scenes array
## by clicking the empty array element and selecting Load or Quick Load to choose
## the door.tres files.


#region Export variables -------------------------------------------------------

## The game will launch into this scene if there is no [code]enter.door[/code] file in the directory.
@export var default_scene: PackedScene

## An array of [code]CHAIN_Door[/code] resources. TODO: this is how the game decides what scene to send you.
@export var door_scene_array: Array[ChainDoor]

## Folder name where the [code]enter.door[/code] and [code]exit.door[/code] files 
## will be saved. You probably won't need to change this variable.
@export var streaming_assets_folder: String = "./StreamingAssets"

#endregion


#region Built-in virtual functions ---------------------------------------------

func _ready() -> void:
	var door_path: String = streaming_assets_folder + "/enter.door"
	
	if (FileAccess.file_exists(door_path)):
		# Extract the ID of the game the player entered this one via
		var door_id: String = FileAccess.open(door_path, FileAccess.READ).get_as_text().to_lower()
		
		var matching_door: PackedScene = default_scene
		
		# Iterate through door scenes, checking each to see if the ID matches
		# the one we entered through:
		for door in door_scene_array:
			if (door_id == door.door_id.to_lower()):
				matching_door = load(door.target_scene)
				chain3.door_id = door_id
				break
		
		# Once we are done switch to a packed scene (using the default if no matching
		# ID was found
		if (matching_door):
			get_tree().call_deferred("change_scene_to_packed", matching_door)
	else:
		# Load the default scene if the enter.door file was not found
		if (default_scene):
			get_tree().call_deferred("change_scene_to_packed", default_scene)

#endregion
