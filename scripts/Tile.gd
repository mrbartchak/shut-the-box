class_name Tile
extends TextureButton

# TODO: Add effect class later
@export var id: int
@export var value: int = 0

var _open: bool = true
var _default_texture: Texture
var _default_lbl_pos: Vector2
var _press_offset: Vector2 = Vector2(0, 3)

@onready var lbl: Label = $Label


func _ready() -> void:
	_connect_press_animation()
	_default_texture = texture_normal
	_default_lbl_pos = lbl.position

# ============== STATE ACCESSORS ==============
func is_open() -> bool:
	return _open


# ==============  STATE MUTATORS ==============
func open() -> void:
	_open = true
	set_enabled(true)
	modulate = Color(1, 1, 1)
	lbl.visible = true
	texture_normal = _default_texture

func close() -> void:
	_open = false
	set_enabled(false)
	modulate = Color(0.5, 0.5, 0.5)
	lbl.visible = false
	texture_normal = texture_pressed

func set_enabled(on: bool) -> void:
	disabled = !on

func set_value(v: int) -> void:
	value = v
	lbl.text = str(value)

func set_selected_visual(on: bool) -> void:
	texture_normal = texture_pressed if on else _default_texture
	# modulate = Color(1,1,1) if on else Color(0.7, 0.7, 0.7)
	lbl.position = _default_lbl_pos + _press_offset if on else _default_lbl_pos


# =============== UI CALLBACKS ================
func _pressed() -> void:
	if disabled or !_open:
		return
	Events.tile_pressed.emit(id)


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

func _connect_press_animation() -> void:
	if !lbl:
		push_warning("No label assigned for press animation")
		return
	
	button_down.connect(func():
		SoundManager.play_click()
		lbl.position = _default_lbl_pos + _press_offset
	)
	
	var reset := func(): lbl.position = _default_lbl_pos
	button_up.connect(reset)
	mouse_exited.connect(reset)
	focus_exited.connect(reset)
