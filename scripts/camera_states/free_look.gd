extends CameraState

@export() var tilt_amount = 8.0

func init(_data: Dictionary={}) -> void:
	print('FreeLook Camera')

func handle_input(event) -> void:
	if event is InputEventMouseMotion:
		# Looking left/right.
		neck.rotate_y(deg_to_rad( - 1 * player.mouse_sensitivity * event.relative.x))
		neck.rotation.y = clamp(neck.rotation.y, deg_to_rad( - 120), deg_to_rad(120))

		# Tilting camera as the character turns around to look backwards
		camera_3d.rotation.z = deg_to_rad(neck.rotation.y * tilt_amount)

	if not Input.is_action_pressed("free-look"):
		emit_signal("change_state_request", "Default")
