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
	print("new round")
	# TODO: set tiles to base tile values
	# TODO: ctx open tiles = all tiles
	dice_manager.reset_active_dice()
	ctx.open_tiles = tile_manager.get_all_tile_ids()
	ctx.selected_tiles.clear()
	ctx.roll_sum = 0
	_emit_ctx()
	_change_state(ZenMode.State.TURN_START)


func _enter_turn_start() -> void:
	print("turn start")
	# TODO: Check if toggle dice
	# TODO: hint text and animations (wobble, press roll)
	ctx.selected_tiles.clear()
	_change_state(ZenMode.State.AWAIT_ROLL)


func _enter_await_roll() -> void:
	print("await roll")
	Events.roll_enabled_changed.emit(true)
	await Events.roll_pressed
	Events.roll_enabled_changed.emit(false)
	
	var sum: int = await dice_manager.roll_with_animation(ctx.rng)
	ctx.roll_sum = sum
	Events.dice_rolled.emit(ctx.roll_sum)
	_emit_ctx()
	if tile_manager.has_valid_combination(ctx.roll_sum, ctx.open_tiles):
		_change_state(ZenMode.State.CHOOSE_TILES)
	else:
		_change_state(ZenMode.State.BUST)


func _enter_choose_tiles() -> void:
	print("choose tiles")
	# TODO: reset tiles to be selected
	Events.flip_enabled_changed.emit(true)
	await Events.flip_pressed
	Events.flip_enabled_changed.emit(false)
	_change_state(ZenMode.State.VALIDATE_TILES)


func _enter_validate_tiles() -> void:
	print("validate tiles")
	var sum_selected: int = tile_manager.get_sum_tiles(ctx.selected_tiles)
	if sum_selected == ctx.roll_sum and ctx.selected_tiles.size() > 0:
		_change_state(ZenMode.State.RESOLVE)
	else:
		_change_state(ZenMode.State.CHOOSE_TILES)


func _enter_resolve() -> void:
	print("resolve")
	for key in ctx.selected_tiles:
		if ctx.open_tiles.has(key):
			ctx.open_tiles.erase(key)
			tile_manager.close_tile(key)
	ctx.selected_tiles.clear()
	Events.tiles_resolved.emit()
	_emit_ctx()
	
	if ctx.open_tiles.is_empty():
		_change_state(ZenMode.State.NINEDOWN)
	else:
		_change_state(ZenMode.State.TURN_START)


func _enter_bust() -> void:
	# TODO: Bust animation
	await get_tree().create_timer(0.3).timeout
	var bust_overlay := preload("res://scenes/screens/BustOverlay.tscn").instantiate()
	get_tree().current_scene.add_child(bust_overlay)
	await get_tree().create_timer(1.0).timeout
	get_tree().current_scene.remove_child(bust_overlay)
	_change_state(ZenMode.State.NEW_ROUND)


func _enter_ninedown() -> void:
	# TODO: Ninedown animation
	ctx.score += 1
	var ninedown_overlay := preload("res://scenes/screens/NinedownOverlay.tscn").instantiate()
	get_tree().current_scene.add_child(ninedown_overlay)
	await get_tree().create_timer(2.0).timeout
	get_tree().current_scene.remove_child(ninedown_overlay)
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
