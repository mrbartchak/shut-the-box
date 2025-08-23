class_name DiceManager
extends Node

@export var _dice: Array[Die] = []
var _active_dice: Array[Die] = []

func roll_with_animation(rng: RandomNumberGenerator) -> int:
	if !_active_dice:
		return 0
	
	var ret: int = 0
	var pending_rolls: Array = []
	for d: Die in _active_dice:
		ret += d.roll(rng)
		d.play_roll_animation()
		pending_rolls.append(d.roll_animation_completed)
	
	for sig in pending_rolls:
		await sig
	
	return ret


func reset_active_dice() -> void:
	if _dice.size() >= 2:
		_active_dice = [_dice[0], _dice[1]]
	elif _dice.size() == 1:
		_active_dice = [_dice[0]]
	else:
		_active_dice.clear()
