extends PlayerState

func init(_data: Dictionary={}) -> void:
	print('Walking')
	player.current_speed = 7.0

func update(_delta) -> void:
	player.apply_input_direction()

	if player.input_direction.is_zero_approx():
		emit_signal(state_machine.change_state_key, "Idle")
	elif Input.is_action_pressed("crouch"):
		emit_signal(state_machine.change_state_key, "Crouch")
	elif Input.is_action_just_pressed("jump") and can_jump():
		emit_signal(state_machine.change_state_key, "Jump")
	elif Input.is_action_pressed("sprint"):
		emit_signal(state_machine.change_state_key, "Sprint")
