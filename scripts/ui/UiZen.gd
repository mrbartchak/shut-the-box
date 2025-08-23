extends Control

@onready var _menu_btn: TextureButton = $HUD/HudRow/MenuButton
@onready var _roll_btn: TextureButton = $BoardFrame/Board/ActionBar/RollButton

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	_connect_roll_btn_signals()
	_connect_hud_signals()

# ===============     HUD       ==============
func _connect_hud_signals() -> void:
	_menu_btn.pressed.connect(_on_menu_btn_pressed)

func _on_menu_btn_pressed() -> void:
	SoundManager.play_click()

# ===============  Roll Button  ==============
func _connect_roll_btn_signals() -> void:
	Events.roll_enabled_changed.connect(_on_roll_enabled_changed)
	_roll_btn.pressed.connect(_on_roll_pressed)

func _on_roll_enabled_changed(enabled: bool) -> void:
	_roll_btn.disabled = !enabled

func _on_roll_pressed() -> void:
	SoundManager.play_click()
	Events.roll_pressed.emit()
