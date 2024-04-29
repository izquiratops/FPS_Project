class_name CameraState
extends State

@onready var player: PlayerController = $'../..'
@onready var state_machine: StateMachine = $'..'

@onready var neck: Node3D = $'../../Neck'
@onready var head: Node3D = $'../../Neck/Head'
@onready var camera_3d: Camera3D = $'../../Neck/Head/Eyes/Camera3D'
