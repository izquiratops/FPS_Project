extends Timer

@onready var enemy: Enemy = $'..'
@onready var vision_area: Area3D = $'../Head/VisionArea'
@onready var vision_ray_cast: RayCast3D = $'../Head/VisionRayCast'

func _on_timeout() -> void:
	var bodies = vision_area.get_overlapping_bodies()
	var player: Node3D

	# Find player
	for body in bodies:
		if body.name == "Player":
			player = body
	
	if not player:
		enemy.contact_with_player = false
		return

	# Trace ray to check direct contact
	var player_position = player.global_transform.origin
	vision_ray_cast.look_at(player_position, Vector3.UP, true)
	vision_ray_cast.force_raycast_update()

	var collider = vision_ray_cast.get_collider()
	if collider and collider.name == "Player":
		# Draw green
		vision_ray_cast.debug_shape_custom_color = Color("75ad56")
		enemy.contact_with_player = true
	else:
		# Draw red
		vision_ray_cast.debug_shape_custom_color = Color("ff5b4a")
		enemy.contact_with_player = false
