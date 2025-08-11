extends Node


var _click_sound: AudioStream = preload("res://assets/sounds/448081__breviceps__tic-toc-click.wav")
var _pop_sound: AudioStream = preload("res://assets/sounds/683587__yehawsnail__bubble-pop.wav")


func play_click() -> void:
	if not _click_sound:
		push_warning("No click sound assigned in SoundManager")
		return
	var p := AudioStreamPlayer2D.new()
	p.stream = _click_sound
	add_child(p)
	p.finished.connect(func(): p.queue_free())
	p.play()


func play_pop() -> void:
	if not _pop_sound:
		push_warning("No pop sound assigned in SoundManager")
		return
	var p := AudioStreamPlayer2D.new()
	p.stream = _pop_sound
	p.pitch_scale = randf_range(0.9, 1.1)
	add_child(p)
	p.finished.connect(func(): p.queue_free())
	p.play()
