class_name TileManager
extends Node

signal tile_pressed(tile_id: int)

@export var tile_container: NodePath
var _tiles: Dictionary = {}

func _ready() -> void:
	var container = get_node(tile_container)
	for child in container.get_children():
		if child is Tile:
			_tiles[child.id] = child
			child.tile_pressed.connect(_on_tile_pressed)


func get_all_tile_ids() -> Array[int]:
	var ids: Array[int] = []
	for id in _tiles.keys():
		ids.append(id)
	return ids


func get_sum_tiles(keys: Array[int]) -> int:
	if keys.is_empty():
		return 0
	var sum := 0
	for key in keys:
		var t: Tile = _tiles.get(key)
		sum += t.value
	return sum


func get_valid_combinations(total: int, ids: Array[int]) -> Array:
	var results: Array = []
	_dfs(ids, 0, [], 0, total, results)
	print(results)
	return results


func has_valid_combination(total: int, ids: Array[int]) -> bool:
	return !get_valid_combinations(total, ids).is_empty()


func close_tile(id: int) -> void:
	var t: Tile = _tiles[id]
	t.close()


func update_from_ctx(ctx: Constants.GameContext) -> void:
	for id in _tiles.keys():
		var tile: Tile = _tiles[id]
		if ctx.open_tiles.has(id):
			tile.open()
		else:
			tile.close()
			continue
		tile.set_selected_visual(ctx.selected_tiles.has(id))
		# TODO: add set_value from ctx.tile_values

# =========================================================
# ===============          Helpers           ==============
# =========================================================
func _on_tile_pressed(id: int) -> void:
	self.tile_pressed.emit(id)


func _dfs(keys: Array, i: int, acc: Array, sum: int, total: int, results: Array) -> void:
	if sum == total:
		results.append(acc.duplicate())
		return
	if sum > total or i == keys.size():
		return
	
	var val: int = _tiles[keys[i]].value
	
	# Include this tile
	acc.append(keys[i])
	_dfs(keys, i + 1, acc, sum + val, total, results)
	# Backtrack
	acc.pop_back()
	# Skip this tile
	_dfs(keys, i + 1, acc, sum, total, results)
