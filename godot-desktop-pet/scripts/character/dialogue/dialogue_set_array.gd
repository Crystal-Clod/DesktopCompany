@icon("res://icon.svg")
class_name DialogueSetArray
extends Resource


@export var dialogue_array : Array[DialogueSet]

func save_to_json(path : String):
	JsonOperations.save_json(get_json_data(), path)

func get_json_data():
	var json_data : Dictionary = {
		"DialogueArray" : dialogue_set_to_data()
	}
	return json_data

func dialogue_set_to_data():
	var dialogue_data : Array[Dictionary]
	
	for dialogue_set in dialogue_array:
		var line_to_add : Dictionary = dialogue_set.get_json_data()
		dialogue_data.append(line_to_add)
	
	return dialogue_data
