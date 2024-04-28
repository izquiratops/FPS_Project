extends MotionState

func init(_data: Dictionary={}) -> void:
	print('Sprint')
	player.current_speed = 12.0

func handle_input(_event) -> void:
	wasd_update()

	# Slides when crouch while sprinting
	if Input.is_action_pressed("crouch"):
		emit_signal("change_state_request", "Slide")

	elif Input.is_action_just_pressed("jump") and can_jump():
		emit_signal("change_state_request", "Jump")

	# Letting go shift key
	elif not Input.is_action_pressed("sprint"):
		if player.input_direction.is_zero_approx():
			emit_signal("change_state_request", "Idle")
		else:
			emit_signal("change_state_request", "Walk")