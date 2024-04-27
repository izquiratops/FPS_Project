class_name State
extends Node

signal change_state_request(next_state_id)

# Corresponds to _unhandled_input()
func handle_input(_event) -> void:
	return

# Corresponds to the _process()
func update(_delta: float) -> void:
	return

# Corresponds to the _physics_process()
func physics_update(_delta: float) -> void:
	return

# On init life cycle
func init(_data: Dictionary={}) -> void:
	return

# On leave life cycle
func leave() -> void:
	return
