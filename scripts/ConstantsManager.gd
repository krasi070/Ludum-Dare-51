extends Node

# Title screen menu options
const START_INDEX: int = 3
const RULES_PAGE_ONE_INDEX: int = 2
const RULES_PAGE_TWO_INDEX: int = 1
const QUIT_INDEX: int = 0

# Picture categories
const FIRE_PICTURES: Array = [0, 13, 22, 28]
const PLANT_PICTURES: Array = [26, 30]
const DRUG_PICTURES: Array = [1, 14]
const POLICE_PICTURES: Array = [5, 31, 34, 17]
const SEXY_PICTURES: Array = [18, 33]
const SWEET_PICTURES: Array = [5, 11, 29]
const ROBBERY_PICTURES: Array = [20, 23, 27, 32]
const NERDY_PICTURES: Array = [9, 10]
const VANDALISM_PICTURES: Array = [15, 16, 24, 2]
const ANIMAL_PICTURES: Array = [3, 12]
const RACCOON_PICTURES: Array = [3, 4, 21]
const ANTIFIRE_PICTURES: Array = [19]
const VEGETABLE_PICTURES: Array = [6, 25]
const SPORTS_PICTURES: Array = [7]
const FORMAL_PICTURES: Array = [8]

# Character data constants
const CHARACTER_NAMES: Array = [
	"Coppo",
	"Ember",
	"Robbin",
	"Stoney",
	"Vandal"
]
const EMOTIONS: Array = ["like", "meh", "dislike", "hate"]
const EMOTION_EFFECTS: Dictionary = {
	EMOTIONS[0]: 0,
	EMOTIONS[1]: 1,
	EMOTIONS[2]: 2,
	EMOTIONS[3]: 3,
}

# Character information
onready var character_preferences: Dictionary = {
	CHARACTER_NAMES[0]: {
		EMOTIONS[0]: HelperFunctions.merge_arrays([
			POLICE_PICTURES, 
			SEXY_PICTURES]),
		EMOTIONS[1]: HelperFunctions.merge_arrays([
			VEGETABLE_PICTURES, 
			SWEET_PICTURES, 
			ANTIFIRE_PICTURES,
			FORMAL_PICTURES]),
		EMOTIONS[2]: HelperFunctions.merge_arrays([
			PLANT_PICTURES,
			NERDY_PICTURES,
			RACCOON_PICTURES,
			ANIMAL_PICTURES]),
		EMOTIONS[3]: HelperFunctions.merge_arrays([
			FIRE_PICTURES, 
			DRUG_PICTURES,
			ROBBERY_PICTURES,
			VANDALISM_PICTURES,
			SPORTS_PICTURES]),
	},
	CHARACTER_NAMES[1]: {
		EMOTIONS[0]: HelperFunctions.merge_arrays([
			FIRE_PICTURES,
			PLANT_PICTURES]),
		EMOTIONS[1]: HelperFunctions.merge_arrays([
			DRUG_PICTURES,
			ROBBERY_PICTURES,
			VANDALISM_PICTURES,
			VEGETABLE_PICTURES]),
		EMOTIONS[2]: HelperFunctions.merge_arrays([
			SEXY_PICTURES,
			SPORTS_PICTURES,
			FORMAL_PICTURES]),
		EMOTIONS[3]: HelperFunctions.merge_arrays([
			ANTIFIRE_PICTURES,
			POLICE_PICTURES,
			NERDY_PICTURES,
			SWEET_PICTURES,
			ANIMAL_PICTURES,
			RACCOON_PICTURES]),
	},
	CHARACTER_NAMES[2]: {
		EMOTIONS[0]: HelperFunctions.merge_arrays([
			ROBBERY_PICTURES,
			NERDY_PICTURES]),
		EMOTIONS[1]: HelperFunctions.merge_arrays([
			RACCOON_PICTURES,
			VANDALISM_PICTURES,
			SWEET_PICTURES]),
		EMOTIONS[2]: HelperFunctions.merge_arrays([
			ANTIFIRE_PICTURES,
			ANIMAL_PICTURES,
			FIRE_PICTURES,
			DRUG_PICTURES,
			VEGETABLE_PICTURES,
			PLANT_PICTURES]),
		EMOTIONS[3]: HelperFunctions.merge_arrays([
			FORMAL_PICTURES,
			SPORTS_PICTURES,
			POLICE_PICTURES,
			SEXY_PICTURES]),
	},
	CHARACTER_NAMES[3]: {
		EMOTIONS[0]: HelperFunctions.merge_arrays([
			DRUG_PICTURES,
			SWEET_PICTURES]),
		EMOTIONS[1]: HelperFunctions.merge_arrays([
			SPORTS_PICTURES,
			RACCOON_PICTURES,
			ANIMAL_PICTURES,
			VANDALISM_PICTURES,
			ROBBERY_PICTURES,
			SEXY_PICTURES]),
		EMOTIONS[2]: HelperFunctions.merge_arrays([
			PLANT_PICTURES,
			NERDY_PICTURES,
			ANTIFIRE_PICTURES]),
		EMOTIONS[3]: HelperFunctions.merge_arrays([
			VEGETABLE_PICTURES,
			POLICE_PICTURES,
			FIRE_PICTURES,
			FORMAL_PICTURES]),
	},
	CHARACTER_NAMES[4]: {
		EMOTIONS[0]: HelperFunctions.merge_arrays([
			VANDALISM_PICTURES,
			ANIMAL_PICTURES]),
		EMOTIONS[1]: HelperFunctions.merge_arrays([
			RACCOON_PICTURES,
			FIRE_PICTURES,
			NERDY_PICTURES,
			VEGETABLE_PICTURES,
			PLANT_PICTURES,
			ROBBERY_PICTURES]),
		EMOTIONS[2]: HelperFunctions.merge_arrays([
			SWEET_PICTURES,
			SEXY_PICTURES,
			ANTIFIRE_PICTURES]),
		EMOTIONS[3]: HelperFunctions.merge_arrays([
			FORMAL_PICTURES,
			POLICE_PICTURES,
			SPORTS_PICTURES,
			DRUG_PICTURES]),
	},
}

