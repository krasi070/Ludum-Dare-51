extends Node2D

const LAST_DAY: int = 5
const MIN_AMOUNT_OF_PICS: int = 7
const NUM_OF_PICS_BY_DAY: Array = [0, 8, 10, 10, 12, 15]

var rng = RandomNumberGenerator.new()
var active_date_character: Node2D
var dates_left_for_today: Array
var date_timer: Control
var transition_animation_player: AnimationPlayer
var pic_selector: Node2D

var day: int = 1
var date_bg: Sprite
var date_bg_chair: Sprite
var date_bg_table: Sprite
var new_day_bg: Sprite
var endings: Node2D

onready var characters: Dictionary = {
	ConstantsManager.CHARACTER_NAMES[0]: $Coppo,
	ConstantsManager.CHARACTER_NAMES[1]: $Ember,
	ConstantsManager.CHARACTER_NAMES[2]: $Robbin,
	ConstantsManager.CHARACTER_NAMES[3]: $Stoney,
	ConstantsManager.CHARACTER_NAMES[4]: $Vandal,
}


func _ready() -> void:
	rng.randomize()
	_setup_date_timer()
	_set_transition_animation_player()
	_setup_backgrounds()
	_set_pic_selector()
	_setup_endings()
	_connect_to_character_signals()
	show_new_day_bg()


func start_date() -> void:
	_set_random_active_character_from_date_pool()
	_update_pic_selector()
	transition_animation_player.play("transition_out")
	yield(transition_animation_player, "animation_finished")
	date_timer.anim_player.play("start_date_countdown")
	yield(date_timer.anim_player, "animation_finished")
	AudioController.play_sfx(AudioController.BEEP_BEEP)
	pic_selector.set_active(true)
	date_timer.start()


func end_date() -> void:
	pic_selector.set_active(false)
	date_timer.anim_player.play("end_date")
	yield(date_timer.anim_player, "animation_finished")
	transition_animation_player.play("transition_in")
	yield(transition_animation_player, "animation_finished")
	var num_pics: int = active_date_character.finish_date()
	if num_pics > 0:
		date_timer.reset()
		check_next_date()
	else:
		show_game_over(active_date_character, true)


func check_next_date() -> void:
	if dates_left_for_today.size() > 0:
		start_date()
	else:
		start_new_day()


func set_dates_for_today() -> void:
	dates_left_for_today = ConstantsManager.CHARACTER_NAMES.duplicate(true)


func start_new_day() -> void:
	if day == LAST_DAY:
		show_final_choice()
		return
	day += 1
	set_dates_for_today()
	show_new_day_bg()
	new_day_bg.prepare_for_new_day(day, characters)
	AudioController.play_sfx(AudioController.RUSTLE_PAPER)
	transition_animation_player.play("transition_out")
	yield(transition_animation_player, "animation_finished")
	new_day_bg.enable_new_day_screen()


func show_final_choice() -> void:
	show_new_day_bg()
	var correct_character: Node2D = _get_correct_character()
	new_day_bg.prepare_for_choose_date(correct_character)
	AudioController.play_sfx(AudioController.RUSTLE_PAPER)
	transition_animation_player.play("transition_out")
	yield(transition_animation_player, "animation_finished")
	new_day_bg.enable_choose_date()


func show_game_over(character: Node2D, is_timeout: bool) -> void:
	show_new_day_bg()
	new_day_bg.prepare_for_game_over(character, is_timeout)
	AudioController.play_sfx(AudioController.RUSTLE_PAPER)
	transition_animation_player.play("transition_out")
	yield(transition_animation_player, "animation_finished")
	new_day_bg.enable_game_over_screen()


func reset_states() -> void:
	day = 1
	_reset_date_timer()
	_reset_characters()


func go_to_title_screen() -> void:
	transition_animation_player.play("transition_in")
	yield(transition_animation_player, "animation_finished")
	show_new_day_bg()
	new_day_bg.prepare_for_title_screen()
	transition_animation_player.play("transition_out")
	yield(transition_animation_player, "animation_finished")
	new_day_bg.enable_title_screen()


func show_new_day_bg() -> void:
	date_bg.hide()
	date_bg_chair.hide()
	date_bg_table.hide()
	endings.hide()
	new_day_bg.show()


func show_date_bg() -> void:
	date_bg.show()
	date_bg_chair.show()
	date_bg_table.show()
	endings.hide()
	new_day_bg.hide()


