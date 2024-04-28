class_name PlayerController
extends CharacterBody3D

# Character state machine
@onready var motion_states_machine = $MotionStates
## TODO: @onready var camera_states_machine = $CameraStates

# Character nodes
@onready var neck = $Neck
@onready var head = $Neck/Head
@onready var camera_3d = $Neck/Head/Eyes/Camera3D

# Player properties
@export_category('Mouse')
@export() var mouse_sensitivity = 0.1

@export_category('Lerp')
@export() var lerp_speed = 15.0

@export_category('Gravity')
@export() var jump_peak_height = 2.0 # Meters
@export() var jump_peak_time = 0.35 # Seconds
@export() var jump_drop_time = 0.30 # Seconds
var jump_gravity = (2.0 * jump_peak_height) / pow(jump_peak_time, 2.0)
var fall_gravity = (2.0 * jump_peak_height) / pow(jump_drop_time, 2.0)

@export_category('Free Look')
@export() var free_look_tilt_amount = 8.0

# Player state
var input_direction = Vector3.ZERO
var current_direction = Vector3.ZERO
var current_speed: float
var crouch_depth = 0.0 # Meters
var camera_tilt = 0.0 # Radians

func _process(delta: float) -> void:
	var state = motion_states_machine.get_current_state()
	state.update(delta)

func _physics_process(delta: float) -> void:
	var state = motion_states_machine.get_current_state()
	state.physics_update(delta)
	apply_character_physics(delta)

func _unhandled_input(event: InputEvent) -> void:
	var state = motion_states_machine.get_current_state()
	state.handle_input(event)

	if event is InputEventMouseMotion:
		# Looking left/right
		rotate_y(deg_to_rad( - 1 * mouse_sensitivity * event.relative.x))

		# Looking up/down
		head.rotate_x((deg_to_rad( - 1 * mouse_sensitivity * event.relative.y)))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad( - 85), deg_to_rad(85))

func apply_input_direction() -> void:
	var direction = Input.get_vector("left", "right", "forward", "backward")
	input_direction = transform.basis * Vector3(direction.x, 0, direction.y).normalized()

func apply_character_physics(delta: float) -> void:
	# Head height and Bobbing
	head.position.y = lerp(head.position.y, crouch_depth, delta * lerp_speed)

	# TODO: Neck rotation for free-looking
	# camera_3d.rotation.z = deg_to_rad(neck.rotation.y * free_look_tilt_amount)

	# Apply camera tilt
	camera_3d.rotation.z = lerp(camera_3d.rotation.z, camera_tilt, delta * lerp_speed)

	# Gravity
	if velocity.y > 0:
		velocity.y -= jump_gravity * delta
	else:
		velocity.y -= fall_gravity * delta

	# Direction and movement
	current_direction = lerp(current_direction, input_direction, delta * lerp_speed)

	if current_direction:
		velocity.x = current_direction.x * current_speed
		velocity.z = current_direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()
