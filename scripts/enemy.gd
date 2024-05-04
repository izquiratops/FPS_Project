extends CharacterBody3D

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var vision_area: Area3D = $'Head/VisionArea'
@onready var vision_ray_cast: RayCast3D = $'Head/VisionRayCast'

@export() var vision_range = 5.0 # Meters
@export() var movement_speed = 1.0

func _ready():
    vision_area.scale = Vector3.ONE * vision_range
    vision_ray_cast.target_position = Vector3(0.0, 0.0, 2.0 * vision_range)

func _physics_process(_delta):
    var current_position = global_transform.origin
    var next_position = navigation_agent.get_next_path_position()
    var current_velocity = (next_position - current_position) * movement_speed
    velocity = velocity.move_toward(current_velocity, 1.0)

    move_and_slide()

func update_target_location(target_location):
    navigation_agent.target_position = target_location

# Runs when the intervalTimer timesout
func lookForEnemies() -> void:
    var bodies = vision_area.get_overlapping_bodies()
    var player: Node3D

    # Find player
    for body in bodies:
        if body.name == "Player":
            player = body
    
    if not player:
        return

    # Trace ray to check direct contact
    var player_position = player.global_transform.origin
    vision_ray_cast.look_at(player_position, Vector3.UP, true)
    vision_ray_cast.force_raycast_update()

    var collider = vision_ray_cast.get_collider()
    if collider and collider.name == "Player":
        # Draw green
        vision_ray_cast.debug_shape_custom_color = Color("75ad56")
    else:
        # Draw red
        vision_ray_cast.debug_shape_custom_color = Color("ff5b4a")
