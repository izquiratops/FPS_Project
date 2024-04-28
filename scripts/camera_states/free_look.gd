extends CameraState

func init(_data: Dictionary={}) -> void:
	print('FreeLook Camera')

func update(_delta) -> void:
	if not Input.is_action_pressed("free-look"):
		emit_signal("change_state_request", "Default")
