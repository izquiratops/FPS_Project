extends PlayerState

@export var slide_timer: Timer
const slide_timer_max = 1.0
const slide_speed = 10.0
const slide_speed_min = 2.0

func init(_data: Dictionary={}) -> void:
	print('Slide')
	slide_timer.start()
	player.apply_input_direction()

	# Crouch shared props
	player.crouch_depth = -0.5
	standing_collision_shape.disabled = true
	crouching_collision_shape.disabled = false

func update(_delta) -> void:
	# Decrease the speed over time until reach a minimum amount
	player.current_speed = max(slide_speed * slide_timer.time_left, slide_speed_min)

	# Player can jump while sliding, just like crouching too
	if Input.is_action_just_pressed("jump") and can_jump():
		emit_signal("change_state_request", "Jump")

	# Standing up mid-slide
	elif not Input.is_action_pressed("crouch"):
		if Input.is_action_pressed("sprint"):
			emit_signal("change_state_request", "Sprint")
		else:
			emit_signal("change_state_request", "Walk")

func leave() -> void:
	print('Slide ends')
	# Make sure to stop the timer if we're leaving mid-slide
	slide_timer.stop()

func slide_ends() -> void:
	print('Slide timeout')
	emit_signal("change_state_request", "Crouch")
