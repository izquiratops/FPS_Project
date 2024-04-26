extends PlayerState


func init(_data: Dictionary={}) -> void:
	print('Crouch')
	player.current_speed = 3.0
	player.crouch_depth = -0.5
	standing_collision_shape.disabled = true
	crouching_collision_shape.disabled = false


func physics_update(delta) -> void:
	# Get direction from WASD inputs.
	var input_direction = player.get_input_direction()
	
	# Checking above head to avoid getting hurt under low ceilings.
	if Input.is_action_just_pressed("jump") and player.is_on_floor() and not above_head_ray_cast.is_colliding():
		emit_signal("change_state_request", "Jump")

	if not Input.is_action_pressed("crouch"):
		if input_direction.is_zero_approx():
			emit_signal("change_state_request", "Idle")
		elif Input.is_action_pressed("sprint"):
			emit_signal("change_state_request", "Sprint")
		else:
			emit_signal("change_state_request", "Walk")

	# Apply gravity
	player.apply_gravity(delta)
	player.apply_direction(delta, input_direction)


func leave() -> void:
	player.crouch_depth = 0.0
	crouching_collision_shape.disabled = true
	standing_collision_shape.disabled = false
