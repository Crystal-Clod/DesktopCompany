class_name AnimationState
extends Node

@export var state_name : String = ""
@export var animation_resource_set: AnimationResourceSet

var current_animation = AnimationResource

signal transition_requested(from: AnimationState, to: String)

func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func run(_delta: float) -> void:
	pass

func save_to_json(path : String):
	JsonOperations.save_json(get_json_data(), path)

func get_json_data():
	var json_data : Dictionary = {
		"StateName" : state_name,
		"AnimationName" : animation_resource_set.collection_name
		
	}
	return json_data
