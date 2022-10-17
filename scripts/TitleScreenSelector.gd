extends "res://scripts/BaseSelector.gd"

const SELECTABLE_TEXT: String = "SPACE\nTO SELECT"
const UNSELECTABLE_TEXT: String = "NOT\nSELECTABLE"


func _ready() -> void:
	indexes_arr = [
		ConstantsManager.START_INDEX, 
		ConstantsManager.RULES_PAGE_ONE_INDEX, 
		ConstantsManager.RULES_PAGE_TWO_INDEX, 
		ConstantsManager.QUIT_INDEX]


func set_to_start() -> void:
	selected_index = indexes_arr.find(ConstantsManager.START_INDEX)


# Override parent function
func selector_select_curr() -> void:
	if selected_sprite.frame == ConstantsManager.START_INDEX or \
		selected_sprite.frame == ConstantsManager.QUIT_INDEX:
		AudioController.play_ui_sound(AudioController.SELECT)
	.selector_select_curr()


# Override
func _update_selected_sprite() -> void:
	._update_selected_sprite()
	if selected_sprite.frame == ConstantsManager.START_INDEX or \
		selected_sprite.frame == ConstantsManager.QUIT_INDEX:
		action_label.text = SELECTABLE_TEXT
	else:
		action_label.text = UNSELECTABLE_TEXT
