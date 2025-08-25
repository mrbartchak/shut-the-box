@icon("res://assets/sprites/icons/nodes/die_node.png")
class_name StandardDie
extends Die

var _value: int = 0
var _sides: int = 6
var _face: int = 1
var _die_size: Vector2i = Vector2i(24, 24)
@onready var _sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	_set_face(_value)

func roll(rng: RandomNumberGenerator) -> int:
	_value = rng.randi_range(1, _sides)
	return _value

func play_roll_animation() -> void:
	var spin_tween := _start_spin_tween(8, 1.0)
	SoundManager.play_spin()
	_set_face(_value)
	await spin_tween.finished
	_start_pop_tween()
	SoundManager.play_pop()
	self.roll_animation_completed.emit()

# ===================================================
# ============      Private Helpers       ===========
# ===================================================
func _set_face(n: int) -> void:
	_face = clampi(n, 1, _sides)
	
	var atlas := _sprite.texture as AtlasTexture
	if atlas:
		var region := atlas.region
		region.position.x = _die_size.x * (_face - 1)
		atlas.region = region

func _start_spin_tween(rotations: int, duration: float) -> Tween:
	var full_rotation: float = TAU * rotations
	var tween: Tween = create_tween()
	tween.tween_property(_sprite, "rotation", _sprite.rotation + full_rotation, duration)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	return tween

func _start_pop_tween() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(_sprite, "scale", Vector2(1.2, 1.2), 0.1)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(_sprite, "scale", Vector2(1.0, 1.0), 0.1)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
