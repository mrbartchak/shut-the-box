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
	VALIDATE_TILES,
	RESOLVE,
	BUST,
	NINEDOWN,
}

var ctx: Constants.GameContext = Constants.GameContext.new()
var _state: State = State.GAME_INIT
@onready var dice_manager: DiceManager = $DiceManager
@onready var tile_manager: TileManager = $TileManager

func _ready() -> void:
	tile_manager.tile_pressed.connect(_on_tile_pressed)
	call_deferred("_change_state", ZenMode.State.GAME_INIT)


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
		State.VALIDATE_TILES: _enter_validate_tiles()
		State.RESOLVE: _enter_resolve()
		State.BUST: _enter_bust()
		State.NINEDOWN: _enter_ninedown()


func _enter_game_init() -> void:
	# TODO: Check for game load
	dice_manager.reset_active_dice()
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
	dice_manager.reset_active_dice()
	ctx.open_tiles = tile_manager.get_all_tile_ids()
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
	
	var sum: int = await dice_manager.roll_with_animation(ctx.rng)
	ctx.roll_sum = sum
	_emit_ctx()
	_change_state(ZenMode.State.CHOOSE_TILES)


func _enter_choose_tiles() -> void:
	# TODO: If no combo --> BUST
	# TODO: listens for tile toggles --> updates ctx.selectedtiles
	# TODO: reset tiles to be selected     
	Events.flip_enabled_changed.emit(true)
	await Events.flip_pressed
	Events.flip_enabled_changed.emit(false)
	_change_state(ZenMode.State.VALIDATE_TILES)


func _enter_validate_tiles() -> void:
	# TODO: If selection valid --> RESOLVE
	# TODO: IF selection invalid --> CHOOSE_TIES
	###get sum of tiles selected (should be in ctx.selected_tiles)
	var sum := 0
	if sum == ctx.roll_sum:
		_change_state(ZenMode.State.RESOLVE)
	else:
		_change_state(ZenMode.State.CHOOSE_TILES)
	pass


func _enter_resolve() -> void:
	# TODO: commit selection to CTX
	# TODO: TURN_START or NINEDOWN
	pass


func _enter_bust() -> void:
	# TODO: Bust animation
	_change_state(ZenMode.State.NEW_ROUND)


func _enter_ninedown() -> void:
	# TODO: Ninedown animation
	# TODO: CTX.score ++
	_change_state(ZenMode.State.NEW_ROUND)


# =========================================================
# ===============          Helpers           ==============
# =========================================================

func _emit_ctx() -> void:
	tile_manager.update_from_ctx(ctx)
	self.ui_update.emit(ctx)

func _on_tile_pressed(tile_id: int) -> void:
	if _state != ZenMode.State.CHOOSE_TILES:
		return
	if tile_id in ctx.selected_tiles:
		ctx.selected_tiles.erase(tile_id)
	else:
		ctx.selected_tiles.append(tile_id)
	_emit_ctx()
