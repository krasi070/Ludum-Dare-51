extends Node2D

signal selected(selected_index)
signal selection_changed(selected_index)

var indexes_arr: Array
var selected_index: int = 0
var _is_active: bool = false

onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var selected_sprite: Sprite = $SelectedPictureSprite
onready var bar_sprite: Sprite = $BarSprite
onready var action_label: Label = $BarSprite/ActionLabel


func _input(event: InputEvent) -> void:
	if _is_active:
		if event.is_action_released("selector_left"):
			selector_go_left()
		if event.is_action_released("selector_right"):
			selector_go_right()
		if event.is_action_released("selector_select"):
			selector_select_curr()
		_update_selected_sprite()


func selector_go_left() -> void:
	selected_index = \
		(selected_index + indexes_arr.size() - 1) % \
		indexes_arr.size()
	AudioController.play_ui_sound(AudioController.SELECTOR_NAVIGATION)
	emit_signal("selection_changed", indexes_arr[selected_index])


func selector_go_right() -> void:
	selected_index = (selected_index + 1) % indexes_arr.size()
	AudioController.play_ui_sound(AudioController.SELECTOR_NAVIGATION)
	emit_signal("selection_changed", indexes_arr[selected_index])


func selector_select_curr() -> void:
	emit_signal("selected", indexes_arr[selected_index])


func set_active(val: bool) -> void:
	_is_active = val
	if _is_active:
		anim_player.play("pop")
	else:
		anim_player.play("vanish")
		yield(anim_player, "animation_finished")
	bar_sprite.visible = _is_active


func get_curr_selection_index() -> int:
	return indexes_arr[selected_index]


func _update_selected_sprite() -> void:
	selected_sprite.frame = indexes_arr[selected_index]
