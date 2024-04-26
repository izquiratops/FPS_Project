extends PlayerState


func init(_data: Dictionary={}) -> void:
	print('Jump')

	# Do jump!
	player.velocity.y = player.jump_velocity


func physics_update(delta) -> void:
	var input_direction = player.get_input_direction()

	# Jump ends when touching floor
	# Jump -> Walk | Idle happens via Input
	if player.is_on_floor():
		if input_direction.is_zero_approx():
			emit_signal("change_state_request", "Idle")
		else:
			emit_signal("change_state_request", "Walk")

	# Apply gravity
	player.apply_gravity(delta)
	player.apply_direction(delta, input_direction)
