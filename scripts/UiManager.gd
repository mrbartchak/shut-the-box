extends CanvasLayer

@onready var menu_btn: Button = $MenuButton
@onready var roll_btn: Button = $RollButton
@onready var quit_btn: Button = $QuitButton
@onready var total_lbl: Label = $TotalLabel
@onready var state_lbl: Label = $StateLabel
@onready var click_sound: AudioStreamPlayer2D = $ButtonClick


func _ready() -> void:
	Events.dice_rolled.connect(_on_dice_rolled)
	Events.state_updated.connect(_on_state_updated)
	
	menu_btn.pressed.connect(func():
		get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
	)
	roll_btn.pressed.connect(func():
		click_sound.play()
		Events.roll_button_clicked.emit()
	)
	quit_btn.pressed.connect(func():
		get_tree().quit()
	)


func _on_dice_rolled(total: int) -> void:
	total_lbl.text = str(total)


func _on_state_updated(state: Constants.GameState) -> void:
	state_lbl.text = str(Constants.GameState.keys()[state])
