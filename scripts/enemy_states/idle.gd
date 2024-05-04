extends EnemyState

func init(_data: Dictionary={}) -> void:
	print("Enemy Idle")

func update(_delta) -> void:
	if enemy.contact_with_player == true:
		emit_signal("change_state_request", "Chase")

func physics_update(_delta) -> void:
	pass