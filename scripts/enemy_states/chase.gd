extends EnemyState

@export() var movement_speed = 1.0

func init(_data: Dictionary={}) -> void:
	print("Chasing the Player")

func update(_delta) -> void:
	if enemy.contact_with_player == false:
		emit_signal("change_state_request", "Idle")

# TODO: Work in progress
func physics_update(_delta) -> void:
	var current_position = enemy.global_transform.origin
	var next_position = navigation_agent.get_next_path_position()
	var current_velocity = (next_position - current_position) * movement_speed

	enemy.velocity = enemy.velocity.move_toward(current_velocity, 1.0)
	enemy.move_and_slide()
