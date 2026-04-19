extends Node

@export var all_states: Dictionary[String,AnimationResourceCollection]

func initialize_states(current_character: String):
		var state_directory = ResourceLoader.list_directory("res://Characters/" + current_character + "/States/")
