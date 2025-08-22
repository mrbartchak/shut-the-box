@icon("res://assets/sprites/icons/nodes/die_node.png")
class_name StandardDie
extends Die

signal rolled(value: int)

var _sides: int = 6
var _face: int = 1
var _die_size: Vector2i = Vector2i(24, 24)
@onready var _sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	_set_face(_face)

func roll(rng: RandomNumberGenerator) -> int:
	return rng.randi_range(1, _sides)

func play_roll_animation() -> void:
	_start_spin_tween(8, 1.0)
	SoundManager.play_spin()

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
