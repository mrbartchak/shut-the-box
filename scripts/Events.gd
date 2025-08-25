extends Node

signal dice_rolled(total: int)
signal tiles_resolved()

#======== BUTTONS ========
signal button_pressed()
signal roll_pressed()
signal roll_enabled_changed(enabled: bool)

signal flip_pressed()
signal flip_enabled_changed(enabled: bool)






signal state_changed(new_state)
signal nine_down()
signal select_button_pressed()
signal tile_pressed(id: int)
