extends MotionState

func init(_data: Dictionary={}) -> void:
	print('Jump')
	# Player can move at least at 7.0 (walking speed value)
	player.current_speed = max(player.current_speed, 7.0)
	# Jump up impulse 🦘
	player.velocity.y = jump_gravity * player.jump_peak_time

func handle_input(_event) -> void:
	# Player can still change direction mid-air
	wasd_update()

	# Jump ends when character touch the floor
	if player.is_on_floor():
		if player.input_direction.is_zero_approx():
			emit_signal("change_state_request", "Idle")
		elif Input.is_action_pressed("crouch") and Input.is_action_pressed("sprint"):
			emit_signal("change_state_request", "Slide")
		elif Input.is_action_pressed("crouch"):
			emit_signal("change_state_request", "Crouch")
		elif Input.is_action_pressed("sprint"):
			emit_signal("change_state_request", "Sprint")
		else:
			emit_signal("change_state_request", "Walk")
