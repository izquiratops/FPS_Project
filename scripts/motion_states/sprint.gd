extends MotionState

func init(_data: Dictionary={}) -> void:
	print('Sprint')
	player.current_speed = 12.0

func update(_delta) -> void:
	player.apply_input_direction()

	# Slides when crouch while sprinting
	if Input.is_action_pressed("crouch"):
		emit_signal(state_machine.change_state_key, "Slide")

	elif Input.is_action_just_pressed("jump") and can_jump():
		emit_signal(state_machine.change_state_key, "Jump")

	# Letting go shift key
	elif not Input.is_action_pressed("sprint"):
		if player.input_direction.is_zero_approx():
			emit_signal(state_machine.change_state_key, "Idle")
		else:
			emit_signal(state_machine.change_state_key, "Walk")