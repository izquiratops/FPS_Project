extends PlayerState

# TODO
func init(_data: Dictionary={}) -> void:
	print('Slide')


func physics_update(delta) -> void:
	# Get direction from WASD inputs.
	var input_direction = player.get_input_direction()

	# Apply gravity
	player.apply_gravity(delta)
	player.apply_direction(delta, input_direction)
