extends CharacterBody3D

# Player nodes.
@onready var neck = $Neck
@onready var head = $Neck/Head
@onready var eyes = $Neck/Head/Eyes
@onready var camera_3d = $Neck/Head/Eyes/Camera3D
@onready var standing_collision_shape = $StandingCollisionShape
@onready var crouching_collision_shape = $CrouchingCollisionShape
@onready var above_head_ray_cast = $AboveHeadRayCast
@onready var timer = $"../HUD/Timer"

# Movement states.
var walking = true
var sprinting = false
var crouching = false
var sliding = false
var free_looking = false

# Input vars.
var direction = Vector3.ZERO
const mouse_sensitivity = 0.1

# Speed vars.
var current_speed = 0.0
const walking_speed = 7.0
const sprint_speed = 10.0
const crouch_speed = 3.0

# Jumping vars.
@export_category('Jumping')
@export var jump_height: float = 1.3
@export var jump_peak_time: float = 0.35 # Seconds
@export var jump_drop_time: float = 0.30 # Seconds
var jump_gravity = (2.0 * jump_height) / pow(jump_peak_time, 2.0)
var fall_gravity = (2.0 * jump_height) / pow(jump_drop_time, 2.0)
var jump_velocity = jump_gravity * jump_peak_time

# Movement vars.
const lerp_speed = 15.0
const crouch_depth = -0.5
const free_look_tilt_amount = 8.0

# Slide vars.
var slide_timer = 0.0
var slide_direction = Vector2.ZERO
const slide_timer_max = 1.0
const slide_speed = 10.0
const slide_speed_min = 2.0

# Head bobbing vars.
const head_bobbing_sprinting_speed = 18.0
const head_bobbing_walking_speed = 12.0
const head_bobbing_crouching_speed = 8.0
const head_bobbing_sprinting_intensity = 0.1
const head_bobbing_walking_intensity = 0.07
const head_bobbing_crouching_intensity = 0.07
var head_bobbing_vector = Vector2.ZERO
var head_bobbing_index = 0.0
var head_bobbing_current_intensity = 0.0


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
		if velocity.y > 0:
			velocity.y -= jump_gravity * delta
		else:
			velocity.y -= fall_gravity * delta

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
			# Decrease speed over time.
			current_speed = max(slide_speed * slide_timer, slide_speed_min)
		else:
			current_speed = crouch_speed

		# Update state.
		walking = false
		sprinting = false
		crouching = true
	else:
		# Not holding 'C' cancels the slide
		sliding = false

		# The character is stuck in a really tiny place
		if is_on_floor() and above_head_ray_cast.is_colliding():
			current_speed = crouch_speed

			# Update state.
			walking = false
			sprinting = false
			crouching = true
		else:
			# Standing up.
			head.position.y = lerp(head.position.y, 0.0, delta * lerp_speed)
			standing_collision_shape.disabled = false
			crouching_collision_shape.disabled = true

			# Update state, not crouching anymore.
			crouching = false

			# Handle Sprint.
			if Input.is_action_pressed("sprint"):
				current_speed = sprint_speed
				walking = false
				sprinting = true
			# Handle Walking.
			else:
				current_speed = walking_speed
				walking = true
				sprinting = false

	# Handle Free look.
	if Input.is_action_pressed("free-look"):
		# Tilting camera to look back.
		camera_3d.rotation.z = deg_to_rad(neck.rotation.y * free_look_tilt_amount)

		# Update state.
		free_looking = true
	else:
		# Looking ahead as soon the character leaves free-looking state.
		neck.rotation.y = lerp(neck.rotation.y, 0.0, delta * lerp_speed)
		if sliding:
			# Tilting the camera a little bit while sliding.
			camera_3d.rotation.z = lerp(camera_3d.rotation.z, -deg_to_rad(5.0), delta * lerp_speed)
		else:
			camera_3d.rotation.z = lerp(camera_3d.rotation.z, 0.0, delta * lerp_speed)

		# Update state.
		free_looking = false

	# Handle Jump. Checking above_head_ray_cast to avoid jumping under low ceilings (you could be hurt).
	if Input.is_action_just_pressed("jump") and is_on_floor() and !above_head_ray_cast.is_colliding():
		velocity.y = jump_velocity
	
	# Handle head bobbing.
	if sprinting:
		head_bobbing_current_intensity = head_bobbing_sprinting_intensity
		head_bobbing_index += head_bobbing_sprinting_speed * delta
	elif walking:
		head_bobbing_current_intensity = head_bobbing_walking_intensity
		head_bobbing_index += head_bobbing_walking_speed * delta
	elif crouching:
		head_bobbing_current_intensity = head_bobbing_crouching_intensity
		head_bobbing_index += head_bobbing_crouching_speed * delta

	# Show head bobbing if the player is moving with their feet on the ground.
	if is_on_floor() and !sliding and input_dir != Vector2.ZERO:
		head_bobbing_vector.y = sin(head_bobbing_index)
		head_bobbing_vector.x = cos(head_bobbing_index * 0.5)
		var target_bobbing_y = head_bobbing_vector.y * head_bobbing_current_intensity
		eyes.position.y = lerp(eyes.position.y, target_bobbing_y, delta * lerp_speed)
		var target_bobbing_x = head_bobbing_vector.x * head_bobbing_current_intensity
		eyes.position.x = lerp(eyes.position.x, target_bobbing_x, delta * lerp_speed)

	# Handle the movement/deceleration.
	var target_direction = Vector3.ZERO
	if sliding:
		# Force straight direction.
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
