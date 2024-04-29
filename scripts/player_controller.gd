class_name PlayerController
extends CharacterBody3D

# Character state machine
@onready var motion_state_machine = $MotionStates
@onready var camera_state_machine = $CameraStates

# Player properties
@export_category('Mouse')
@export() var mouse_sensitivity = 0.1

@export_category('Lerp')
@export() var lerp_speed = 15.0

@export_category('Gravity')
@export() var jump_peak_height = 2.0 # Meters
@export() var jump_peak_time = 0.35 # Seconds
@export() var jump_drop_time = 0.30 # Seconds

# Player state
var input_direction = Vector3.ZERO
var current_direction = Vector3.ZERO
var current_speed = 0.0
var current_crouch_depth = 0.0 # Meters
var current_camera_tilt = 0.0 # Radians
var current_bobbing_intensity = 0.0
var current_bobbing_index = 0.0

func _process(delta: float) -> void:
	motion_state_machine.get_current_state().update(delta)
	camera_state_machine.get_current_state().update(delta)

func _physics_process(delta: float) -> void:
	motion_state_machine.get_current_state().physics_update(delta)

func _unhandled_input(event: InputEvent) -> void:
	motion_state_machine.get_current_state().handle_input(event)
	camera_state_machine.get_current_state().handle_input(event)
