extends Node2D

signal hated_by_character

# Visual elements of character
export var character_spritesheet: Texture
export var character_name: String
# Hidden values
export var interest_threshold: int
export var strike_threshold: int = 3
export var starting_interest_level: int = 5
export var like_increase_rate: int = 3
export var meh_increase_rate: int = 1
export var dislike_decrease_rate: int = 1
export var hate_decrease_rate: int = 2
export var emotion_frames: Dictionary
# Game over messages
export var game_over_top_message: String
export(String, MULTILINE) var game_over_letter_message: String

var interest_level: int = 0
var strikes: int = 0 setget set_strikes
var num_pics_received_in_curr_date: int = 0
var last_reaction: String
var bubble_hints_pool: Array = []

var selector: Node2D
var name_label: Label
var rng = RandomNumberGenerator.new()

onready var sprite: Sprite = $Sprite
onready var strike_area: Node2D = $StrikeArea
onready var strike_sprites: Array = [
	$StrikeArea/Sprite1, 
	$StrikeArea/Sprite2, 
	$StrikeArea/Sprite3]
onready var emotion_sprite_res: PackedScene = preload("res://scenes/EmotionSprite.tscn")
onready var emotion_positions: Array = [
	$EmotionEffect/PositionOne,
	$EmotionEffect/PositionTwo,
	$EmotionEffect/PositionThree]
onready var pic_bubble: Node2D = $PictureBubble
onready var pic_bubble_anim_player: AnimationPlayer = \
	$PictureBubble/AnimationPlayer
onready var curr_pic_sprite: Sprite = $PictureBubble/PictureSprite
onready var emotion_hint_sprite: Sprite = $PictureBubble/EmotionHintSprite


func _ready() -> void:
	rng.randomize()
	reset_stats()
	sprite.texture = character_spritesheet
	selector = get_tree().current_scene.get_node("PictureSelector")
	selector.connect("selected", self, "_on_pic_selected")
	_set_name_label()
	_play_looping_animations()


func set_strikes(new_val: int) -> void:
	strikes = max(new_val, 0)
	_update_strike_sprites()
	if strikes >= strike_threshold:
		emit_signal("hated_by_character")


func set_interest(new_val: int) -> void:
	interest_level = new_val


func set_curr_bubble(day: int) -> void:
	var hints_to_add: Array = \
		ConstantsManager.CHARACTER_BUBBLE_HINTS[character_name][day]
	bubble_hints_pool.append_array(hints_to_add)
	change_curr_bubble()


func change_curr_bubble(with_anim: bool = false) -> void:
	if with_anim:
		pic_bubble_anim_player.play("fade_out")
		yield(pic_bubble_anim_player, "animation_finished")
	var rand_hint_pair_index: int = rng.randi() % bubble_hints_pool.size()
	var rand_hint_pair: Array = bubble_hints_pool.pop_at(rand_hint_pair_index)
	var pic_hint_index: int = rand_hint_pair[0]
	var emotion_hint_index: int = rand_hint_pair[1]
	curr_pic_sprite.frame = pic_hint_index
	emotion_hint_sprite.frame = emotion_hint_index
	if with_anim:
		pic_bubble_anim_player.play_backwards("fade_out")
		yield(pic_bubble_anim_player, "animation_finished")
		pic_bubble_anim_player.play_backwards("bubble_loop")


func get_curr_pic_in_bubble_index() -> int:
	return curr_pic_sprite.frame


func is_active() -> bool:
	return visible


func is_over_interest_threshold() -> bool:
	return interest_level >= interest_threshold


func is_last_react_like() -> bool:
	return last_reaction == "like"


func get_letter_status() -> String:
	if interest_level < interest_threshold / 4:
		return "hates you"
	elif interest_level < interest_threshold / 2:
		return "doesn't remember you"
	elif interest_level < interest_threshold * 3 / 4:
		return "talks about you"
	else:
		return "likes you"


func prepare_for_date(day: int) -> void:
	num_pics_received_in_curr_date = 0
	name_label.text = character_name
	set_curr_bubble(day)
	sprite.frame = emotion_frames["dislike"]
	show()


# Returns number of pics selected by player during date
func finish_date() -> int:
	hide()
	return num_pics_received_in_curr_date


func reset_stats() -> void:
	interest_level = starting_interest_level
	self.strikes = 0
	_reset_used_bubble_hints()
	hide()


func _instance_emotion_effect(emotion_index: int) -> void:
	var rand_pos_index: int = rng.randi() % emotion_positions.size()
	var emotion_instance = emotion_sprite_res.instance()
	emotion_instance.frame = emotion_index
	emotion_positions[rand_pos_index].add_child(emotion_instance)


func _set_name_label() -> void:
	name_label = get_tree().current_scene.get_node("NameplateSprite/NameLabel")


func _play_looping_animations() -> void:
	strike_area.get_node("AnimationPlayer").play("strike_area_loop")
	pic_bubble_anim_player.play("bubble_loop")


func _reset_used_bubble_hints() -> void:
	bubble_hints_pool = []


func _update_strike_sprites() -> void:
	for i in range(strike_sprites.size()):
		if strikes > i:
			strike_sprites[i].show()
		else:
			strike_sprites[i].hide()


func _check_if_pic_is(pic: int, emotion: String) -> bool:
	return ConstantsManager.character_preferences[character_name][emotion] \
		.has(pic)


func _like_pic() -> void:
	# Maybe if there are strikes you don't gain interest???
	interest_level += like_increase_rate
	self.strikes -= 1
	last_reaction = "like"
	sprite.frame = emotion_frames["like"]
	AudioController.play_voice(AudioController.LIKE_SOUND)
	_instance_emotion_effect(ConstantsManager.EMOTION_EFFECTS["like"])


func _meh_pic() -> void:
	interest_level += meh_increase_rate
	last_reaction = "meh"
	sprite.frame = emotion_frames["meh"]
	AudioController.play_voice(AudioController.MEH_SOUND)
	_instance_emotion_effect(ConstantsManager.EMOTION_EFFECTS["meh"])


func _dislike_pic() -> void:
	self.strikes += 1
	last_reaction = "dislike"
	sprite.frame = emotion_frames["dislike"]
	AudioController.play_voice(AudioController.DISLIKE_SOUND)
	_instance_emotion_effect(ConstantsManager.EMOTION_EFFECTS["dislike"])


func _hate_pic() -> void:
	self.strikes += 2
	last_reaction = "hate"
	sprite.frame = emotion_frames["hate"]
	AudioController.play_voice(AudioController.HATE_SOUND)
	_instance_emotion_effect(ConstantsManager.EMOTION_EFFECTS["hate"])


func _on_pic_selected(selected_pic_index: int) -> void:
	if is_active():
		num_pics_received_in_curr_date += 1
		if _check_if_pic_is(selected_pic_index, "like"):
			_like_pic()
		elif _check_if_pic_is(selected_pic_index, "meh"):
			_meh_pic()
		elif _check_if_pic_is(selected_pic_index, "dislike"):
			_dislike_pic()
		else:
			_hate_pic()
