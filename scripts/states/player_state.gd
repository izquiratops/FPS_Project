## PlayerState is a wrapper class that holds references and methods used on multiple States.
class_name PlayerState
extends State

# Important: Keep all the states extending this class on the same directory level
# ✦ Player
#   ⤷ MotionStates
#       ⤷ Idle (Player is '../..' from Idle)
#       ⤷ Walk (Same route)

# PlayerController node
@onready var player = $'../..'

# Nodes needed on multiple states
@onready var above_head_ray_cast = $'../../AboveHeadRayCast'
@onready var standing_collision_shape = $'../../StandingCollisionShape'
@onready var crouching_collision_shape = $'../../CrouchingCollisionShape'

## Check if the player is touching the ground and there's room above to jump
func can_jump() -> bool:
    return player.is_on_floor() and not above_head_ray_cast.is_colliding()
