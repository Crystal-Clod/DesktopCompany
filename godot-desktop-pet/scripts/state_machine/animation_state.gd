class_name AnimationState
extends Node

@export var state_name : String = ""

signal transition_requested(from: AnimationState, to: String)

func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func run(_delta: float) -> void:
	pass
	
