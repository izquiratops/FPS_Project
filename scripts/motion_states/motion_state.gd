# TODO: Rename to Motion State
## MotionState is a wrapper class that holds references and methods used on multiple States.
class_name MotionState
extends State

# Keep all the states that extends this class on the same directory level
# Player (Controller)
#   ⤷ Motion States (State Machine)
#       ⤷ Idle State (Player is '../..' from Idle state)
#       ⤷ Walk State (Same route)
@onready var player = $'../..'
@onready var state_machine = $'..'

@onready var above_head_ray_cast = $'../../AboveHeadRayCast'
@onready var standing_collision_shape = $'../../StandingCollisionShape'
@onready var crouching_collision_shape = $'../../CrouchingCollisionShape'

## Check if the player is touching the ground and there's room above to jump
func can_jump() -> bool:
    return player.is_on_floor() and not above_head_ray_cast.is_colliding()
