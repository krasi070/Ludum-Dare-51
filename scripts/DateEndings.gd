extends Node2D

signal exited_ending_screen

var is_active: bool = false

onready var ending_images: Array = [
	$CoppoEnding,
	$EmberEnding,
	$RobbinEnding,
	$StoneyEnding,
	$VandalEnding,
]


func _input(event: InputEvent) -> void:
	if is_active and event.is_action_released("selector_select"):
		emit_signal("exited_ending_screen")
		is_active = false


func show_ending(character_name: String) -> void:
	for i in range(ending_images.size()):
		ending_images[i].hide()
	var ending_image: Sprite = get_ending_by_name(character_name)
	ending_image.show()


func get_ending_by_name(character_name: String) -> Sprite:
	var index: int = ConstantsManager.CHARACTER_NAMES.find(character_name)
	return ending_images[index]
