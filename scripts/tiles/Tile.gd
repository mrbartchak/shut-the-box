@icon("res://assets/sprites/icons/nodes/tile_node.png")
class_name Tile
extends TextureButton

signal tile_pressed(id: int)

@export var id: int
@export var value: int = 0
@export var tile_size: Vector2 = Vector2(13, 20)

var _open: bool = true
var _default_texture: Texture

@onready var _normal_atlas: AtlasTexture = self.texture_normal.duplicate()
@onready var _pressed_atlas: AtlasTexture = self.texture_pressed.duplicate()


func _ready() -> void:
	_update_texture_regions()
	_default_texture = texture_normal


# ============== STATE ACCESSORS ==============
func is_open() -> bool:
	return _open


# ==============  STATE MUTATORS ==============
func open() -> void:
	_open = true
	set_enabled(true)
	modulate = Color(1, 1, 1)
	texture_normal = _default_texture

func close() -> void:
	_open = false
	set_enabled(false)
	modulate = Color(0.5, 0.5, 0.5)
	texture_normal = texture_pressed

func set_enabled(on: bool) -> void:
	disabled = !on

func set_value(v: int) -> void:
	value = v
	_update_texture_regions()

func set_selected_visual(on: bool) -> void:
	texture_normal = texture_pressed if on else _default_texture


# =============== UI ================
func _pressed() -> void:
	if disabled or !_open:
		return
	self.tile_pressed.emit(id)

func _on_button_down() -> void:
	SoundManager.play_clack()

func _update_texture_regions() -> void:
	if _normal_atlas:
		var r = _normal_atlas.region
		r.position.x = (value - 1) * tile_size.x
		_normal_atlas.region = r
		texture_normal = _normal_atlas
	
	if _pressed_atlas:
		var r = _pressed_atlas.region
		r.position.x = (value - 1) * tile_size.x
		_pressed_atlas.region = r
		texture_pressed = _pressed_atlas
