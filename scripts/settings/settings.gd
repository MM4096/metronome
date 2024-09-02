class_name Settings
extends Node

static var instance: Settings

var settings: Dictionary

func _init() -> void:
	if instance == null:
		instance = self
	elif instance != self:
		queue_free()
	
	_get_settings()

func _create_directories() -> void:
	DirAccess.make_dir_recursive_absolute(OS.get_user_data_dir())

func _get_settings() -> void:
	_create_directories()
	var filepath = OS.get_user_data_dir().path_join("settings")
	if !FileAccess.file_exists(filepath):
		settings = {}
		return
	
	var file: FileAccess = FileAccess.open(filepath, FileAccess.READ)
	var contents = file.get_as_text()
	var parser: JSON = JSON.new()
	var data = JSON.parse_string(contents)
	settings = data

func _write_settings() -> void:
	_create_directories()
	var filepath = OS.get_user_data_dir().path_join("settings")
	var data: String = JSON.stringify(settings)
	var file: FileAccess = FileAccess.open(filepath, FileAccess.WRITE)
	file.store_string(data)

func get_setting(setting: String, default_value: Variant = "") -> Variant:
	if settings.has(setting):
		return settings[setting]
	return default_value

func does_setting_exist(setting: String) -> bool:
	return settings.has(setting)

func set_setting(setting: String, value: Variant) -> void:
	settings[setting] = value
	_write_settings()
