class_name ValueSlider
extends Control

signal value_changed(new_value: float)

@export var value_name: String
@export var default_value: int
@export_group("Slider")
@export var slider_min: int
@export var slider_max: int
@export var slider_step: int
@export var do_subdivisions: bool = true
@export_group("Config")
@export var label: Label
@export var slider: HSlider
@export var input: LineEdit

func _ready() -> void:
	slider.min_value = slider_min
	slider.max_value = slider_max
	slider.step = slider_step
	if do_subdivisions: 
		slider.tick_count = slider_max - slider_min + 1
	slider.value = default_value
	slider.value_changed.connect(_slider_value_changed)
	input.text_submitted.connect(_input_value_changed)
	_slider_value_changed(0)

func _slider_value_changed(_value: float) -> void:
	label.text = "%s: " % value_name
	input.text = str(slider.value)
	
	emit_signal("value_changed", slider.value)

func _input_value_changed(_value: String) -> void:
	if _value.is_valid_int():
		input.release_focus()
		slider.value = int(_value)
		_slider_value_changed(0)
	elif _value.is_valid_float():
		input.release_focus()
		slider.value = round(float(_value))
		_slider_value_changed(0)
	else:
		input.text = str(slider.value)
	
	emit_signal("value_changed", slider.value)

func get_slider_value() -> float:
	return slider.value
