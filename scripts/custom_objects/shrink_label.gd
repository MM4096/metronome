@tool
class_name ShrinkLabel
extends Label

@export var max_size: float = 32
@export var min_size: float = 8

var cached_size: Vector2 = Vector2.ZERO

func _ready():
	self.visibility_changed.connect(update_text_size)

func _process(_delta):
	if cached_size == self.size:
		return
	cached_size = self.size
	update_text_size()

func update_text_size():
	var max_width: float = self.size.x
	var max_height: float = self.size.y
	var font = get_theme_font("font")
	var current_size: float = max_size
	var string_size: Vector2 = Vector2.INF
	
	while string_size.x > max_width or string_size.y > max_height:
		string_size = font.get_string_size(self.text, HORIZONTAL_ALIGNMENT_LEFT, -1, current_size)
		if current_size <= min_size:
			break
		current_size -= 1
	
	self.add_theme_font_size_override("font_size", current_size)
