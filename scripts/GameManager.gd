class_name GameManager
extends Node

signal ui_update(ctx: Constants.GameContext)
signal ui_message(text: String)

enum State {
	GAME_INIT,
	NEW_GAME,
	NEW_ROUND,
	TURN_START,
	AWAIT_ROLL,
	CHOOSE_TILES,
	RESOLVE,
	BUST,
	SCORE,
	NINE_DOWN,
}

var ctx: Constants.GameContext = Constants.GameContext.new()
var _state: State = State.GAME_INIT

@onready var dice_manager: DiceManagerDepreciated = $"../DiceManager"
@onready var tile_manager: TileManager = $"../TileManager"

func _ready() -> void:
	_connect_signals()
	await get_tree().process_frame
	_change_state(State.GAME_INIT)

# =========================================================
# ===============       STATE ROUTER         ==============
# =========================================================

func _change_state(next: State) -> void:
	_state = next
	Events.state_changed.emit(State.keys()[_state])
	match _state:
		State.GAME_INIT: _enter_game_init()
		State.NEW_GAME: _enter_new_game()
		State.NEW_ROUND: _enter_new_round()
		State.TURN_START: _enter_turn_start()
		State.AWAIT_ROLL: _enter_await_roll()
		State.CHOOSE_TILES: _enter_choose_tiles()
		State.RESOLVE: _enter_resolve()
		State.BUST: _enter_bust()
		State.SCORE: _enter_score()
		State.NINE_DOWN: _enter_nine_down()

# -------------------- GAME_INIT --------------------
func _enter_game_init() -> void:
	# load rules, set tile range, customize settings, etc
	ctx.max_tiles = 9
	_emit_ctx()
	_change_state(State.NEW_GAME)

# -------------------- NEW_GAME -------------------
func _enter_new_game() -> void:
	# Fresh session/run
	get_tree().paused = false
	ctx.score = 0
	ctx.rng.randomize()
	_emit_ctx()
	_change_state(State.NEW_ROUND)

# -------------------- NEW_ROUND -------------------
func _enter_new_round() -> void:
	# Reset *round* state, still in same session/run
	tile_manager.set_tile_values(Constants.base_tile_values)
	ctx.open_tiles = tile_manager.get_all_tile_ids()
	ctx.selected_tiles = []
	ctx.roll_sum = 0
	_emit_ctx()
	_change_state(State.TURN_START)

# -------------------- TURN_START -------------------
func _enter_turn_start() -> void:
	var max_open_val: int = tile_manager.get_max_tile_value(ctx.open_tiles)
	ctx.dice_count = 1 if (max_open_val <= 6) else 2
	ctx.selected_tiles.clear()
	_emit_ctx()
	_change_state(State.AWAIT_ROLL)

# -------------------- AWAIT_ROLL -------------------
func _enter_await_roll() -> void:
	Events.roll_enabled_changed.emit(true)
	await Events.roll_pressed
	Events.roll_enabled_changed.emit(false)
	var sum: int = 0
	if ctx.dice_count == 1:
		sum = await dice_manager.roll_one()
	else:
		sum = await dice_manager.roll_all()
	ctx.roll_sum = sum
	_emit_ctx()
	
	if _has_valid_move(sum):
		_change_state(State.CHOOSE_TILES)
	else:
		_change_state(State.BUST)

# -------------------- CHOOSE_TILES ------------------
func _enter_choose_tiles() -> void:
	Events.flip_enabled_changed.emit(true)
	await Events.flip_pressed
	Events.flip_enabled_changed.emit(false)
	_validate_tiles()
	_emit_ctx()

func _on_tile_pressed(id: int) -> void:
	if _state != State.CHOOSE_TILES:
		return
	if ctx.selected_tiles.has(id):
		ctx.selected_tiles.erase(id)
	else:
		if ctx.open_tiles.has(id):
			ctx.selected_tiles.append(id)
	# TODO: Trigger select effect
	_emit_ctx()

func _validate_tiles() -> void:
	# checks if selection is a valid move
	if !State.CHOOSE_TILES:
		return
	var sum_selected := tile_manager.get_sum_tiles(ctx.selected_tiles)
	for key in ctx.selected_tiles:
		if not ctx.open_tiles.has(key):
			break
	if sum_selected == ctx.roll_sum and ctx.selected_tiles.size() > 0:
		_change_state(State.RESOLVE)
	else:
		_change_state(State.CHOOSE_TILES)


# ------------------------ RESOLVE ----------------------
func _enter_resolve() -> void:
	for key in ctx.selected_tiles:
		if ctx.open_tiles.has(key):
			ctx.open_tiles.erase(key)
			tile_manager.close_tile(key)
	ctx.selected_tiles.clear()
	_emit_ctx()
	
	Events.tiles_resolved.emit()
	
	if ctx.open_tiles.is_empty():
		_change_state(State.NINE_DOWN)
	else:
		_change_state(State.TURN_START)

# -------------------- BUST --------------------------
func _enter_bust() -> void:
	await get_tree().create_timer(0.5).timeout
	var game_over_scene := preload("res://scenes/screens/GameOver.tscn").instantiate()
	get_tree().current_scene.add_child(game_over_scene)
	game_over_scene.show_game_over()
	game_over_scene.process_mode = Node.PROCESS_MODE_ALWAYS

# -------------------- NINE_DOWN ------------------
func _enter_nine_down() -> void:
	Events.nine_down.emit()
	await get_tree().create_timer(0.5).timeout
	var game_won_scene := preload("res://scenes/screens/GameWon.tscn").instantiate()
	get_tree().current_scene.add_child(game_won_scene)
	game_won_scene.process_mode = Node.PROCESS_MODE_ALWAYS

# -------------------- SCORE -------------------------
func _enter_score() -> void:
	print("scoirng tiles hypothetically")

# =========================================================
# ===============          Helpers           ==============
# =========================================================

func _emit_ctx() -> void:
	self.ui_update.emit(ctx)
	tile_manager.paint_from_ctx(ctx.open_tiles, ctx.selected_tiles)

func _has_valid_move(total: int) -> bool:
	var valid_combos: Array = tile_manager.get_valid_combinations(total, ctx.open_tiles)
	return !valid_combos.is_empty()

func _connect_signals() -> void:
	ui_message.connect(func(text):
		$"../UiMessage".text = text
	)
	Events.tile_pressed.connect(_on_tile_pressed)
