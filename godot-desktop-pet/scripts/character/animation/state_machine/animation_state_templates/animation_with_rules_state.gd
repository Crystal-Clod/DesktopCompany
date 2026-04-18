extends AnimationBaseState

@export var rule: StateRule
@export var other_state : AnimationState

func enter() -> void:
	super.enter()
	rule.init(self)

func run(_delta: float) -> void:
	if(rule.rule_check_passed()):
		transition_requested.emit(self, other_state.state_name)
	
