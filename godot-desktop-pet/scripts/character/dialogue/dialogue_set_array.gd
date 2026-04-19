@icon("res://icon.svg")
class_name DialogueSetArray
extends Resource


@export var dialogue_set_array : Array[DialogueSet]

func save_to_json(path : String):
	JsonOperations.save_json(get_json_data(), path)

func get_json_data():
	var json_data : Dictionary = {
		"DialogueArray" : dialogue_set_to_data()
	}
	return json_data

func dialogue_set_to_data():
	var dialogue_data : Array[Dictionary]
	
	for dialogue_set in dialogue_set_array:
		var line_to_add : Dictionary = dialogue_set.get_json_data()
		dialogue_data.append(line_to_add)
	
	return dialogue_data

func load_from_json(json_data : Dictionary):
	var array_of_resources : Array = json_data.get("DialogueArray")
	
	var dialogue_array : Array[DialogueSet]
	for resource in array_of_resources:
		var dialogue = DialogueSet.new()
		
		dialogue.load_from_json(resource)
		
		dialogue_array.append(dialogue)
	
	dialogue_set_array = dialogue_array
