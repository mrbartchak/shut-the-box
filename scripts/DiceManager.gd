class_name DiceManager
extends Node2D

@onready var dice: Array[Die] = []
var is_rolling: bool = false


func _ready() -> void:
	for child in get_children():
		if child is Die:
			dice.append(child)


#func roll_all() -> int:
	#is_rolling = true
	#var total: int = 0
	#for die: Die in dice:
		#var result: int = await die.roll()
		#total += result
		#print("rolled: ", result)
	#Events.dice_rolled.emit(total)
	#is_rolling = false
	#return total

func roll_all() -> Array[int]:
	is_rolling = true
	var results: Array[int] = []
	for die: Die in dice:
		var result: int = await die.roll()
		results.append(result)
		print("rolled: ", result)
	Events.dice_rolled.emit(get_total(results))
	is_rolling = false
	return results


func get_total(results: Array[int]) -> int:
	var total: int = 0
	for result: int in results:
		total += result
	return total
