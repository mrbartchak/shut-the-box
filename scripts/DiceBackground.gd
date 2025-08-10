extends Control

@export var dice_sheet: Texture2D
@export var dice_count: int = 6
@export var tile_size: Vector2i = Vector2i(32, 32)
@export var tile_spacing: Vector2i = Vector2i(4, 4)
@export var columns: int = 10
@export var rows: int = 10
@export var scroll_speed: float = 30.0

var tiles := []
var dice_textures := []

func _ready():
	randomize()
	slice_dice_sheet()
	fill_grid()

func slice_dice_sheet():
	var dice_width = dice_sheet.get_width() / dice_count
	for i in range(dice_count):
		var region = Rect2(Vector2(i * dice_width, 0), Vector2(dice_width, dice_sheet.get_height()))
		var atlas = AtlasTexture.new()
		atlas.atlas = dice_sheet
		atlas.region = region
		dice_textures.append(atlas)

func fill_grid():
	for y in range(rows):
		for x in range(columns):
			var dice = TextureRect.new()
			dice.texture = dice_textures[randi() % dice_textures.size()]
			dice.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			dice.size = tile_size
			dice.position = Vector2(x * (tile_size.x + tile_spacing.x), y * (tile_size.y + tile_spacing.y))
			add_child(dice)
			tiles.append(dice)

func _process(delta):
	for tile in tiles:
		tile.position.y -= scroll_speed * delta

		# Wrap around when off screen
		if tile.position.y + tile_size.y + tile_spacing.y < 0:
			tile.position.y += rows * (tile_size.y + tile_spacing.y)
