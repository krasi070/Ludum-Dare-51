extends Sprite

onready var anim_player := $AnimationPlayer


func _ready() -> void:
	show()
	self_modulate = Color(1, 1, 1, 1)
	anim_player.connect("animation_finished", self, "_on_anim_finished")
	anim_player.play("pop")


func _on_anim_finished(anim_name: String) -> void:
	queue_free()
