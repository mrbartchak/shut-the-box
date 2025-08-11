extends CanvasLayer
#test
@onready var menu_btn := $MenuButton
@onready var roll_btn := $RollButton
@onready var quit_btn := $QuitButton
@onready var highscore_lbl := $Highscore/Label
@onready var diceTotal_lbl := $DiceResults/Total
@onready var state_lbl: Label = $StateLabel


func _ready() -> void:
	Events.dice_rolled.connect(_on_dice_rolled)
	Events.state_updated.connect(_on_state_updated)
	
	menu_btn.pressed.connect(func():
		
		get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
	)
	roll_btn.pressed.connect(func():
		SoundManager.play_click()
		Events.roll_button_clicked.emit()
	)
	quit_btn.pressed.connect(func():
		get_tree().quit()
	)


func _on_dice_rolled(total: int) -> void:
	diceTotal_lbl.text = "%d" % total
	#_start_pop_tween(diceTotal_lbl)
	_pop_fade(diceTotal_lbl, str(total))
	


func _on_state_updated(state: Constants.GameState) -> void:
	state_lbl.text = str(Constants.GameState.keys()[state])


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
