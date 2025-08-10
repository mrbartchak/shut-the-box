class_name Tile
extends Button

signal clicked(value: int)

var value: int = 0
var is_open: bool = true


func _ready() -> void:
	self.text = str(value)
	_update_appearance()


func open() -> void:
	is_open = true
	_update_appearance()


func close() -> void:
	is_open = false
	_update_appearance()


func _pressed() -> void:
	self.clicked.emit(value)


func _update_appearance() -> void:
	self.modulate = Color.WHITE if is_open else Color(0.5, 0.5, 0.5)
	self.disabled = not is_open
