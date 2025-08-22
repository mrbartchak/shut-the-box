class_name DiceManager
extends Node2D

@onready var dice: Array[DieDepreciated] = []
var is_rolling: bool = false


func _ready() -> void:
	for child in get_children():
		if child is DieDepreciated:
			dice.append(child)


func roll_one() -> int:
	is_rolling = true
	var total: int = 0
	if !dice:
		push_warning("No dice to roll")
		return 0
		
	var die: DieDepreciated = dice[0]
	total = die.roll_value()
	await die.play_roll_animation()
	
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
	for die: DieDepreciated in dice:
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
