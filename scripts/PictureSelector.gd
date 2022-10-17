extends "res://scripts/BaseSelector.gd"

const PICS_COUNT: int = 35
const USED_PIC_ALPHA: float = 127.0 / 255.0
const SPACE_TEXT: String = "SPACE"
const SPACE_COLOR: Color = Color(0.2, 0.14, 0.29)
const USED_TEXT: String = "USED"
const USED_COLOR: Color = Color(0.8, 0.32, 0.2)

var rng = RandomNumberGenerator.new()
var used_pic_in_arr: Array = []


func _ready() -> void:
	rng.randomize()


# Override parent function
func selector_select_curr() -> void:
	if not used_pic_in_arr[selected_index]:
		used_pic_in_arr[selected_index] = true
		AudioController.play_ui_sound(AudioController.SELECT)
		.selector_select_curr()
	else:
		AudioController.play_ui_sound(AudioController.USED_CLICK)


func set_pictures(character: Node2D, amount: int) -> void:
	selected_index = 0
	indexes_arr = []
	used_pic_in_arr = []
	var bubble_pic_index: int = character.get_curr_pic_in_bubble_index()
	var amount_added: int = _add_certain_pics(character.character_name)
	amount -= amount_added
	var candidates: Array = _get_arr_of_possible_pics(character)
	for i in range(amount):
		var rand_index: int = rng.randi() % candidates.size()
		indexes_arr.append(candidates[rand_index])
		used_pic_in_arr.append(false)
		candidates.remove(rand_index)
	randomize()
	indexes_arr.shuffle()


func update_sprite_frame() -> void:
	selected_sprite.frame = indexes_arr[selected_index]
	_show_selectable_pic()


# Override parent function
func _update_selected_sprite() -> void:
	._update_selected_sprite()
	if used_pic_in_arr[selected_index]:
		_show_used_pic()
	else:
		_show_selectable_pic()


func _show_selectable_pic() -> void:
	selected_sprite.modulate.a = 1.0
	action_label.text = SPACE_TEXT
	action_label.add_color_override("font_color", SPACE_COLOR)


func _show_used_pic() -> void:
	selected_sprite.modulate.a = USED_PIC_ALPHA
	action_label.text = USED_TEXT
	action_label.add_color_override("font_color", USED_COLOR)


# Returns how many added
func _add_certain_pics(char_name: String) -> int:
	var likes: int = _add_rand_from_emotion(char_name, "like", 1, 2)
	var mehs: int = _add_rand_from_emotion(char_name, "meh", 1, 4)
	var hates: int = _add_rand_from_emotion(char_name, "hate", 1, 1)
	# Populate used arr
	for i in range(indexes_arr.size()):
		used_pic_in_arr.append(false)
	# Return number of added pics
	return likes + mehs + hates


func _add_rand_from_emotion(
	char_name: String, 
	emotion: String, 
	start: int, 
	end: int) -> int:
	var emotion_pics: Array = ConstantsManager \
		.character_preferences[char_name][emotion]
	var rand_num: int = rng.randi_range(start, end)
	indexes_arr.append_array(
		HelperFunctions.get_n_rand_items_from_arr(emotion_pics, rand_num))
	return rand_num


func _get_arr_of_possible_pics(character: Node2D) -> Array:
	var cand_pics: Array = []
	for i in range(PICS_COUNT):
		if not indexes_arr.has(i):
			cand_pics.append(i)
	return cand_pics
