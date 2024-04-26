extends Control

@onready var seconds_label = $MarginContainer/HBoxContainer/Seconds
@onready var milliseconds_label = $MarginContainer/HBoxContainer/Milliseconds

var time: float = 0.0
var seconds_value: float = 0.0
var milliseconds_value: float = 0.0

func _ready():
	stop()

func _process(delta):
	time += delta
	seconds_value = fmod(time, 60)
	milliseconds_value = fmod(time, 1) * 100
	seconds_label.text = "%02d." % seconds_value
	milliseconds_label.text = "%03d" % milliseconds_value

func start() -> void:
	time = 0.0
	set_process(true)

func stop() -> void:
	set_process(false)

func get_time_formated():
	return "%02d.%03d" % [seconds_value, milliseconds_value]
