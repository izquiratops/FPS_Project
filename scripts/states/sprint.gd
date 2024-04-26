extends PlayerState

func init(_data: Dictionary={}) -> void:
	print('Sprint')
	player.current_speed = 12.0


func physics_update(delta) -> void:
	# Get direction from WASD inputs.
	var input_direction = player.get_input_direction()

	# Slides when crouch while sprinting
	if Input.is_action_pressed("crouch"):
		emit_signal("change_state_request", "Slide")

	# Letting go shift key
	if not Input.is_action_pressed("sprint"):
		if input_direction.is_zero_approx():
			emit_signal("change_state_request", "Idle")
		else:
			emit_signal("change_state_request", "Walk")

	# Handle Jump. Checking above head to avoid getting hurt under low ceilings.
	if Input.is_action_just_pressed("jump") and player.is_on_floor() and not above_head_ray_cast.is_colliding():
		emit_signal("change_state_request", "Jump")

	# Apply gravity
	player.apply_gravity(delta)
	player.apply_direction(delta, input_direction)
