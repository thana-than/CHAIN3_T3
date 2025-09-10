extends AnimationPlayer
class_name AnimationSequencer

@export var play_on_ready := false
@export var loop_sequence := false
@export var sequence : Array[String] = []

var last_index := -1

func _ready():
	if play_on_ready:
		play_next()

func play_next():
	var next_index = last_index + 1
	var seq_len = len(sequence)
	if next_index >= seq_len:
		if not loop_sequence:
			return
		next_index %= seq_len
		
	play(sequence[next_index])
	last_index = next_index

func reset_index():
	last_index = -1
