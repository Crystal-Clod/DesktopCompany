extends Node

@export var states: Dictionary[String,AnimationState]
@export var internal_states : Dictionary[String,AnimationState]
@export var external_states : Dictionary[String,AnimationState]

func initialize_states(current_character: String):
		var state_directory = ResourceLoader.list_directory("res://Characters/" + current_character + "/States/")