# character name -> day -> [pic index, emotion hint index]
# emotion hints - like 0, meh 1, dislike 3, hate 2
const CHARACTER_BUBBLE_HINTS: Dictionary = {
	CHARACTER_NAMES[0]: {
		1: [[34, 0], [33, 0], [31, 0]],
		2: [[0, 2], [14, 2], [16, 2], [18, 0]],
		3: [[6, 1], [30, 3], [20, 2]],
		4: [[7, 2], [3, 3], [9, 3]],
		5: [],
	},
	CHARACTER_NAMES[1]: {
		1: [[28, 0], [13, 0]],
		2: [[19, 2], [26, 0], [34, 2]],
		3: [[11, 2], [3, 2]],
		4: [[10, 2], [33, 3]],
		5: [[25, 1], [32, 1]],
	},
	CHARACTER_NAMES[2]: {
		1: [[23, 0], [31, 2]],
		2: [[9, 0], [18, 2], [7, 2]],
		3: [[29, 1], [4, 1], [22, 3]],
		4: [[1, 3], [25, 3], [26, 3]],
		5: [[8, 2]],
	},
	CHARACTER_NAMES[3]: {
		1: [[1, 0], [34, 2]],
		2: [[11, 0], [6, 2], [28, 2]],
		3: [[7, 1], [3, 1], [9, 3]],
		4: [[33, 1], [16, 1], [23, 1]],
		5: [[26, 3]],
	},
	CHARACTER_NAMES[4]: {
		1: [[16, 0], [12, 0]],
		2: [[31, 2], [7, 2], [14, 2]],
		3: [[21, 1], [0, 1], [10, 1]],
		4: [[8, 2], [6, 1]],
		5: [[29, 3], [18, 3]],
	},
}
