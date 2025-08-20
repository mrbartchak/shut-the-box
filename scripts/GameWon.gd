extends CanvasLayer

@onready var bg: ColorRect = $Background
@onready var menu: PanelContainer = $Menu


#func _ready() -> void:
	#_reset_ui()
	#_play_fade()

func show_game_over() -> void:
	_reset_ui()
	_play_fade()


func _reset_ui() -> void:
	bg.modulate.a = 0.0
	menu.position.y = get_viewport().size.y + 100


func _play_fade() -> void:
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	
	tween.tween_property(bg, "modulate:a", 0.6, 2.0)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(menu, "position:y", get_viewport().get_visible_rect().size.y/2 - menu.size.y/2, 0.8)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT).set_delay(1.0)


func _on_replay_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/modes/ClassicMode.tscn")


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/screens/MainMenu.tscn")
