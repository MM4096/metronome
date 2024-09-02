class_name SettingsDropdown
extends SettingsObject

@export var option_name: Label
@export var dropdown: OptionButton

var options: Array[String]

func _ready() -> void:
	dropdown.item_selected.connect(_item_selected)
	after_update_values()

func after_update_values() -> void:
	option_name.text = display_name
	dropdown.clear()
	for i in len(options):
		dropdown.add_item(options[i], i)
	dropdown.select(int(current_setting))

func _item_selected(index: int) -> void:
	current_setting = index
	setting_changed.emit(settings_id, current_setting)
