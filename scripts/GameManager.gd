extends Node

enum State {
	IDLE,
	GAME_INIT,
	TURN_START,
	AWAIT_ROLL,
	CHECK_MOVES,
	WAIT_FOR_MOVE,
	VALIDATE_MOVES,
	CONTINUE_OR_END,
	ROUND_WIN,
	ROUND_END
}


@onready var ui_manager: UiManager = $"../UI"
@onready var dice_manager: DiceManager = $"../DiceManager"
@onready var tile_manager: TileManager = $"../TileManager"
var current_state: State = State.IDLE
var score: int = 0
var turn_score: int = 0


func _ready() -> void:
	Events.roll_button_clicked.connect(_on_roll_button_clicked)
	Events.dice_rolled.connect(_on_dice_rolled)
	call_deferred("emit_state")
	call_deferred("start_game")


func start_game() -> void:
	_change_state(State.GAME_INIT)


func _change_state(next_state: State) -> void:
	current_state = next_state
	match current_state:
		State.GAME_INIT:
			_game_init()
		State.AWAIT_ROLL:
			_await_roll()
		State.CHECK_MOVES:
			_check_moves()


func _game_init() -> void:
	_change_state(State.AWAIT_ROLL)


func _await_roll() -> void:
	ui_manager.disable_roll_btn(false)


func _check_moves() -> void:
	var results: Array = tile_manager.get_valid_combinations(turn_score)
	var candidates: Array = tile_manager.get_candidate_values(results)
	tile_manager.enable_candidate_tiles(candidates)
	


# HELPERS
func emit_state():
	Events.state_changed.emit(current_state)


func _on_roll_button_clicked() -> void:
	if current_state != State.AWAIT_ROLL: return
	if dice_manager.is_rolling: return
	ui_manager.disable_roll_btn(true)
	await dice_manager.roll_all()
	_change_state(State.CHECK_MOVES)


func _on_dice_rolled(total: int) -> void:
	score += total
	turn_score = total
	Events.score_updated.emit(score)
