extends Node3D

@onready var pause_menu_scene = $PauseMenu

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		handle_pause()


func handle_pause():
	# Pausing the game
	get_tree().paused = true
	# Show the mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	# Show the pause menu
	pause_menu_scene.show()


func handle_unpause():
	# Resume the game
	get_tree().paused = false
	# Hide the mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# Hide pause menu
	pause_menu_scene.hide()


func handle_quit():
	get_tree().quit()
