extends Node

class GameContext:
	var open_tiles: Array[int] = []
	var selected_tiles: Array[int] = []
	var dice_count: int = 2
	var roll_sum: int = 0
	var score: int = 0
	var max_tiles: int = 9
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
