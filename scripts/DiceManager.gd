class_name DiceManager
extends Node2D

@onready var dice: Array[Die] = []
var is_rolling: bool = false


func _ready() -> void:
	for child in get_children():
		if child is Die:
			dice.append(child)


#func roll_all() -> Array[int]:
	#is_rolling = true
	#var results: Array[int] = []
	#for die: Die in dice:
		#var result: int = await die.roll()
		#results.append(result)
		#Events.dice1_rolled
	#Events.dice_rolled.emit(get_total(results))
	#is_rolling = false
	#return results

func roll_one() -> int:
	is_rolling = true
	var total: int = 0
	if !dice:
		push_warning("No dice to roll")
		return 0
		
	var die: Die = dice[0]
	die.play_roll_animation()
	total = die.roll_value()
	
	Events.dice_rolled.emit(total)
	is_rolling = false
	return total

func roll_all() -> int:
	is_rolling = true
	var sum: int = 0
	if !dice:
		push_warning("No dice to roll")
		return 0
	
	var finish_signals: Array = []
	for die: Die in dice:
		if die:
			die.play_roll_animation()
			finish_signals.append(die.roll_animation_finished)
			sum += die.roll_value()
	
	for sig in finish_signals:
		await sig
	
	Events.dice_rolled.emit(sum)
	is_rolling = false
	return sum


func _get_total(results: Array[int]) -> int:
	var total: int = 0
	for result: int in results:
		total += result
	return total
