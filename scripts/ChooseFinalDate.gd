extends Node2D

signal date_succeeded
signal date_did_not_succeed

const SELECTION_TEXT_FORMAT: String = \
	"It's time... Mark your final\n" + \
	"choice with an X\n\n" + \
	"Coppo %s\n\n" + \
	"Ember %s\n\n" + \
	"Robbin %s\n\n" + \
	"Stoney %s\n\n" + \
	"Vandal %s\n\n"

const SELECTION_TEXT_ARGS: Array = [
	["X","","","",""],
	["","X","","",""],
	["","","X","",""],
	["","","","X",""],
	["","","","","X"],
]

var is_active: bool = false
var selected_option_index: int = 0
var correct_choice_character: Node2D

onready var letter_label: Label = $PaperTextureRect/LetterTextLabel
onready var pointing_hand: Sprite = $PointingHandSprite
onready var positions: Array = [
	$FirstOptionPosition,
	$SecondOptionPosition,
	$ThirdOptionPosition,
	$FourthOptionPosition,
	$FifthOptionPosition,
]


func _ready() -> void:
	_update_selection()


func _input(event: InputEvent) -> void:
	if is_active:
		if event.is_action_released("up"):
			_move_up()
		if event.is_action_released("down"):
			_move_down()
		if event.is_action_released("selector_select"):
			check_choice()
			is_active = false


func set_correct_choice_character(character: Node2D) -> void:
	correct_choice_character = character


func reset_hand() -> void:
	selected_option_index = 0
	_update_selection()


func check_choice() -> void:
	if is_instance_valid(correct_choice_character) and \
		correct_choice_character.character_name == \
		ConstantsManager.CHARACTER_NAMES[selected_option_index]:
		emit_signal("date_succeeded")
	else:
		emit_signal("date_did_not_succeed")


func _move_up() -> void:
	selected_option_index = \
		(selected_option_index + positions.size() - 1) % positions.size()
	_update_selection()


func _move_down() -> void:
	selected_option_index = (selected_option_index + 1) % positions.size()
	_update_selection()


func _update_selection() -> void:
	pointing_hand.position = positions[selected_option_index].position
	letter_label.text = \
		SELECTION_TEXT_FORMAT % SELECTION_TEXT_ARGS[selected_option_index]
