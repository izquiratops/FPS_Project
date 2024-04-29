class_name MotionState
extends State

"""
Keep all the states that extends this class on the same directory level.

Player (Controller)
	⤷ Motion States (State Machine)
		⤷ Idle State (Player is '../..' from Idle state)
		⤷ Walk State (Same route)
"""

@onready var player: PlayerController = $'../..'
@onready var state_machine: StateMachine = $'..'

@onready var head: Node3D = $'../../Neck/Head'
@onready var above_head_ray_cast: RayCast3D = $'../../AboveHeadRayCast'
@onready var standing_collision_shape: CollisionShape3D = $'../../StandingCollisionShape'
@onready var crouching_collision_shape: CollisionShape3D = $'../../CrouchingCollisionShape'

func physics_update(delta: float) -> void:
	# Head height and Bobbing
	head.position.y = lerp(head.position.y, player.current_crouch_depth, delta * player.lerp_speed)

	# Gravity
	if player.velocity.y > 0:
		player.velocity.y -= player.jump_gravity * delta
	else:
		player.velocity.y -= player.fall_gravity * delta

	# Apply input WASD direction to the current
	player.current_direction = lerp(player.current_direction, player.input_direction, delta * player.lerp_speed)

	# Apply player velocity
	if player.current_direction:
		player.velocity.x = player.current_direction.x * player.current_speed
		player.velocity.z = player.current_direction.z * player.current_speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.current_speed)
		player.velocity.z = move_toward(player.velocity.z, 0, player.current_speed)

	player.move_and_slide()

func wasd_update() -> void:
	var direction = Input.get_vector("left", "right", "forward", "backward")
	player.input_direction = player.transform.basis * Vector3(direction.x, 0, direction.y).normalized()

func can_jump() -> bool:
	return player.is_on_floor() and not above_head_ray_cast.is_colliding()
