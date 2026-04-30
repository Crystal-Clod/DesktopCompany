class_name StateRuleSet
extends Resource

@export var state_rule_collection : Array[StateRule]

func init(state : AnimationState):
	for rule in state_rule_collection:
		rule.init(state)

func rule_check_passed() -> bool:
	for rule in state_rule_collection:
		if rule.rule_check_passed():
			continue
		else:
			return false
	
	return true
