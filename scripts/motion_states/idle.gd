extends MotionState

func init(_data: Dictionary={}) -> void:
	print('Idle')
	player.current_speed = 0.0

func update(_delta) -> void:
	player.apply_input_direction()

	if Input.is_action_pressed("crouch"):
		emit_signal(state_machine.change_state_key, "Crouch")
	elif Input.is_action_just_pressed("jump") and can_jump():
		emit_signal(state_machine.change_state_key, "Jump")

	# Getting motion when user press WASD
	elif not player.input_direction.is_zero_approx():
		if Input.is_action_pressed("sprint"):
			emit_signal(state_machine.change_state_key, "Sprint")
		else:
			emit_signal(state_machine.change_state_key, "Walk")
