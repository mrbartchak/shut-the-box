extends Control


func _on_start_button_pressed() -> void:
	await play_button_click()
	get_tree().change_scene_to_file("res://scenes/screens/Game.tscn")


func _on_options_button_pressed() -> void:
	await play_button_click()
	get_tree().change_scene_to_file("res://scenes/screens/OptionsMenu.tscn")


func _on_exit_button_pressed() -> void:
	await play_button_click()
	get_tree().quit()


func play_button_click() -> void:
	SoundManager.play_click()
	await get_tree().create_timer(0.05).timeout
