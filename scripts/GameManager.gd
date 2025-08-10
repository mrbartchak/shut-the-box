extends Node


@onready var dice_manager: DiceManager = $"../DiceManager"
var current_state: Constants.GameState = Constants.GameState.WAITING_FOR_ROLL


func _ready() -> void:
	Events.roll_button_clicked.connect(_on_roll_button_clicked)
	call_deferred("emit_state")


func emit_state():
	Events.state_updated.emit(current_state)


func _on_roll_button_clicked() -> void:
	if !dice_manager.is_rolling:
		await dice_manager.roll_all()
