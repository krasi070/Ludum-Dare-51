extends Node2D

signal started_game

export(String, MULTILINE) var rules_page_one_text: String
export(String, MULTILINE) var rules_page_two_text: String
export(String, MULTILINE) var quit_text: String

onready var title_texture_rect: TextureRect = $TitleTextureRect
onready var paper_texture_rect: TextureRect = $PaperTextureRect
onready var letter_label: Label = $PaperTextureRect/LetterTextLabel
onready var title_screen_selector: Node2D = $TitleScreenSelector


func _ready() -> void:
	reset()
	enable()
	title_screen_selector.connect(
		"selection_changed", 
		self, 
		"_on_title_screen_selector_selection_changed")
	title_screen_selector.connect(
		"selected", 
		self, 
		"_on_title_screen_selector_selected")


func reset() -> void:
	title_screen_selector.set_to_start()
	_update_based_on_selection(
		title_screen_selector.get_curr_selection_index())


func enable() -> void:
	title_screen_selector.set_active(true)


func _show_rules(text: String) -> void:
	title_texture_rect.hide()
	paper_texture_rect.show()
	letter_label.text = text
	AudioController.play_sfx(AudioController.RUSTLE_PAPER)


func _show_start_screen() -> void:
	title_texture_rect.show()
	paper_texture_rect.hide()


func _show_quit_screen() -> void:
	title_texture_rect.hide()
	paper_texture_rect.show()
	letter_label.text = quit_text
	AudioController.play_sfx(AudioController.RUSTLE_PAPER)


func _update_based_on_selection(selected_index: int) -> void:
	if selected_index == ConstantsManager.START_INDEX:
		_show_start_screen()
	elif selected_index == ConstantsManager.RULES_PAGE_ONE_INDEX:
		_show_rules(rules_page_one_text)
	elif selected_index == ConstantsManager.RULES_PAGE_TWO_INDEX:
		_show_rules(rules_page_two_text)
	elif selected_index == ConstantsManager.QUIT_INDEX:
		_show_quit_screen()


func _on_title_screen_selector_selection_changed(index: int) -> void:
	_update_based_on_selection(index)


func _on_title_screen_selector_selected(index: int) -> void:
	if index == ConstantsManager.START_INDEX:
		title_screen_selector.set_active(false)
		emit_signal("started_game")
	elif index == ConstantsManager.QUIT_INDEX:
		get_tree().quit()
