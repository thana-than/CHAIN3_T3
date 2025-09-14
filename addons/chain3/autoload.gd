extends Node


#region Export variables -------------------------------------------------------

@export var door_id: String = "START"
@export var streaming_assets_folder: String = "./StreamingAssets"

#endregion


#region Game exit function -------------------------------------------------------

## Exit game function. Writes the passed door_id to the exit.door file in the
## StreamingAssets/ folder.
##
## Call this function when the player passes through a door "out" of your game
## and into a new one. The door_id you pass to this function should be the Map ID
## of the next game.
##
## You can call this function via the chain3 global like this:
## chain3.exit_game("A1")
##
## This would write the value "A1" to the exit.door file and close your game
## immediately.
##
## Example uses of this function would be in a script attached to an Area2D or
## Area 3D, calling the exit_game function when the player collides with the exit
## area.
func exit_game(door_id: String) -> void:
	var door_path: String = streaming_assets_folder + "/exit.door"
	FileAccess.open(door_path,FileAccess.WRITE_READ).store_string(door_id)
	
	get_tree().quit()
#endregion


#region Flag functions ---------------------------------------------------------

## SHARED DATA (FLAG) FUNCTIONS
##
## The CHAIN launcher will create a shareddata.data file in your game's 
## Streaming Data folder, which you can modify using the following functions.
##
## A flag is just a simple string. You can check if a flag exists, and create or
## delete existing flags. A flag can be any string, but for clarity, use the
## following format: "GAMEID_flagName"
##
## For example, say you are making a game with ID "X1" and you have a mysterious
## button in your game. You can create the flag "X1_mysteriousButtonPressed".
## Another developer can check for this flag in their game and have a mysterious
## hatch open that leads to a secret area. If they want, they can put a button next
## to the hatch in their game that closes it, and delete the flag when the button
## is pressed.
##
## USAGE:
##
## From any script, call the chain3.create_flag(), chain3.delete_flag(), and
## chain3.does_flag_exist() functions.
##
## When you add a flag to your game, please add it to the following shared
## spreadsheet with a description of what game mechanic it's tied to. Also note
## if your game manipulates any existing flags.
##
## Spreadsheet link: https://docs.google.com/spreadsheets/d/1dpW24T5lsOGn2VfevVdI4zt9Hn87leZOaT6lNfFUgpA/edit?usp=sharing


## Create a new flag with the specified string. The preferred format is
## GAMEID_flagName. Example: "X1_mysteriousButtonPressed"
func create_flag(flag_name: String) -> void:
	var flags: Array = get_flags()
	
	# Append and save the flag
	if (not flags.has(flag_name)):
		flags.append_array([flag_name])
		save_flags(flags)


## Get an array of all flags in the shareddata.data file
func get_flags() -> Array:
	var path: String = streaming_assets_folder + "/shareddata.data"
	
	# Return empty array if the file doesn't exist
	if (FileAccess.file_exists(path) == false):
		return []
	
	# Return flags
	var lines = FileAccess.open(path, FileAccess.READ).get_as_text().strip_edges().split("\n")
	for i in range(len(lines)):
		lines[i] = lines[i].strip_edges()
	return lines


## Delete the flag indicated by the passed argument
func delete_flag(flag_name: String) -> void:
	var flags: Array = get_flags()
	
	# Erase and save flags
	if (flags.has(flag_name)):
		flags.erase(flag_name)
		save_flags(flags)


## Returns true if the passed argument exists as a flag in the shareddata.data
## file. Otherwise, return false.
func does_flag_exist(flag_name: String) -> bool:
	return get_flags().has(flag_name)


## Save all flags to the shareddata.data file.
## This function is called automatically, you shouldn't need to call it directly.
func save_flags(flags: Array) -> void:
	var path: String = streaming_assets_folder + "/shareddata.data"
	FileAccess.open(path,FileAccess.WRITE_READ).store_string("\n".join(flags))
	
func clear_flags() -> void:
	var dir := DirAccess.open(streaming_assets_folder)
	var file_name := "shareddata.data"
	if dir.file_exists(file_name):
		dir.remove(file_name)

#endregion
