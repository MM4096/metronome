class_name SettingsObject
extends Control

signal setting_changed(setting: String, value: Variant)

var display_name: String = ""
var settings_id: String = ""
var current_setting: Variant

func update_values(_display_name: String, _settings_id: String, _current_setting: Variant) -> void:
	display_name = _display_name
	settings_id = _settings_id
	current_setting = _current_setting
	after_update_values()

func after_update_values() -> void:
	pass
