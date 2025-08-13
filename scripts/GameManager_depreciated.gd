extends Node

enum State {
	IDLE,
	GAME_INIT,
	TURN_START,
	AWAIT_ROLL,
	CHECK_MOVES,
	WAIT_FOR_MOVE,
	VALIDATE_MOVE,
	PERFORM_MOVE,
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
var _current_tile_selection: Array[Tile] = []


func _ready() -> void:
	Events.roll_button_clicked.connect(_on_roll_button_clicked)
	Events.dice_rolled.connect(_on_dice_rolled)
	Events.select_button_pressed.connect(_on_select_button_pressed)
	call_deferred("emit_state")
	call_deferred("start_game")


func start_game() -> void:
	_change_state(State.GAME_INIT)


func _change_state(next_state: State) -> void:
	current_state = next_state
	match current_state:
		State.GAME_INIT:
			_game_init()
		State.TURN_START:
			_turn_start()
		State.AWAIT_ROLL:
			_await_roll()
		State.CHECK_MOVES:
			_check_moves()
		State.WAIT_FOR_MOVE:
			_wait_for_move()
		State.VALIDATE_MOVE:
			_validate_move()
		State.PERFORM_MOVE:
			_perform_move()
		State.CONTINUE_OR_END:
			_continue_or_end()


func _game_init() -> void:
	_change_state(State.TURN_START)


func _turn_start() -> void:
	
	_change_state(State.AWAIT_ROLL)


func _await_roll() -> void:
	ui_manager.disable_roll_btn(false)


func _check_moves() -> void:
	var results: Array = tile_manager.get_valid_combinations(turn_score)
	var candidates: Array = tile_manager.get_candidate_values(results)
	tile_manager.enable_candidate_tiles(candidates)
	_change_state(State.WAIT_FOR_MOVE)


func _wait_for_move() -> void:
	ui_manager.disable_select_btn(false)
	print("waiting for move")


func _validate_move():
	_current_tile_selection = tile_manager.get_selected_tiles()
	print(_current_tile_selection)
	var selected_sum: int = 0
	for tile: Tile in _current_tile_selection:
		selected_sum += tile.value
	tile_manager.clear_selected_tiles()
	tile_manager._refresh_visuals()
	if selected_sum == turn_score:
		_change_state(State.PERFORM_MOVE)
	else:
		_change_state(State.WAIT_FOR_MOVE)


func _perform_move() -> void:
	tile_manager.close_tiles(_current_tile_selection)
	_change_state(State.CONTINUE_OR_END)

func _continue_or_end() -> void:
	var open := tile_manager.get_open_tiles()
	if open != null and not open.is_empty():
		_change_state(State.AWAIT_ROLL)






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


func _on_select_button_pressed() -> void:
	if !State.WAIT_FOR_MOVE:
		return
	ui_manager.disable_select_btn(true)
	_change_state(State.VALIDATE_MOVE)
	
