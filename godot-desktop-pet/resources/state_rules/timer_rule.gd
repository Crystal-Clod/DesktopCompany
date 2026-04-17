class_name TimerRule
extends StateRule
var rng = RandomNumberGenerator.new()
var timer_ended: bool = false
@export var timer_minimum: float = 0.5
@export var timer_maximum: float = 3

func init(animation_state: AnimationState = null) -> void:
	timer_ended = false
	var timer_length = rng.randf_range(timer_minimum,timer_maximum)
	
	await Engine.get_main_loop().create_timer(
		timer_length).timeout
	timer_ended = true

func rule_check_passed() -> bool:
	return timer_ended
