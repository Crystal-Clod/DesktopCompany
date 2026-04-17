class_name AnimationStateMachine
extends Node

@export var initial_state: AnimationState

var current_state: AnimationState
var states := {}

func init() -> void:
	for child: AnimationState in get_children():
		if child:
			states[child.name] = child
			child.transition_requested.connect(_on_transition_requested)
		
		if initial_state:
			initial_state.enter()
			current_state = initial_state

func _process(delta: float) -> void:
	if current_state != null:
		current_state.run(delta)

func _on_transition_requested(from: AnimationState, to: String):
	if from != current_state:
		return
	
	var new_state: AnimationState = states[to]
	if not new_state:
		return
	
	if current_state:
		current_state.exit()
		
	new_state.enter()
	current_state = new_state
	
func play_animation(animation_name: String):
	_on_transition_requested(current_state, animation_name)
