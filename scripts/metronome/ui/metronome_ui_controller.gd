class_name MetronomeUIController
extends Node

static var instance: MetronomeUIController

@export_group("Sliders")
@export var beat_count_slider: ValueSlider
@export var subsection_count_slider: ValueSlider
@export var metronome_slider: ValueSlider
@export_group("Beat Section")
@export var beat_container: GridContainer
@export var beat_prefab: PackedScene
@export_group("Buttons")
@export var start_button: Button
@export var tap_tempo_button: Button

var current_beat: int = 0
var beat_items: Array[Beat] = []

func _ready() -> void:
	if instance == null:
		instance = self
	elif instance != self:
		queue_free()
	
	beat_count_slider.value_changed.connect(update_beat_count)
	subsection_count_slider.value_changed.connect(update_subsection_count)
	metronome_slider.value_changed.connect(update_bpm)
	update_beat_count(4)
	update_subsection_count(1)
	update_bpm(60)
	Metronome.instance.beat_progressed.connect(beat_progressed)
	
	start_button.pressed.connect(toggle_metronome)
	tap_tempo_button.pressed.connect(tap_tempo)

func update_beat_count(new_count: float) -> void:
	new_count = int(new_count)
	Metronome.instance.total_beats = new_count
	for i in beat_items:
		i.queue_free()
	beat_items.clear()
	for i in new_count:
		var new_prefab = beat_prefab.instantiate()
		if new_prefab is Beat:
			beat_container.add_child(new_prefab)
			new_prefab.set_color(Metronome.BeatType.NONE)
			beat_items.append(new_prefab)

func update_subsection_count(subsection: float) -> void:
	subsection = int(subsection)
	Metronome.instance.total_subsections = subsection

func update_bpm(tempo: float) -> void:
	Metronome.instance.tempo = tempo

func beat_progressed(beat: int, beat_type: int) -> void:
	for i in beat_items:
		i.set_color(0)
	if beat >= len(beat_items):
		return
	beat_items[beat].set_color(beat_type)

func toggle_metronome() -> void:
	var set_active: bool = !Metronome.instance.is_active
	start_button.text = "Start" if !set_active else "Stop"
	if set_active:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	Metronome.instance.start_metronome(set_active)

func tap_tempo() -> void:
	if len(taps) > 0:
		var last_tap: float = taps[len(taps) - 1]
		if tap_count > (last_tap * 3) and last_tap != 0:
			taps.clear()
			print("Clearing!")
			tap_count = 0
			return
		else:
			taps.append(tap_count)
			tap_count = 0
	else:
		tap_count = 0
		taps.append(0)
		return
	
	if len(taps) < 4:
		return
	
	var average: float = 0
	for i in taps:
		average += i
	average = average / (len(taps) - 1)
	metronome_slider.slider.value = 60 / average
	taps.remove_at(0)
	#update_bpm(60 / average)

var taps: Array[float] = []
var tap_count: float = 0
func _process(delta: float) -> void:
	tap_count += delta
