extends Control

@onready var game_manager: ZenMode = $"../GameManager"
# LABELS
@onready var _ninedown_total: Label = $HUD/TopBar/NinedownTotal
@onready var _roll_total: Label = $HUD/Overlay/RollTotal
# BUTTONS
@onready var _menu_btn: TextureButton = $HUD/TopBar/MenuButton
@onready var _roll_btn: TextureButton = $BoardFrame/Board/ActionBar/RollButton
@onready var _flip_btn: TextureButton = $BoardFrame/Board/ActionBar/FlipButton
# PARTICLES
@onready var _pop_particles: GPUParticles2D = $HUD/Overlay/PopParticles

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	_connect_ui_update()
	_connect_roll_btn_signals()
	_connect_flip_btn_signals()
	_connect_hud_signals()


# ==============   UI UPDATE     =============
func _connect_ui_update() -> void:
	game_manager.ui_update.connect(_on_ui_update)

func _on_ui_update(ctx: Constants.GameContext) -> void:
	_ninedown_total.text = str(ctx.score).pad_zeros(3)


# ===============     HUD       ==============
func _connect_hud_signals() -> void:
	_menu_btn.pressed.connect(_on_menu_btn_pressed)
	Events.dice_rolled.connect(_on_dice_rolled)
	Events.tiles_resolved.connect(_on_tiles_resolved)

func _on_menu_btn_pressed() -> void:
	SoundManager.play_click()
	await get_tree().create_timer(0.05).timeout
	get_tree().change_scene_to_file("res://scenes/screens/MainMenu.tscn")

func _on_dice_rolled(total: int) -> void:
	_roll_total.text = "%d" % total
	_roll_total.pivot_offset = (_roll_total.size/2)
	_roll_total.modulate = _get_roll_color(total)
	_pop_particles.modulate = _get_roll_color(total)
	_pop_in(_roll_total)

func _on_tiles_resolved() -> void:
	_pop_out(_roll_total)

# ===============  Roll Button  ==============
func _connect_roll_btn_signals() -> void:
	Events.roll_enabled_changed.connect(_on_roll_enabled_changed)
	_roll_btn.pressed.connect(_on_roll_pressed)

func _on_roll_enabled_changed(enabled: bool) -> void:
	_roll_btn.disabled = !enabled

func _on_roll_pressed() -> void:
	SoundManager.play_click()
	Events.roll_pressed.emit()


# ===============  Flip Button  ==============
func _connect_flip_btn_signals() -> void:
	Events.flip_enabled_changed.connect(_on_flip_enabled_changed)
	_flip_btn.pressed.connect(_on_flip_pressed)

func _on_flip_enabled_changed(enabled: bool) -> void:
	_flip_btn.disabled = !enabled

func _on_flip_pressed() -> void:
	SoundManager.play_click()
	Events.flip_pressed.emit()


# ==============  ANIMATIONS   ===============
func _pop_in(target: CanvasItem, up_scale: float = 2.0) -> void:
	target.visible = true
	target.scale = Vector2(0.1, 0.1)
	target.modulate.a = 0.0
	
	var tween: Tween = get_tree().create_tween()
	
	tween.chain().tween_property(target, "scale", Vector2(up_scale, up_scale), 0.2) \
		.from(Vector2(0.2, 0.2)).set_trans(Tween.TRANS_BACK).set_ease(tween.EASE_OUT)
	tween.parallel().tween_property(target, "modulate:a", 1.0, 0.2) \
		.from(0.0)
	
	tween.chain().tween_property(target, "scale", Vector2(1.0, 1.0), 0.2) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)

func _pop_out(target: CanvasItem) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(target, "scale", Vector2.ONE * 1.2, 0.25)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(target, "scale", Vector2.ZERO, 0.02) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.finished.connect(func():
		_pop_particles.global_position = target.global_position
		_pop_particles.restart()
		_pop_particles.emitting = true
		target.visible = false
		target.scale = Vector2.ONE
		SoundManager.play_pop()
	)

# ==============    HELPERS   =====================
func _get_roll_color(value: int) -> Color:
	var max_val = 2
	var min_val = 12
	var t = float(value - min_val) / float(max_val - min_val)
	var cool_hue: float = 0.75
	var hot_hue: float = 0.0
	var hue = lerp(hot_hue, cool_hue, clamp(t, 0.0, 1.0))
	return Color.from_hsv(hue, 0.4, 1.0)
