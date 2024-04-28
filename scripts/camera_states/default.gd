extends CameraState

func init(_data: Dictionary={}) -> void:
	print('Default Camera')

func update(delta) -> void:
	# Apply camera tilt
	camera_3d.rotation.z = lerp(camera_3d.rotation.z, player.current_camera_tilt, delta * player.lerp_speed)

	if Input.is_action_pressed("free-look"):
		emit_signal("change_state_request", "FreeLook")

func handle_input(event) -> void:
	if event is InputEventMouseMotion:
		# Looking left/right
		player.rotate_y(deg_to_rad( - 1 * player.mouse_sensitivity * event.relative.x))
		# Looking up/down
		head.rotate_x((deg_to_rad( - 1 * player.mouse_sensitivity * event.relative.y)))
		# Do not let the player look over 85rads up or down.
		head.rotation.x = clamp(head.rotation.x, deg_to_rad( - 85), deg_to_rad(85))
