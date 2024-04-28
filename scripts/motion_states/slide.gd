extends MotionState

@export_category("Tilt")
@export() var slide_camera_tilt = -deg_to_rad(5.0)

@export_category("Timer")
@export() var slide_timer: Timer
@export() var slide_timer_max = 1.0
@export() var slide_speed = 10.0
@export() var slide_speed_min = 2.0

func init(_data: Dictionary={}) -> void:
	print('Slide')
	slide_timer.start()
	player.apply_input_direction()

	# Tilting camera
	player.camera_tilt = slide_camera_tilt

	# Ducking head
	player.crouch_depth = -0.5
	standing_collision_shape.disabled = true
	crouching_collision_shape.disabled = false

func update(_delta) -> void:
	# Decrease the speed over time until reach a minimum amount
	player.current_speed = max(slide_speed * slide_timer.time_left, slide_speed_min)

	# Player can jump while sliding, just like crouching
	if Input.is_action_just_pressed("jump") and can_jump():
		emit_signal(state_machine.change_state_key, "Jump")

	# Standing up mid-slide
	elif not Input.is_action_pressed("crouch"):
		if Input.is_action_pressed("sprint"):
			emit_signal(state_machine.change_state_key, "Sprint")
		else:
			emit_signal(state_machine.change_state_key, "Walk")

func leave() -> void:
	print('Slide ends')
	# Make sure to stop the timer if we're leaving mid-slide
	slide_timer.stop()

	# Undo camera tilt
	player.camera_tilt = 0.0

	# Stand up
	player.crouch_depth = 0.0
	standing_collision_shape.disabled = false
	crouching_collision_shape.disabled = true

## TODO: Write documentation
func slide_ends() -> void:
	print('Slide timeout')
	# The player will crouch after the slide ends by default
	emit_signal(state_machine.change_state_key, "Crouch")
