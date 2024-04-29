extends MotionState

@export() var bobbing_speed = 12.0
@export() var bobbing_intensity = 0.07

func init(_data={}) -> void:
	print('Walking')
	player.current_speed = 7.0
	player.current_bobbing_intensity = bobbing_intensity

func update(delta):
	player.current_bobbing_index += bobbing_speed * delta
	bobbing_update(delta)

func handle_input(_event) -> void:
	wasd_update()

	if player.input_direction.is_zero_approx():
		emit_signal("change_state_request", "Idle")
	elif Input.is_action_pressed("crouch"):
		emit_signal("change_state_request", "Crouch")
	elif Input.is_action_just_pressed("jump") and can_jump():
		emit_signal("change_state_request", "Jump")
	elif Input.is_action_pressed("sprint"):
		emit_signal("change_state_request", "Sprint")
