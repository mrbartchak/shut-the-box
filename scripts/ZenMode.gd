class_name ZenMode
extends Node

signal ui_update(ctx: Constants.GameContext)

enum State {
	GAME_INIT,
	NEW_GAME,
	NEW_ROUND,
	TURN_START,
	AWAIT_ROLL,
	CHOOSE_TILES,
	RESOLVE,
	BUST,
	NINEDOWN,
}

var ctx: Constants.GameContext = Constants.GameContext.new()
var _state: State = State.GAME_INIT

func _ready() -> void:
	pass


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
		State.NINEDOWN: _enter_ninedown()


func _enter_game_init() -> void:
	# TODO: Check for game load
	_change_state(ZenMode.State.NEW_GAME)


func _enter_new_game() -> void:
	# TODO: Reset run stats
	ctx.score = 0
	ctx.rng.randomize()
	_emit_ctx()
	_change_state(ZenMode.State.NEW_ROUND)


func _enter_new_round() -> void:
	# TODO: set tiles to base tile values
	# TODO: ctx open tiles = all tiles
	ctx.selected_tiles.clear()
	ctx.roll_sum = 0
	_emit_ctx()
	_change_state(ZenMode.State.TURN_START)


func _enter_turn_start() -> void:
	# TODO: Check if toggle dice
	# TODO: hint text and animations (wobble, press roll)
	ctx.selected_tiles.clear()
	_change_state(ZenMode.State.AWAIT_ROLL)


func _enter_await_roll() -> void:
	Events.roll_enabled_changed.emit(true)
	await Events.roll_pressed
	Events.roll_enabled_changed.emit(false)
	
	var sum := 0
	# TODO: Roll Dice
	ctx.roll_sum = sum
	_emit_ctx()
	
	if true: # TODO: _has_valid_move
		_change_state(ZenMode.State.CHOOSE_TILES)
	else:  _change_state(ZenMode.State.BUST)


func _enter_choose_tiles() -> void:
	# listens for tile toggles --> updates ctx.selectedtiles
	# listens for confirm selection
	pass


func _enter_resolve() -> void:
	# apply the selection and commit to ctx
	# all closed --> ninedown else turn start
	pass


func _enter_bust() -> void:
	# play bust animation
	# move to new round
	pass


func _enter_ninedown() -> void:
	# play ninedown animation
	# inc counter
	# move to new round
	pass


# =========================================================
# ===============          Helpers           ==============
# =========================================================

func _emit_ctx() -> void:
	self.ui_update.emit(ctx)
