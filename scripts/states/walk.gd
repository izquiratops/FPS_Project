extends PlayerState


func init(_data: Dictionary={}) -> void:
	print('Walking')
	player.current_speed = 7.0
	

func physics_update(delta) -> void:
	# Get direction from WASD inputs.
	var input_direction = player.get_input_direction()

	# Handle Crouch, which is the most dominant state
	if Input.is_action_pressed("crouch"):
		emit_signal("change_state_request", "Crouch")
	# Checking above head to avoid getting hurt under low ceilings.
	if Input.is_action_just_pressed("jump") and player.is_on_floor() and not above_head_ray_cast.is_colliding():
		emit_signal("change_state_request", "Jump")
	# Run!
	if Input.is_action_pressed("sprint"):
		emit_signal("change_state_request", "Sprint")
	# Idle -> Walk happens via Input, Walk -> Idle happens via Input & velocity.
	if input_direction.is_zero_approx() and player.velocity.is_zero_approx():
		emit_signal("change_state_request", "Idle")

	# Apply gravity
	player.apply_gravity(delta)
	player.apply_direction(delta, input_direction)
