extends Control

onready var texture_rect: TextureRect = $TextureRect


func _ready():
	texture_rect.rect_position = Vector2(0, -2170)
	show()
