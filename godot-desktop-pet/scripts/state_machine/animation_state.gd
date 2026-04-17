@tool
class_name AnimationState
extends Node

@export var state_name : String = ""
@export var animation_data: AnimationData

@export_category("JSON")
@export var character_name = "Donqui"
@export_tool_button("Generate Json")
var button = save_to_json

signal transition_requested(from: AnimationState, to: String)

func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func run(_delta: float) -> void:
	pass

func save_to_json():
	#var state_directory = 
	pass
