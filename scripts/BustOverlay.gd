extends CanvasLayer

@onready var bg: ColorRect = $Control/Background
@onready var icon: TextureRect = $Control/BustIcon

func _ready() -> void:
	show_overlay()

func show_overlay() -> void:
	_reset_ui()
	var tween: Tween = _play_fade()
	await tween.finished


func _reset_ui() -> void:
	bg.modulate.a = 0.0
	icon.position.y = get_viewport().size.y - 100


func _play_fade() -> Tween:
	var tween: Tween = create_tween().set_parallel(true)
	tween.tween_property(bg, "modulate:a", 0.8, 0.5)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(icon, "position:y", get_viewport().get_visible_rect().size.y/2 - icon.size.y/2, 0.5)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT).set_delay(1.0)
	return tween
