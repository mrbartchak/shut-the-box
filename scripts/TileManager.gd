extends Node

@export var tile_scene: PackedScene
@export var tile_count: int = 9
@export var start_position: Vector2 = Vector2(50, 50)
@export var spacing: Vector2 = Vector2(90, 0)

var _tiles: Array[Tile] = []


func _ready() -> void:
	_spawn_tiles()


func _spawn_tiles() -> void:
	_clear_tiles()
	var pos:= start_position
	
	for i in range(tile_count):
		var t: Tile = tile_scene.instantiate() as Tile
		t.value = i + 1
		t.position = pos
		t.clicked.connect(_on_tile_clicked)
		add_child(t)
		_tiles.append(t)
	
	pos += spacing


func _clear_tiles() -> void:
	for t: Tile in _tiles:
		if is_instance_valid(t):
			t.queue_free()
	_tiles.clear()


func _on_tile_clicked(val: int) -> void:
	pass
