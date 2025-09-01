class_name ChainDoor
extends Resource

## A ChainDoor is a Resource that represents an entrance/exit between your game and
## another game in the CHAIN.
##
## The sceneselector.tscn scene contains an array of all the doors into your game,
## and handles opening the correct scene when your game is loaded.
##
## For each ChainDoor, you will need to set both the ID and the scene in your game
## that will be loaded if a player enters your game through that door.
##
## For example, if your game is set in a grocery store, you might have a door that
## corresponds to entering through the front door, and another that corresponds to
## entering through the employee entrance in the alley.


#region Export variables -------------------------------------------------------

## Set this to the map ID of the game this door connects to.
## For example: "START" if it's the game hub, or "A1", "F3", et cetera.
@export var door_id: String

## The file path to the scene that will be loaded if the game is entered through
## this door.
@export_file("*.tscn") var target_scene: String

## Folder name where the [code]enter.door[/code] and [code]exit.door[/code] files 
## will be saved. You probably won't need to change this variable.
@export var streaming_assets_folder: String = "./StreamingAssets"

## Description of the door as it relates to your game and connection to other games.
## This variable is not used by the plugin, but provided as a reference/reminder
## space for you during your development process.
@export_multiline var description: String

#endregion
