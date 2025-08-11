class_name Die
extends Node2D

signal rolled()
signal roll_animation_finished()

@export var sides: int = 6
@export var rotation_count: int = 8
@export var roll_duration: float = 2.0

var value: int = 0

@onready var sprite: AnimatedSprite2D = $AnimatedDiceSprite
@onready var roll_sound: AudioStreamPlayer2D = $RollSound
@onready var pop_sound: AudioStreamPlayer2D = $PopSound


func roll_value() -> int:
	value = randi() % sides + 1
	self.rolled.emit()
	return value


func play_roll_animation() -> void:
	var tween = _start_spin_tween(rotation_count, roll_duration)
	roll_sound.play()
	
	var reveal_ratio: float = 0.5
	var cycle_duration: float = roll_duration * reveal_ratio
	
	await _cycle_faces(cycle_duration)
	_reveal_face()
	await tween.finished
	await _start_pop_tween()
	pop_sound.play()
	await pop_sound.finished
	self.roll_animation_finished.emit()


func _start_spin_tween(rotations: int, duration: float) -> Tween:
	var full_rotation: float = TAU * rotations
	var tween: Tween = get_tree().create_tween()
	
	tween.tween_property(
		sprite,
		"rotation",
		sprite.rotation + full_rotation,
		duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	return tween


func _cycle_faces(duration: float) -> void:
	var time_passed: float = 0.0
	var min_interval: float = 0.05
	var max_interval: float = 0.3
	
	while time_passed < duration:
		var progress: float = time_passed / duration
		var interval: float = lerp(min_interval, max_interval, progress)
		await  get_tree().create_timer(interval).timeout
		sprite.frame = randi() % sides
		time_passed += interval


func _start_pop_tween() -> void:
	var tween: Tween = get_tree().create_tween()
	
	tween.tween_property(
		sprite,
		"scale",
		Vector2(1.2, 1.2),
		0.1
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(
		sprite,
		"scale",
		Vector2(1.0, 1.0),
		0.1
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)


func _reveal_face() -> void:
	sprite.frame = value - 1
