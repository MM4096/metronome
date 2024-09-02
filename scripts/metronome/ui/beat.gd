class_name Beat
extends TextureRect

@export_color_no_alpha var off: Color
@export_color_no_alpha var half_beat: Color
@export_color_no_alpha var normal_beat: Color
@export_color_no_alpha var accented_beat: Color
@export_group("Config")
@export var lerp_speed: float = 0.8

var target_color: Color
var fade_cooldown: float = 0.1

func _ready() -> void:
	target_color = off

func _process(delta: float) -> void:
	#self.self_modulate = lerp(self.self_modulate, target_color, lerp_speed * delta)
	self.self_modulate = target_color
	
	fade_cooldown -= delta
	if fade_cooldown <= 0:
		set_color(0)

func set_color(index: int) -> void:
	if index == 0:
		target_color = off
	elif index == 1:
		target_color = half_beat
	elif index == 2:
		target_color = normal_beat
	elif index == 3:
		target_color = accented_beat
	
	if index != 0:
		fade_cooldown = 60 / (Metronome.instance.tempo * Metronome.instance.total_subsections * 2)
