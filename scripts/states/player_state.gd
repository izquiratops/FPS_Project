class_name PlayerState
extends State

# Local route from each state inside StateMachine up to Player node.
@onready var player = $"../.." # PlayerController node
@onready var head = $"../../Neck/Head"
@onready var above_head_ray_cast = $"../../AboveHeadRayCast"
@onready var standing_collision_shape = $"../../StandingCollisionShape"
@onready var crouching_collision_shape = $"../../CrouchingCollisionShape"
