class_name Tile
extends TextureButton

signal clicked(tile: Tile)

var value: int = 0
var is_open: bool = true
var is_selected: bool = false

@onready var lbl: Label = $Label


func _ready() -> void:
	_connect_signals()
	lbl.text = str(value)
	_update_appearance()


func open() -> void:
	is_open = true
	_update_appearance()


func close() -> void:
	is_open = false
	is_selected = false
	_update_appearance()


func select_tile() -> void:
	is_selected = true
	_update_appearance()


func unselect_tile() -> void:
	is_selected = false
	_update_appearance()


func _pressed() -> void:
	self.clicked.emit(self)


func _update_appearance() -> void:
	self.modulate = Color.WHITE if is_open else Color(0.5, 0.5, 0.5)
	self.disabled = not is_open


func _connect_signals() -> void:
	var base_pos: Vector2 = lbl.position
	
	button_down.connect(func():
		SoundManager.play_click()
		lbl.position = base_pos + Vector2(0, 3)
	)
	button_up.connect(func():
		lbl.position = base_pos
	)
	mouse_exited.connect(func():
		lbl.position = base_pos
	)
	focus_exited.connect(func():
		lbl.position = base_pos
	)
	
	
	