func show_endings_screen() -> void:
	date_bg.hide()
	date_bg_chair.hide()
	date_bg_table.hide()
	endings.show()
	new_day_bg.hide()


func _set_random_active_character_from_date_pool() -> void:
	var rand_index: int = rng.randi() % dates_left_for_today.size()
	var rand_date: String = dates_left_for_today.pop_at(rand_index)
	for name in characters:
		characters[name].hide()
	active_date_character = characters[rand_date]
	active_date_character.prepare_for_date(day)


func _update_pic_selector() -> void:
	pic_selector.set_pictures(active_date_character, NUM_OF_PICS_BY_DAY[day])
	pic_selector.update_sprite_frame()


func _setup_date_timer() -> void:
	date_timer = get_tree().current_scene.get_node("DateTimer")
	date_timer.get_node("Timer").connect(
		"timeout", 
		self, 
		"_on_date_timer_timeout")
	date_timer.connect(
		"passed_halfway", 
		self, 
		"_on_date_timer_passed_halfway")


func _set_transition_animation_player() -> void:
	transition_animation_player = get_tree().current_scene.get_node(
		"Transition/AnimationPlayer")


func _setup_backgrounds() -> void:
	# Date background
	date_bg = get_tree().current_scene.get_node("DateBackground")
	date_bg_chair = get_tree().current_scene.get_node("ChairSprite")
	date_bg_table = get_tree().current_scene.get_node("TableSprite")
	# New day background
	new_day_bg = get_tree().current_scene.get_node("NewDayBackground")
	new_day_bg.connect("exited_new_day_screen", self, "_on_exited_new_day_screen")
	new_day_bg.connect(
		"exited_game_over_screen", 
		self, 
		"_on_exited_game_over_screen")
	new_day_bg.connect("started_game", self, "_on_started_game")
	new_day_bg.connect("date_succeeded", self, "_on_date_succeeded")
	new_day_bg.connect("date_did_not_succeed", self, "_on_date_did_not_succeed")


func _set_pic_selector() -> void:
	pic_selector = get_tree().current_scene.get_node("PictureSelector")


func _setup_endings() -> void:
	endings = get_tree().current_scene.get_node("DateEndings")
	endings.connect("exited_ending_screen", self, "_on_exited_ending_screen")


func _get_correct_character() -> Node2D:
	var character_with_max_interest: Node2D = null
	for name in characters:
		if characters[name].is_over_interest_threshold() and \
			(not is_instance_valid(character_with_max_interest) or \
			characters[name].interest_level > character_with_max_interest.interest_level):
			character_with_max_interest = characters[name]
	if is_instance_valid(character_with_max_interest):
		return character_with_max_interest
	return null


func _reset_characters() -> void:
	for name in characters:
		characters[name].reset_stats()


func _reset_date_timer() -> void:
	date_timer.stop()
	date_timer.reset()


func _connect_to_character_signals() -> void:
	for name in characters:
		characters[name].connect(
			"hated_by_character", 
			self, 
			"_on_hated_by_character")


func _on_hated_by_character() -> void:
	date_timer.stop()
	pic_selector.set_active(false)
	transition_animation_player.play("transition_in")
	yield(transition_animation_player, "animation_finished")
	show_game_over(active_date_character, false)


func _on_date_timer_timeout() -> void:
	AudioController.play_sfx(AudioController.BEEP_BEEP)
	end_date()


func _on_date_timer_passed_halfway() -> void:
	active_date_character.change_curr_bubble(true)


func _on_started_game() -> void:
	transition_animation_player.play("transition_in")
	yield(transition_animation_player, "animation_finished")
	set_dates_for_today()
	show_date_bg()
	start_date()


func _on_exited_new_day_screen() -> void:
	transition_animation_player.play("transition_in")
	yield(transition_animation_player, "animation_finished")
	show_date_bg()
	start_date()


func _on_date_succeeded() -> void:
	var date: Node2D = _get_correct_character()
	transition_animation_player.play("transition_in")
	yield(transition_animation_player, "animation_finished")
	show_endings_screen()
	endings.show_ending(date.character_name)
	endings.is_active = true
	transition_animation_player.play("transition_out")
	yield(transition_animation_player, "animation_finished")


func _on_date_did_not_succeed() -> void:
	transition_animation_player.play("transition_in")
	yield(transition_animation_player, "animation_finished")
	show_game_over(null, false)


func _on_exited_game_over_screen() -> void:
	reset_states()
	go_to_title_screen()


func _on_exited_ending_screen() -> void:
	reset_states()
	go_to_title_screen()
