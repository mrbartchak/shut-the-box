class_name Tile
extends TextureButton

# TODO: Add effect class later
@export var id: int
@export var value: int = 0

var _open: bool = true

@onready var lbl: Label = $Label

# ============== STATE ACCESSORS ==============
func is_open() -> bool:
	return _open


# ==============  STATE MUTATORS ==============
func open() -> void:
	_open = true
	modulate = Color(0.7, 0.7, 0.7)
	lbl.visible = true
	# TODO: Apply Open Visual

func close() -> void:
	_open = false
	modulate = Color(0.2, 0.2, 0.2)
	lbl.visible = false
	# TODO: Apply Close Visual

func set_enabled(on: bool) -> void:
	disabled = !on

func set_value(v: int) -> void:
	value = v
	lbl.text = str(value)

func set_selected_visual(on: bool) -> void:
	modulate = Color(1,1,1) if on else Color(0.7, 0.7, 0.7)


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


# =========================================================
#                   OLD IMPLEMENTATION
# =========================================================
#class_name Tile
#extends TextureButton
#
#signal clicked(tile: Tile)
#
#enum Visual { OPEN, DIMMED, HIGHLIGHT, SELECTED, CLOSED }
#
#@export var value: int = 0
#@export var color_open: Color = Color(0.9, 0.9, 0.9)
#@export var color_dimmed: Color = Color(0.75, 0.75, 0.75)
#@export var color_highlight: Color = Color(1, 1, 1)
#@export var color_selected: Color = Color(0.5, 1, 0.5)
#@export var color_closed: Color = Color(0.5, 0.5, 0.5)
#
#var visual_mode: Visual = Visual.DIMMED
#var interactive: bool = false
#var selected: bool = false
#
#@onready var lbl: Label = $Label
#
#
#func _ready() -> void:
	#_connect_signals()
	#_refresh_label()
	#_apply_visuals()
	#_apply_interactivity()
#
## -------- Public API --------
#func set_visual(mode: Visual) -> void:
	#visual_mode = mode
	#_apply_visuals()
#
#func set_value(v: int) -> void:
	#value = v
	#_apply_visuals()
#
#func set_interactive(v: bool) -> void:
	#interactive = v
	#_apply_interactivity()
	#
#
## -------- Interaction --------
#func _pressed() -> void:
	#if interactive:
		#clicked.emit(self)
#
## -------- Internals --------
#func _refresh_label() -> void:
	#if is_instance_valid(lbl):
		#lbl.text = str(value)
#
#func _apply_visuals() -> void:
	#match visual_mode:
		#Visual.OPEN: modulate = color_open
		#Visual.DIMMED: modulate = color_dimmed
		#Visual.HIGHLIGHT: modulate = color_highlight
		#Visual.SELECTED: modulate = color_selected
		#Visual.CLOSED:
			#modulate = color_closed
			#texture_disabled = texture_pressed
			#lbl.text = ""
#
#func _apply_interactivity() -> void:
	#self.disabled = not interactive
	#self.focus_mode = Control.FOCUS_NONE if disabled else Control.FOCUS_ALL
#
#func _connect_signals() -> void:
	#var base_pos: Vector2 = lbl.position
	#
	#button_down.connect(func():
		#SoundManager.play_click()
		#lbl.position = base_pos + Vector2(0, 3)
	#)
	#button_up.connect(func():
		#lbl.position = base_pos
	#)
	#mouse_exited.connect(func():
		#lbl.position = base_pos
	#)
	#focus_exited.connect(func():
		#lbl.position = base_pos
	#)
	
	
	
	# new 
	#@export var lbl: Label
#@export var press_offset: Vector2 = Vector2(0, 3)
#
#func _connect_press_animation() -> void:
	#if !lbl:
		#push_warning("No label assigned for press animation")
		#return
	#var base_pos := lbl.position
	#
	#button_down.connect(func():
		#SoundManager.play_click()
		#lbl.position = base_pos + press_offset
	#)
	#
	#var reset := func(): lbl.position = base_pos
	#button_up.connect(reset)
	#mouse_exited.connect(reset)
	#focus_exited.connect(reset)
