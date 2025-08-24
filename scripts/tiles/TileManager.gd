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
	var ret: Array[int] = []
	for key in _tiles.keys():
		ret.append(key)
	return ret


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


func _on_tile_pressed(id: int) -> void:
	self.tile_pressed.emit(id)
