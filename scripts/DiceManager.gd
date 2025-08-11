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


func roll_all() -> Array[int]:
	is_rolling = true
	var results: Array[int] = []
	if !dice:
		push_warning("No dice to roll")
		return []
	
	var finish_signals: Array = []
	for die: Die in dice:
		if die:
			die.play_roll_animation()
			finish_signals.append(die.roll_animation_finished)
			results.append(die.roll_value())
	
	for sig in finish_signals:
		await sig
	
	Events.dice_rolled.emit(_get_total(results))
	is_rolling = false
	return results


func _get_total(results: Array[int]) -> int:
	var total: int = 0
	for result: int in results:
		total += result
	return total
