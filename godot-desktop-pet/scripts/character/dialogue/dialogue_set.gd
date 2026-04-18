@tool
@icon("res://icon.svg")
extends Resource
class_name DialogueSet

@export_tool_button("Save To Json")
var button = _save_to_json

@export_tool_button("Load From Json")
var button_load = load_json_test

@export_range(0,100, 0.1) var rarity : float = 100
@export var dialogues : Array[DialogueResource]

func load_json_test():
	var dialogue_set_data = JsonOperations.load_json(
			"res://Characters/Donqui/Resources/Dialogue/Intro/DialogueSetTest.json")
	var dialogue_set : DialogueSet = DialogueSet.new()
	dialogue_set.load_from_json(dialogue_set_data)


func load_from_json(json_data : Dictionary):
	var array_of_resources : Array = json_data.get("Dialogue")
	
	var dialogue_array : Array[DialogueResource]
	for resource in array_of_resources:
		var dialogue = DialogueResource.new()
		
		dialogue.load_from_json(resource)
		
		dialogue_array.append(dialogue)
	
	dialogues = dialogue_array
	rarity = json_data.get("Rarity")
	

func _save_to_json():
	JsonOperations.save_json(get_json_data(), self.resource_path)

func save_to_json(path : String):
	JsonOperations.save_json(get_json_data(), path)

func get_json_data():
	var json_data : Dictionary = {
		"Rarity" : rarity,
		"Dialogue" : dialogue_text_to_data()
	}
	return json_data

func dialogue_text_to_data():
	var dialogue_data : Array[Dictionary]
	
	for dialogue in dialogues:
		var line_to_add : Dictionary = dialogue.get_json_data()
		dialogue_data.append(line_to_add)
	
	return dialogue_data
