class_name StateMachine
extends Node

signal state_changed(current_state)

var _states: Dictionary
var _current_state: State: get = get_current_state


func _ready():
	_find_child_states()
	_run_initial_state()


# Public methods
func handle_input(event: InputEvent) -> void:
	_current_state.handle_input(event)


func update(delta: float) -> void:
	_current_state.update(delta)


func physics_update(delta: float) -> void:
	_current_state.physics_update(delta)


func get_current_state() -> State:
	return _current_state


func transition_to(target_state_id: String, data: Dictionary={}) -> void:
	assert(_states.has(target_state_id))
	_current_state.disconnect("change_state_request", self._on_change_state_request)
	_current_state.leave()
	
	_current_state = _states[target_state_id]
	_current_state.init(data)
	var res := _current_state.connect("change_state_request", self._on_change_state_request)
	assert(OK == res)


# Signal methods
func _on_change_state_request(state_id: String, data: Dictionary={}) -> void:
	transition_to(state_id, data)


# Private methods
func _find_child_states() -> void:
	for child in get_children():
		if child is State:
			_states[child.name] = child


func _run_initial_state() -> void:
	_current_state = get_child(0)
	var res := _current_state.connect("change_state_request", self._on_change_state_request)
	assert(OK == res)
	_current_state.init()
