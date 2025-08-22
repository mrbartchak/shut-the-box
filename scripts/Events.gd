extends Node

signal dice_rolled(total: int)
signal state_changed(new_state)
signal score_updated(new_score: int)
signal tiles_resolved()
signal nine_down()

#======== BUTTONS ========
signal roll_pressed()
signal select_button_pressed()
signal flip_pressed()
signal tile_pressed(id: int)
signal roll_enabled_changed(enabled: bool)
signal flip_enabled_changed(enabled: bool)
