extends Node
class_name MusicController

@export var track : AudioEventResource

func play():
	MusicPlayer.play_music(track)

func stop(any_track := true):
	if any_track or MusicPlayer.get_current_track() == track.name:
		MusicPlayer.stop()
