extends Node


var _click_sound: AudioStream = preload("res://assets/sounds/448081__breviceps__tic-toc-click.wav")


func play_click() -> void:
	if not _click_sound:
		push_warning("No click sound assigned in SoundManager")
		return
	var p := AudioStreamPlayer2D.new()
	p.stream = _click_sound
	add_child(p)
	p.finished.connect(func(): p.queue_free())
	p.play()
