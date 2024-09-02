class_name SettingsToggle
extends SettingsObject

@export var check_button: CheckButton

func _ready() -> void:
	check_button.text = display_name
	check_button.toggled.connect(_button_pressed)

func _button_pressed(state: bool) -> void:
	current_setting = state
	setting_changed.emit(settings_id, current_setting)

func after_update_values() -> void:
	check_button.button_pressed = current_setting
