@icon("res://icon.svg")
extends Resource
class_name DialogueSet

@export_range(0,100, 0.1) var rarity : float = 100
@export var dialogues : Array[DialogueResource]


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
