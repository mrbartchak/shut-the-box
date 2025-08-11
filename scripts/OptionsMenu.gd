extends Control

@onready var back_btn := $BackButton


func _ready() -> void:
	_connect_signals()


func _connect_signals() -> void:
	back_btn.pressed.connect(func():
		get_tree().change_scene_to_file("res://scenes/screens/MainMenu.tscn")
	)
