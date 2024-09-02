class_name ViewChanger
extends Control

static var instance: ViewChanger

@export var pages: Dictionary
@export_group("Light Settings")
@export var background: ColorRect
@export_color_no_alpha var dark_background: Color
@export_color_no_alpha var light_background: Color
@export var light_theme: Theme
@export var dark_theme: Theme

func _ready() -> void:
	if instance == null:
		instance = self
	elif instance != self:
		queue_free()
	
	change_screens("metronome")
	set_dark_mode(get_dark_mode())

var current_display_mode: bool = false
func _process(_delta: float) -> void:
	if get_dark_mode() != current_display_mode:
		set_dark_mode(get_dark_mode())
		current_display_mode = get_dark_mode()

func change_screens(new_screen: String) -> void:
	if pages.has(new_screen):
		for i in pages:
			get_node(i).visible = false
		get_node(pages[new_screen]).visible = true

func set_dark_mode(dark_mode: bool = true) -> void:
	self.theme = dark_theme if dark_mode else light_theme
	background.color = dark_background if dark_mode else light_background

func get_dark_mode() -> bool:
	var result: int = int(Settings.instance.get_setting("dark_mode", 0))
	if result == 0:
		return DisplayServer.is_dark_mode()
	else:
		return true if result == 1 else false
