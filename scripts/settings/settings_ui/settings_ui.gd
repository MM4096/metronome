class_name SettingsUI
extends Node

static var instance: SettingsUI

enum DisplayType {
	CHECKBUTTON,
	INPUT,
	DROPDOWN,
}

class Setting:
	var id: String
	var display: String
	var default_value: Variant
	var display_type: int
	var options: Array = []
	func _init(_id: String, _display: String, _default_value: Variant,
				_display_type: int, _options: Array[String] = []) -> void:
		self.id = _id
		self.display = _display
		self.default_value = _default_value
		self.display_type = _display_type
		self.options = _options

var default_settings: Array[Setting] = [
	Setting.new("dark_mode", "Dark Mode (EXPERIMENTAL)", 1, DisplayType.DROPDOWN, ["Same as System", "Dark", "Light"]),
	Setting.new("accent_first", "Accent First Beat", true, DisplayType.CHECKBUTTON),
	]

@export var settings_pane: VBoxContainer
@export_group("Input Presets")
@export var check_button: PackedScene
@export var option_button: PackedScene

func _ready() -> void:
	if instance == null:
		instance = self
	elif instance != self:
		queue_free()
	_update_settings()

func _update_settings() -> void:
	for i in default_settings:
		var default_value: Variant = i.default_value
		if Settings.instance.does_setting_exist(i.id):
			default_value = Settings.instance.get_setting(i.id)
		if i.display_type == DisplayType.CHECKBUTTON:
			var checkbutton = check_button.instantiate()
			if checkbutton is SettingsToggle:
				checkbutton.update_values(i.display, i.id, default_value)
				checkbutton.setting_changed.connect(_setting_changed)
				
				settings_pane.add_child(checkbutton)
		elif i.display_type == DisplayType.DROPDOWN:
			var optionbutton = option_button.instantiate()
			if optionbutton is SettingsDropdown:
				optionbutton.options = i.options
				optionbutton.update_values(i.display, i.id, default_value)
				optionbutton.setting_changed.connect(_setting_changed)
				
				settings_pane.add_child(optionbutton)


func _setting_changed(id: String, value: Variant) -> void:
	Settings.instance.set_setting(id, value)
