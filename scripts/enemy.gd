class_name Enemy
extends CharacterBody3D

@onready var enemy_state_machine: StateMachine = $EnemyStates

# Enemy State
var contact_with_player = false

func _process(delta: float) -> void:
	enemy_state_machine.get_current_state().update(delta)

func _physics_process(delta: float) -> void:
	enemy_state_machine.get_current_state().physics_update(delta)

# TODO: Work in progress
func update_target_location(target_location) -> void:
	$NavigationAgent3D.target_position = target_location
