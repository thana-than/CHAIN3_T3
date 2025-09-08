extends Object
class_name StateMachine

var entry_state: State
var current_state: State

func _init(_entry_state: State):
	entry_state = _entry_state

func restart(_ctx = null):
	current_state = entry_state
	current_state._enter(_ctx)

func process(_delta: float, _ctx = null):
	var state = current_state._process(_delta, _ctx)
	_handle_next_state(state, _ctx)

func physics_process(_delta: float, _ctx = null):
	var state = current_state._physics_process(_delta, _ctx)
	_handle_next_state(state, _ctx)

func _handle_next_state(next_state: State, _ctx = null):
	if next_state != current_state:
		current_state._exit(_ctx)
		current_state = next_state
		current_state._enter(_ctx)