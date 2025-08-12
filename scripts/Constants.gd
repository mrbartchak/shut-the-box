extends Node

enum GameState {
	IDLE,
	GAME_INIT,
	TURN_START,
	AWAIT_ROLL,
	CHECK_MOVES,
	WAIT_FOR_MOVE,
	VALIDATE_MOVE,
	PERFORM_MOVE,
	CONTINUE_OR_END,
	ROUND_WIN,
	ROUND_END
}

class GameContext:
	var open_tiles: Array[Tile] = []
	var selected_tiles: Array[Tile] = []
	var dice_count: int = 2
	var roll_sum: int = 0
	var score: int = 0
	var max_tiles: int = 9
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
