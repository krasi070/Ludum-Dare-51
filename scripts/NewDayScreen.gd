extends Sprite

signal started_game
signal exited_new_day_screen
signal exited_game_over_screen
signal date_succeeded
signal date_did_not_succeed

# New day text
const DAY_TEXT_FORMAT: String = "Morning of day %d"
const NEW_DAY_ACTION_TEXT: String = "PRESS SPACE TO DATE"
const HINT_TOP_LINE_TEXT: String = "Word around the cells is\n\n"
const HINT_LINE_FORMAT: String = "%s %s\n\n"
const HINT_NEW_LINES: String = "\n\n\n\n\n\n\n\n"
const HINT_BOTTOM_LINE_TEXT_VARIANTS: Array = [
	"\nLove you,\nGarbage Man", 
	"\nMiss you,\nGarbage Man",
	"\n\nG. Dog",
	"P.S. I heard we are having our annual\nTaco Tuesday next week!\nGarbage Man",
	"P.S. Have you seen my glasses?\nI must've lost them...\nBlind Garbage Man", 
]
# Game over text
const GAME_OVER_ACTION_TEXT: String = "PRESS SPACE\nTO GO TO TITLE SCREEN"
const GAME_OVER_TIMEOUT_PREFIX_TEXT: String = \
	"I told you they wouldn't like it if you\nwasted their time.\n\n"
const GAME_OVER_ALONE_TEXT: String = \
	"Sorry to tell you lil' bud but it appears\n" + \
	"that you didn't pick the cellmate who\n" + \
	"truly liked you most.\n\n" + \
	"Better luck next time!\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" + \
	"P.S. Maybe you and me can go on a\ndate sometime..."
const GAME_OVER_ALONE_TOP_MESSAGE: String = "The following day"

var is_new_day: bool = false
var is_game_over: bool = false

onready var title_screen_ui: Node2D = $TitleScreenUI
onready var choose_date_ui: Node2D = $ChooseDateUI
onready var new_day_ui: Node2D = $NewDayUI
onready var top_msg_label: Label = $NewDayUI/TopMessageLabel
onready var letter_label: Label = $NewDayUI/PaperTextureRect/LetterTextLabel
onready var action_label: Label = $NewDayUI/BarSprite/CallToActionLabel
onready var bar_sprite: Sprite = $NewDayUI/BarSprite


func _ready() -> void:
	show_title_screen_ui()
	title_screen_ui.connect(
		"started_game", 
		self, 
		"_on_title_screen_started_game")
	choose_date_ui.connect("date_succeeded", self, "_on_date_succeeded")
	choose_date_ui.connect(
		"date_did_not_succeed", 
		self, 
		"_on_date_did_not_succeed")


func _input(event: InputEvent) -> void:
	if event.is_action_released("selector_select"):
		if is_new_day:
			is_new_day = false
			emit_signal("exited_new_day_screen")
		elif is_game_over:
			is_game_over = false
			emit_signal("exited_game_over_screen")


func prepare_for_new_day(day: int, characters: Dictionary) -> void:
	_set_new_day_labels(day, characters)
	show_new_day_ui()


func enable_new_day_screen() -> void:
	is_new_day = true


func prepare_for_game_over(
	game_over_by_character: Node2D = null, 
	is_timeout: bool = false) -> void:
	_set_game_over_labels(game_over_by_character, is_timeout)
	show_new_day_ui()


func enable_game_over_screen() -> void:
	is_game_over = true


func prepare_for_title_screen() -> void:
	title_screen_ui.reset()
	show_title_screen_ui()


func enable_title_screen() -> void:
	title_screen_ui.enable()


func prepare_for_choose_date(correct_choice_character: Node2D) -> void:
	choose_date_ui.reset_hand()
	choose_date_ui.set_correct_choice_character(correct_choice_character)
	show_choose_date_ui()


func enable_choose_date() -> void:
	choose_date_ui.is_active = true


func show_new_day_ui() -> void:
	title_screen_ui.hide()
	choose_date_ui.hide()
	new_day_ui.show()


func show_title_screen_ui() -> void:
	title_screen_ui.show()
	choose_date_ui.hide()
	new_day_ui.hide()


func show_choose_date_ui() -> void:
	title_screen_ui.hide()
	choose_date_ui.show()
	new_day_ui.hide()


func _set_game_over_labels(
	character: Node2D, 
	is_timeout: bool) -> void:
	action_label.text = GAME_OVER_ACTION_TEXT
	if not is_instance_valid(character):
		top_msg_label.text = GAME_OVER_ALONE_TOP_MESSAGE
		letter_label.text = GAME_OVER_ALONE_TEXT
		return
	top_msg_label.text = character.game_over_top_message
	if is_timeout:
		letter_label.text = GAME_OVER_TIMEOUT_PREFIX_TEXT + \
			character.game_over_letter_message
	else:
		letter_label.text = character.game_over_letter_message


func _set_new_day_labels(day: int, characters: Dictionary) -> void:
	top_msg_label.text = DAY_TEXT_FORMAT % day
	action_label.text = NEW_DAY_ACTION_TEXT
	letter_label.text = HINT_TOP_LINE_TEXT
	for name in characters:
		letter_label.text += \
			HINT_LINE_FORMAT % \
			[name, characters[name].get_letter_status()]
	letter_label.text += HINT_NEW_LINES
	letter_label.text += _get_rand_variant()


func _get_rand_variant() -> String:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var rand_index: int = rng.randi() % HINT_BOTTOM_LINE_TEXT_VARIANTS.size()
	return HINT_BOTTOM_LINE_TEXT_VARIANTS[rand_index]


func _on_date_succeeded() -> void:
	# Yes, I agree, it's shit...
	emit_signal("date_succeeded")


func _on_date_did_not_succeed() -> void:
	# Yes, I agree, it's shit...
	emit_signal("date_did_not_succeed")


func _on_title_screen_started_game() -> void:
	# Yes, I agree, it's shit...
	emit_signal("started_game")
