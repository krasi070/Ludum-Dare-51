extends Control

signal passed_halfway

const TIME_LIMIT: float = 10.0

onready var timer: Timer = $Timer
onready var half_timer: Timer = $HalfTimer
onready var timer_label: Label = $Label
onready var anim_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	reset()
	timer.connect("timeout", self, "stop")
	half_timer.connect("timeout", self, "_on_half_timer_timeout")


func _process(delta: float) -> void:
	if not timer.is_stopped():
		timer_label.text = "%2.2f" % timer.time_left


func start() -> void:
	timer.start()
	half_timer.start()


func reset() -> void:
	timer.wait_time = TIME_LIMIT
	half_timer.wait_time = TIME_LIMIT * 0.4


func stop() -> void:
	timer.stop()
	half_timer.stop()


func _on_half_timer_timeout() -> void:
	half_timer.stop()
	emit_signal("passed_halfway")
