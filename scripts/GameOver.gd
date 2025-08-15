extends CanvasLayer


func _on_replay_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/screens/Game.tscn")
	queue_free()
