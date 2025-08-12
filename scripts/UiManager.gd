class_name UiManager
extends CanvasLayer
#test
@onready var menu_btn := $MenuButton
@onready var roll_btn := $RollButton
@onready var select_btn := $SelectTileButton
@onready var quit_btn := $QuitButton
@onready var score_lbl := $Score/Label
@onready var diceTotal_lbl := $DiceResults/Total
@onready var state_lbl: Label = $StateLabel


func _ready() -> void:
	Events.dice_rolled.connect(_on_dice_rolled)
	Events.state_changed.connect(_on_state_updated)
	Events.score_updated.connect(_on_score_updated)
	Events.roll_enabled_changed.connect(_on_roll_enabled_changed)
	
	menu_btn.pressed.connect(func():
		get_tree().change_scene_to_file("res://scenes/screens/MainMenu.tscn")
	)
	roll_btn.pressed.connect(func():
		SoundManager.play_click()
		Events.roll_pressed.emit()
	)
	quit_btn.pressed.connect(func():
		get_tree().quit()
	)
	select_btn.pressed.connect(func():
		SoundManager.play_click()
		Events.select_button_pressed.emit()
	)


func _on_state_updated(state) -> void:
	state_lbl.text = str(Constants.GameState.keys()[state])


func _on_score_updated(new_score: int) -> void:
	var str: String = "%04d" % new_score
	score_lbl.text = str
	# _pop_fade($Score, "", 1.05)


func _on_dice_rolled(total: int) -> void:
	diceTotal_lbl.text = "%d" % total
	_pop_fade(diceTotal_lbl, str(total))

func _on_roll_enabled_changed(enabled: bool) -> void:
	print("roll enabled chagned")
	roll_btn.disabled = !enabled





# HELPERS
func disable_roll_btn(disabled: bool) -> void:
	roll_btn.disabled = disabled
func disable_select_btn(disabled: bool) -> void:
	select_btn.disabled = disabled

# ANIMATIONS
func _pop_fade(target: CanvasItem, text: String = "", up_scale: float = 1.2) -> void:
	if text != "" and target is Label:
		(target as Label).text = text
	
	target.visible = true
	target.scale = Vector2(0.2, 0.2)
	target.modulate.a = 0.0
	
	var tween: Tween = get_tree().create_tween()
	
	tween.chain().tween_property(target, "scale", Vector2(up_scale, up_scale), 0.2) \
		.from(Vector2(0.2, 0.2)).set_trans(Tween.TRANS_BACK).set_ease(tween.EASE_OUT)
	tween.parallel().tween_property(target, "modulate:a", 1.0, 0.2) \
		.from(0.0)
	
	tween.chain().tween_property(target, "scale", Vector2(1.0, 1.0), 0.2) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	# tween.parallel().tween_property(target, "modulate:a", 0.0, 0.2)
