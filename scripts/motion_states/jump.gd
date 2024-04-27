extends PlayerState

func init(_data: Dictionary={}) -> void:
	print('Jump')
	# Player can move at least at 7.0 (walking speed value)
	player.current_speed = max(player.current_speed, 7.0)
	player.velocity.y = player.jump_velocity

func update(_delta) -> void:
	# Player can still change direction mid-air
	player.apply_input_direction()

	# Jump ends when character touch the floor
	if player.is_on_floor():
		if player.input_direction.is_zero_approx():
			emit_signal(state_machine.change_state_key, "Idle")
		elif Input.is_action_pressed("crouch"):
			emit_signal(state_machine.change_state_key, "Crouch")
		elif Input.is_action_pressed("sprint"):
			emit_signal(state_machine.change_state_key, "Sprint")
		else:
			emit_signal(state_machine.change_state_key, "Walk")
