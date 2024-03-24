extends CharacterBody3D

# Player nodes
@onready var neck = $Neck
@onready var head = $Neck/Head
@onready var camera_3d = $Neck/Head/Camera3D
@onready var standing_collision_shape = $StandingCollisionShape
@onready var crouching_collision_shape = $CrouchingCollisionShape
@onready var ray_cast_3d = $RayCast3D

# Input vars
var direction = Vector3.ZERO
const mouse_sensitivity = 0.2

# Speed vars
var current_speed = 0.0
const walking_speed = 5.0
const sprint_speed = 10.0
const crouch_speed = 3.0

# Movement vars
const lerp_speed = 15.0
const jump_velocity = 4.5
const crouch_depth = -0.5
const free_look_tilt_amount = 8.0

# Movement State
var walking = true
var sprinting = false
var crouching = false
var free_looking = false
var sliding = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _input(event):
	if event is InputEventMouseMotion:
		if free_looking:
			# Horizontal range
			neck.rotate_y(deg_to_rad(-1 * mouse_sensitivity * event.relative.x))
			neck.rotation.y = clamp(neck.rotation.y, deg_to_rad(-120), deg_to_rad(120))
		else:
			# Horizontal range
			rotate_y(deg_to_rad(-1 * mouse_sensitivity * event.relative.x))
			# Vertical range
			head.rotate_x((deg_to_rad(-1 * mouse_sensitivity * event.relative.y)))
			head.rotation.x = clamp(head.rotation.x, deg_to_rad(-85), deg_to_rad(85))


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Crouching
	if Input.is_action_pressed("crouch"):
		head.position.y = lerp(head.position.y, crouch_depth, delta * lerp_speed)
		standing_collision_shape.disabled = true
		crouching_collision_shape.disabled = false

		current_speed = crouch_speed
		walking = false
		sprinting = false
		crouching = true
	# Avoid leaving 'crouch' state if there's something above the character's head
	elif !ray_cast_3d.is_colliding():
		head.position.y = lerp(head.position.y, 0.0, delta * lerp_speed)
		standing_collision_shape.disabled = false
		crouching_collision_shape.disabled = true

		if Input.is_action_pressed("sprint"):
			current_speed = sprint_speed
			walking = false
			sprinting = true
			crouching = false
		else:
			current_speed = walking_speed
			walking = true
			sprinting = false
			crouching = false

	# Handle Free looking
	if Input.is_action_pressed("free-look"):
		free_looking = true
		# Tilting camera when looking back
		camera_3d.rotation.z = deg_to_rad(neck.rotation.y * free_look_tilt_amount)
	else:
		free_looking = false
		# Defaulting view to look ahead
		neck.rotation.y = lerp(neck.rotation.y, 0.0, delta * lerp_speed)
		# Defaulting camera tilt
		camera_3d.rotation.z = lerp(camera_3d.rotation.z, 0.0, delta * lerp_speed)

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var target_dir = transform.basis * Vector3(input_dir.x, 0, input_dir.y).normalized()
	direction = lerp(direction, target_dir, delta * lerp_speed)
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()
