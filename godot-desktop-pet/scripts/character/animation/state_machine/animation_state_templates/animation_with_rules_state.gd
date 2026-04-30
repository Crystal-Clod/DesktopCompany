extends AnimationBaseState

@export var rule_set: StateRuleSet
@export var other_state : AnimationState

func enter() -> void:
	super.enter()
	current_animation = animation_resource_set.animation_resources.pick_random()
	rule_set.init(self)

func run(_delta: float) -> void:
	if(rule_set.rule_check_passed()):
		transition_requested.emit(self, other_state.state_name)
	
