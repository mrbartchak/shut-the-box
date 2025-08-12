class_name TileManager
extends Node

@export var tile_scene: PackedScene
@export var tile_count: int = 9
@export var container: Container

var _tiles: Array[Tile] = []
var _open_tiles: Array[Tile] = []
var _selected_tiles: Array[Tile] = []


func _ready() -> void:
	_spawn_tiles()


func get_valid_combinations(total: int, tiles: Array[Tile] = _open_tiles.duplicate()) -> Array:
	print("\n")
	print(tiles)
	var results: Array = []
	_dfs(tiles, 0, [], 0, total, results)
	_print_combos(results)
	return results


func get_candidate_values(combos: Array) -> Array:
	var seen := {}
	var ret: Array = []
	for combo in combos:
		if combo == null:
			continue
		for tile: Tile in combo:
			if tile == null or not is_instance_valid(tile):
				continue
			var id := tile.get_instance_id()
			if not seen.has(id):
				seen[id] = true
				ret.append(tile)
	return ret


func enable_candidate_tiles(candidates: Array) -> void:
	var is_candidate := {}
	for tile: Tile in candidates:
		if tile != null and is_instance_valid(tile):
			is_candidate[tile.get_instance_id()] = true
	
	for tile: Tile in _open_tiles:
		if not is_instance_valid(tile):
			continue
		if is_candidate.has(tile.get_instance_id()):
			tile.set_visual(Tile.Visual.HIGHLIGHT)
			tile.set_interactive(true)


func get_selected_tiles() -> Array[Tile]:
	return _selected_tiles

func get_open_tiles() -> Array[Tile]:
	return _open_tiles

func clear_selected_tiles() -> void:
	_selected_tiles = []


func close_tiles(tiles: Array[Tile]) -> void:
	for tile: Tile in tiles:
		tile.set_visual(Tile.Visual.CLOSED)
		tile.set_interactive(false)
		if _open_tiles.has(tile):
			_open_tiles.erase(tile)
	



func _dfs(tiles: Array, i: int, acc: Array, sum: int, total: int, results: Array) -> void:
	if sum == total:
		results.append(acc.duplicate())
		return
	if sum > total or i >= tiles.size():
		return
	
	var tile: Tile = tiles[i]
	var val: int = tile.value
	
	acc.append(tile)
	_dfs(tiles, i + 1, acc, sum + val, total, results)
	
	acc.pop_back()
	_dfs(tiles, i + 1, acc, sum, total, results)

func _spawn_tiles() -> void:
	_clear_tiles()
	_open_tiles = []
	
	for i in range(tile_count):
		var t: Tile = tile_scene.instantiate() as Tile
		t.set_value(i + 1)
		t.clicked.connect(_on_tile_clicked)
		container.add_child(t)
		_tiles.append(t)
		_open_tiles.append(t)


func _clear_tiles() -> void:
	for t: Tile in _tiles:
		if is_instance_valid(t):
			t.queue_free()
	_tiles.clear()


func _close_tile(tile: Tile) -> void:
	if not is_instance_valid(tile): return
	if _open_tiles.has(tile): _open_tiles.erase(tile)
	tile.set_visual(Tile.Visual.CLOSED)


func _toggle_select_tile(tile: Tile) -> void:
	if !tile.selected:
		tile.selected = true
		tile.set_visual(Tile.Visual.SELECTED)
		if !_selected_tiles.has(tile):
			_selected_tiles.append(tile)
	else:
		tile.selected = false
		tile.set_visual(Tile.Visual.HIGHLIGHT)
		if _selected_tiles.has(tile):
			_selected_tiles.erase(tile)


func _on_tile_clicked(tile: Tile) -> void:
	_toggle_select_tile(tile)


func _print_combos(combos: Array) -> void:
	var ret: String = ""
	for combo in combos:
		var combo_string: String = "["
		for tile: Tile in combo:
			combo_string += str(tile.value)
		combo_string += "]"
		ret += combo_string
	print(ret)


func _refresh_visuals() -> void:
	for tile: Tile in _tiles:
		tile._apply_visuals()
