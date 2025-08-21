class_name UiManager
extends CanvasLayer
#test
@onready var menu_btn := $MenuButton
@onready var roll_btn := $RollButton
@onready var flip_btn := $FlipButton
@onready var diceTotal_lbl := $DiceResults/Total
@onready var state_lbl: Label = $StateLabel


func _ready() -> void:
	Events.dice_rolled.connect(_on_dice_rolled)
	Events.state_changed.connect(_on_state_updated)
	Events.roll_enabled_changed.connect(_on_roll_enabled_changed)
	Events.flip_enabled_changed.connect(_on_flip_enabled_changed)
	Events.nine_down.connect(_on_nine_down)
	Events.tiles_resolved.connect(_on_tiles_resolved)
	
	menu_btn.pressed.connect(func():
		get_tree().change_scene_to_file("res://scenes/screens/MainMenu.tscn")
	)
	roll_btn.pressed.connect(func():
		SoundManager.play_click()
		Events.roll_pressed.emit()
	)
	flip_btn.pressed.connect(func():
		SoundManager.play_click()
		Events.select_button_pressed.emit()
		Events.flip_pressed.emit()
	)


func _on_state_updated(state) -> void:
	state_lbl.text = str(state)


func _on_dice_rolled(total: int) -> void:
	diceTotal_lbl.text = "%d" % total
	_pop_fade(diceTotal_lbl, str(total))

func _on_roll_enabled_changed(enabled: bool) -> void:
	roll_btn.disabled = !enabled

func _on_flip_enabled_changed(enabled: bool) -> void:
	flip_btn.disabled = !enabled

func _on_nine_down() -> void:
	_pop_fade($TextureRect)

func _on_tiles_resolved() -> void:
	diceTotal_lbl.visible = false
	$TextureRect.visible = false

# HELPERS
func disable_roll_btn(disabled: bool) -> void:
	roll_btn.disabled = disabled
func disable_select_btn(disabled: bool) -> void:
	flip_btn.disabled = disabled

# ANIMATIONS
func _pop_fade(target: CanvasItem, text: String = "", up_scale: float = 1.8) -> void:
	if text != "" and target is Label:
		(target as Label).text = text
	
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
	# tween.parallel().tween_property(target, "modulate:a", 0.0, 0.2)
