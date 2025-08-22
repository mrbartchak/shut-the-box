class_name DiceManager
extends Node

@export var _dice: Array[Die] = []
var _active_dice: Array[Die] = []

func roll_sum(rng: RandomNumberGenerator) -> int:
	var total := 0
	for d: Die in _dice:
		total += d.roll(rng)
	print(total)
	return total

func reset_active_dice() -> void:
	if _dice.size() >= 2:
		_active_dice = [_dice[0], _dice[1]]
	elif _dice.size() == 1:
		_active_dice = [_dice[0]]
	else:
		_active_dice.clear()
