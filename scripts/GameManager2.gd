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

func _ready() -> void:
	_connect_signals()
	await get_tree().process_frame
	_change_state(State.GAME_INIT)

# =========================================================
# ===============       STATE ROUTER         ==============
# =========================================================

func _change_state(next: State) -> void:
	_state = next
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
	ctx.score = 0
	ctx.rng.randomize()
	_emit_ctx()
	_change_state(State.NEW_ROUND)

# -------------------- NEW_ROUND -------------------
func _enter_new_round() -> void:
	# Reset *round* state, still in same session/run
	$"../TileManager"._spawn_tiles()
	ctx.open_tiles = $"../TileManager".get_open_tiles()
	ctx.selected_tiles = []
	ctx.roll_sum = 0
	_emit_ctx()
	_change_state(State.TURN_START)

# -------------------- TURN_START -------------------
func _enter_turn_start() -> void:
	var max_open_val: int = _get_max_tile_value(ctx.open_tiles)
	ctx.dice_count = 1 if (max_open_val <= 6) else 2
	ctx.selected_tiles.clear()
	_emit_ctx()
	_change_state(State.AWAIT_ROLL)

# -------------------- AWAIT_ROLL -------------------
func _enter_await_roll() -> void:
	print("im in await rihgt now!")
	Events.roll_enabled_changed.emit(true)
	await Events.roll_pressed
	var sum := 0
	var results: Array[int] = await $"../DiceManager".roll_all()
	for result in results:
		sum += result
	ctx.roll_sum = sum
	print("await roll: ", ctx.roll_sum)
	print("await roll: ", ctx.open_tiles)
	_emit_ctx()
	
	if _has_valid_move(ctx.open_tiles, ctx.roll_sum):
		_change_state(State.AWAIT_ROLL)
	else:
		_change_state(State.BUST)

# -------------------- CHOOSE_TILES ------------------
func _enter_choose_tiles() -> void:
	emit_signal("ui_message", "Select tiles")
	_emit_ctx()

func _validate_tiles() -> void:
	# checks if selection is a valid move
	var sum_selected := _sum_tiles(ctx.selected_tiles)
	for tile: Tile in ctx.selected_tiles:
		if not ctx.open_tiles.has(tile):
			break
	if sum_selected == ctx.roll_sum and ctx.selected_tiles.size() > 0:
		_change_state(State.RESOLVE)
	else:
		emit_signal("ui_message", "Invalid tile selection")  

# ------------------------ RESOLVE ----------------------
func _enter_resolve() -> void:
	for tile: Tile in ctx.selected_tiles:
		if ctx.open_tiles.has(tile):
			ctx.open_tiles.erase(tile)
	ctx.selected_tiles.clear()
	_emit_ctx()
	
	if ctx.open_tiles.is_empty():
		_change_state(State.NINE_DOWN)
	else:
		_change_state(State.TURN_START)

# -------------------- BUST --------------------------
func _enter_bust() -> void:
	print("bustingggggggg")

# -------------------- NINE_DOWN ------------------
func _enter_nine_down() -> void:
	print("nine down!")

# -------------------- SCORE -------------------------
func _enter_score() -> void:
	print("scoirng tiles hypothetically")

# =========================================================
# ===============          Helpers           ==============
# =========================================================

func _emit_ctx() -> void:
	self.ui_update.emit(ctx)

func _get_max_tile_value(tiles: Array[Tile]) -> int:
	if tiles.is_empty():
		return 0
	var max_val: int = tiles[0].value
	for tile in tiles:
		if tile.value > max_val:
			max_val = tile.value
	return max_val

func _has_valid_move(open_tiles: Array[Tile], target: int) -> bool:
	var valid_combos: Array = $"../TileManager".get_valid_combinations(target, open_tiles)
	return !valid_combos.is_empty()

func _sum_tiles(tiles: Array[Tile]) -> int:
	if tiles.is_empty():
		return 0
	var sum := 0
	for tile: Tile in tiles:
		sum += tile.value
	return sum

func _connect_signals() -> void:
	Events.select_button_pressed.connect(_validate_tiles)
