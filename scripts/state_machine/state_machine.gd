class_name StateMachine
extends Node

signal state_changed(current_state)

var states: Dictionary
var current_state: State: get = get_current_state

## TODO: Write documentation
@export() var change_state_key = "change_state_request"

func _ready():
	_find_child_states()
	_run_initial_state()

# ---- Public methods ----
func handle_input(event: InputEvent) -> void:
	current_state.handle_input(event)

func update(delta: float) -> void:
	current_state.update(delta)

func physics_update(delta: float) -> void:
	current_state.physics_update(delta)

func get_current_state() -> State:
	return current_state

func transition_to(target_state_id: String, data: Dictionary={}) -> void:
	assert(states.has(target_state_id))
	current_state.disconnect(change_state_key, _on_change_state_request)
	current_state.leave()
	
	current_state = states[target_state_id]
	current_state.init(data)
	var res := current_state.connect(change_state_key, _on_change_state_request)
	assert(OK == res)

# ---- Signal methods ----
func _on_change_state_request(state_id: String, data: Dictionary={}) -> void:
	transition_to(state_id, data)

# ---- Private methods ----
func _find_child_states() -> void:
	for child in get_children():
		if child is State:
			states[child.name] = child

func _run_initial_state() -> void:
	current_state = get_child(0)
	var res := current_state.connect(change_state_key, _on_change_state_request)
	assert(OK == res)
	current_state.init()
