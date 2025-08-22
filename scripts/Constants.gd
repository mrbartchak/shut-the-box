extends Node

const VERSION = "0.1.0-alpha"

class GameContext:
	var open_tiles: Array[int] = []
	var selected_tiles: Array[int] = []
	var dice_count: int = 2
	var roll_sum: int = 0
	var score: int = 0
	var max_tiles: int = 9
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()

var base_tile_values: Dictionary = { 1:1, 2:2, 3:3, 4:4, 5:5, 6:6, 7:7, 8:8, 9:9 }
