extends PlayerState

func init(_data: Dictionary={}) -> void:
	print('Idle')
	player.current_speed = 0.0


func update(_delta) -> void:
	return


func physics_update(delta) -> void:
	# Get direction from WASD inputs.
	var input_direction = player.get_input_direction()

	# Handle Crouch, which is the most dominant state
	if Input.is_action_pressed("crouch"):
		emit_signal("change_state_request", "Crouch")
	# Handle Jump. Checking above head to avoid getting hurt under low ceilings.
	if Input.is_action_just_pressed("jump") and player.is_on_floor() and not above_head_ray_cast.is_colliding():
		emit_signal("change_state_request", "Jump")

	# Getting motion from a static state
	if not input_direction.is_zero_approx():
		if Input.is_action_pressed("sprint"):
			emit_signal("change_state_request", "Sprint")
		else:
			emit_signal("change_state_request", "Walk")

	# Apply gravity
	player.apply_gravity(delta)
	player.apply_direction(delta, input_direction)
