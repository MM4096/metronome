class_name Metronome
extends Node

signal beat_progressed(current_beat: int, level: BeatType)

static var instance: Metronome = null

enum BeatType {
	NONE,
	HALF,
	NORMAL,
	ACCENT,
}

var total_beats: int
var total_subsections: int
var tempo: float
var is_active: bool = false

var current_beat: int
var current_subsection: int
var count: float

func _init() -> void:
	if instance == null:
		instance = self
	elif instance != self:
		queue_free()

func _process(delta: float) -> void:
	if !is_active: return
	count -= delta
	if count <= 0:
		# progress subsection
		current_subsection += 1
		if current_subsection >= total_subsections:
			current_beat += 1
			current_subsection = 0
			if current_beat >= total_beats:
				# beat accented
				current_beat = 0
				
				emit_signal("beat_progressed", current_beat, 
							BeatType.ACCENT if Settings.instance.get_setting("accent_first", true) else BeatType.NORMAL)
			else:
				# beat normal
				emit_signal("beat_progressed", current_beat, BeatType.NORMAL)
		else:
			# beat subsection
			emit_signal("beat_progressed", current_beat, BeatType.HALF)
		
		var beat_time = 60 / tempo
		count = beat_time / total_subsections

func start_metronome(start: bool = true) -> void:
	is_active = start
	current_beat = total_beats
	current_subsection = total_subsections
