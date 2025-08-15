extends Node


var _menu_theme: AudioStream = preload("res://assets/sounds/8Bit Title Screen.mp3")
var _click_sound: AudioStream = preload("res://assets/sounds/448081__breviceps__tic-toc-click.wav")
var _pop_sound: AudioStream = preload("res://assets/sounds/683587__yehawsnail__bubble-pop.wav")

var _menu_player: AudioStreamPlayer2D


func play_menu_theme() -> void:
	if _menu_player and _menu_player.playing:
		return
	if not _menu_theme:
		push_warning("No menu theme assigned in SoundManager")
		return
	_menu_player =  AudioStreamPlayer2D.new()
	_menu_player.stream = _menu_theme
	add_child(_menu_player)
	_menu_player.play()

func stop_menu_theme() -> void:
	if _menu_player:
		_menu_player.stop()
		_menu_player.queue_free()
		_menu_player = null


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
