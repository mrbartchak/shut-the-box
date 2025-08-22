extends Control


func _ready() -> void:
	_set_version_label()

func _process(delta: float) -> void:
	play_dice_animation(delta)


func _on_start_button_pressed() -> void:
	await play_button_click()
	# SoundManager.stop_menu_theme()
	get_tree().change_scene_to_file("res://scenes/modes/ClassicMode.tscn")


func _on_options_button_pressed() -> void:
	await play_button_click()
	get_tree().change_scene_to_file("res://scenes/screens/OptionsMenu.tscn")


func _on_exit_button_pressed() -> void:
	await play_button_click()
	SoundManager.stop_menu_theme()
	get_tree().quit()


func _set_version_label() -> void:
	$VersionLabel.text = Constants.VERSION


func play_button_click() -> void:
	SoundManager.play_click()
	await get_tree().create_timer(0.05).timeout


func play_dice_animation(delta: float) -> void:
		$Die.rotation_degrees += 90 * delta
		$Die2.rotation_degrees -= 90 * delta
