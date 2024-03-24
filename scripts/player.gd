extends CharacterBody3D

# Player nodes.
@onready var neck = $Neck
@onready var head = $Neck/Head
@onready var camera_3d = $Neck/Head/Camera3D
@onready var standing_collision_shape = $StandingCollisionShape
@onready var crouching_collision_shape = $CrouchingCollisionShape
@onready var above_head_ray_cast = $AboveHeadRayCast

# Input vars.
var direction = Vector3.ZERO
const mouse_sensitivity = 0.2

# Speed vars.
var current_speed = 0.0
const walking_speed = 5.0
const sprint_speed = 10.0
const crouch_speed = 3.0

# Movement vars.
const lerp_speed = 15.0
const jump_velocity = 4.5
const crouch_depth = -0.5
const free_look_tilt_amount = 8.0

# Movement State.
var walking = true
var sprinting = false
var crouching = false
var sliding = false
var free_looking = false

# Slide vars.
var slide_timer = 0.0
var slide_direction = Vector2.ZERO
const slide_timer_max = 1.0
const slide_speed = 10.0
const slide_speed_min = 2.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _input(event):
	if event is InputEventMouseMotion:
		if free_looking:
			# Looking left/right.
			neck.rotate_y(deg_to_rad(-1 * mouse_sensitivity * event.relative.x))
			neck.rotation.y = clamp(neck.rotation.y, deg_to_rad(-120), deg_to_rad(120))
		elif not sliding:
			# Looking left/right.
			rotate_y(deg_to_rad(-1 * mouse_sensitivity * event.relative.x))
			# Looking up/down.
			head.rotate_x((deg_to_rad(-1 * mouse_sensitivity * event.relative.y)))
			head.rotation.x = clamp(head.rotation.x, deg_to_rad(-85), deg_to_rad(85))


func _process(delta):
	if sliding:
		# Handle sliding timer.
		slide_timer -= delta
		# Updating state when timer ends.
		if slide_timer <= 0:
			sliding = false


func _physics_process(delta):
	# Get the input direction.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")

	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Crouching.
	if Input.is_action_pressed("crouch"):
		# Ducking head.
		head.position.y = lerp(head.position.y, crouch_depth, delta * lerp_speed)
		standing_collision_shape.disabled = true
		crouching_collision_shape.disabled = false

		# Handle Sliding. Avoid sliding if the character stay still.
		if sprinting and input_dir != Vector2.ZERO:
			sliding = true
			slide_timer = slide_timer_max
			slide_direction = input_dir

		# Handle speed depending on crouching vs sliding.
		if sliding:
			# Decrease speed 
			current_speed = max(slide_speed * slide_timer, slide_speed_min)
		else:
			current_speed = crouch_speed

		walking = false
		sprinting = false
		crouching = true
	# Avoid leaving 'crouch' state if there's something above the character's head.
	elif !above_head_ray_cast.is_colliding():
		# Standing up.
		head.position.y = lerp(head.position.y, 0.0, delta * lerp_speed)
		standing_collision_shape.disabled = false
		crouching_collision_shape.disabled = true

		if Input.is_action_pressed("sprint"):
			current_speed = sprint_speed
			walking = false
			sprinting = true
		else:
			current_speed = walking_speed
			walking = true
			sprinting = false

		crouching = false
		sliding = false

	# Handle Free look. Enable if the character is sliding too.
	if Input.is_action_pressed("free-look"):
		# Tilting camera when looking back.
		camera_3d.rotation.z = deg_to_rad(neck.rotation.y * free_look_tilt_amount)
		# Update state.
		free_looking = true
	else:
		# Defaulting view to look ahead.
		neck.rotation.y = lerp(neck.rotation.y, 0.0, delta * lerp_speed)
		# Defaulting camera tilt.
		camera_3d.rotation.z = lerp(camera_3d.rotation.z, 0.0, delta * lerp_speed)
		# Update state.
		free_looking = false

	# Handle Jump. Checking above_head_ray_cast to avoid jumping under low ceilings.
	if Input.is_action_just_pressed("jump") and is_on_floor() and !above_head_ray_cast.is_colliding():
		velocity.y = jump_velocity

	# Handle the movement/deceleration.
	var target_direction = Vector3.ZERO
	if sliding:
		# Tilting camera 7 degrees.
		camera_3d.rotation.z = lerp(camera_3d.rotation.z, -deg_to_rad(7.0), delta * lerp_speed)
		# Force the character to go straight.
		target_direction = transform.basis * Vector3(slide_direction.x, 0, slide_direction.y).normalized()
	else:
		# Get direction from WASD inputs.
		target_direction = transform.basis * Vector3(input_dir.x, 0, input_dir.y).normalized()

	direction = lerp(direction, target_direction, delta * lerp_speed)

	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()
