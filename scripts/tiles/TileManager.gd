class_name TileManager
extends Node

signal tile_selected(tile_id: int)
signal tile_deselected(tile_id: int)

@export var tile_container: NodePath
var _tiles: Dictionary = {}

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
