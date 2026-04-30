class_name AnimationEndRule
extends StateRule
var timer_ended: bool = false
var timer: SceneTreeTimer

func init(animation_state: AnimationState = null) -> void:
	if animation_state == null:
		print("Animation state is null, this should not happen")
		return
	
	timer = Engine.get_main_loop().create_timer(
		animation_state.current_animation.frame_count/6.0)
		
	timer_ended = false
	
	await timer.timeout
	
	timer_ended = true

func rule_check_passed() -> bool:
	return timer_ended
