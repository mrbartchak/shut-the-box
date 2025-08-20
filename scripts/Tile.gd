class_name Tile
extends TextureButton

# TODO: Add effect class later
@export var id: int
@export var value: int = 0
@export var tile_size: Vector2 = Vector2(13, 20)

var _open: bool = true
var _default_texture: Texture
var _press_offset: Vector2 = Vector2(0, 3)

@onready var _normal_atlas: AtlasTexture = self.texture_normal.duplicate()
@onready var _pressed_atlas: AtlasTexture = self.texture_pressed.duplicate()

func _ready() -> void:
	_set_texture_regions()
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
	_set_texture_regions()

func set_selected_visual(on: bool) -> void:
	texture_normal = texture_pressed if on else _default_texture
	# modulate = Color(1,1,1) if on else Color(0.7, 0.7, 0.7)


# =============== UI ================
func _pressed() -> void:
	if disabled or !_open:
		return
	SoundManager.play_clack()
	Events.tile_pressed.emit(id)

func _set_texture_regions() -> void:
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

# =============== EFFECT HOOKS ================
#func trigger_selected_effect(gm: Node) -> void:
	#if effect and "on_selected" in effect:
		#effect.on_selected(gm, id)
#
#func trigger_resolve_effect(gm: Node) -> void:
	#if effect and "on_resolve" in effect:
		#effect.on_resolve(gm, id)


# ============== PRIVATE HELPERS ==============
#func _apply_open_visual(on: bool) -> void:
	## TODO: apply the visual
	#pass
