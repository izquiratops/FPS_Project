extends CharacterBody3D

# Node references
@onready var state_machine = $StateMachine
@onready var head = $Neck/Head

# Player properties
@export_category('Mouse')
@export() var mouse_sensitivity = 0.1

@export_category('Jumping')
@export() var jump_height = 2.0 # Meters
@export() var jump_peak_time = 0.35 # Seconds
@export() var jump_drop_time = 0.30 # Seconds
var jump_gravity = (2.0 * jump_height) / pow(jump_peak_time, 2.0)
var fall_gravity = (2.0 * jump_height) / pow(jump_drop_time, 2.0)
var jump_velocity = jump_gravity * jump_peak_time

@export_category('Lerp')
@export() var lerp_speed = 15.0

# Player state
var current_direction = Vector3.ZERO
var current_speed: float
var crouch_depth = 0.0

func _process(delta: float) -> void:
	state_machine.update(delta)


func _physics_process(delta: float) -> void:
	state_machine.physics_update(delta)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Looking left/right.
		rotate_y(deg_to_rad(-1 * mouse_sensitivity * event.relative.x))
		# Looking up/down.
		head.rotate_x((deg_to_rad(-1 * mouse_sensitivity * event.relative.y)))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-85), deg_to_rad(85))

	state_machine.handle_input(event)


func get_input_direction() -> Vector3:
	var input_direction = Input.get_vector("left", "right", "forward", "backward")
	return transform.basis * Vector3(input_direction.x, 0, input_direction.y).normalized()


func apply_gravity(delta: float) -> void:
	if velocity.y > 0:
		velocity.y -= jump_gravity * delta
	else:
		velocity.y -= fall_gravity * delta


func apply_direction(delta: float, input_direction: Vector3) -> void:
	head.position.y = lerp(head.position.y, crouch_depth, delta * lerp_speed)

	current_direction = lerp(current_direction, input_direction, delta * lerp_speed)

	if current_direction:
		velocity.x = current_direction.x * current_speed
		velocity.z = current_direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()
