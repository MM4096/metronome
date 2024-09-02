class_name MetronomeAudio
extends Node

static var instance: MetronomeAudio

@export var accented_beat: AudioStream
@export var normal_beat: AudioStream
@export var half_beat: AudioStream

@export var stream_player: AudioStreamPlayer

func _ready() -> void:
	if instance == null:
		instance = self
	elif instance != self:
		queue_free()
	
	Metronome.instance.beat_progressed.connect(play_sound)

func play_sound(_beat: int, level: int) -> void:
	if level == 0:
		pass
	elif level == 1:
		stream_player.stream = half_beat
	elif level == 2:
		stream_player.stream = normal_beat
	elif level == 3:
		stream_player.stream = accented_beat
	stream_player.play()
