@tool
@icon("res://icon.svg")
extends Resource
class_name DialogueResource

@export_tool_button("Save To Json")
var button = _save_to_json

@export var dialogue_text : Array[DialogueLine]

func _save_to_json():
	
	var dialogue_line_data : Array[Dictionary]
	
	for  line in dialogue_text:
		var line_to_add : Dictionary = line.get_json_data()
		dialogue_line_data.append(line_to_add)
		
	
	var json_data : Dictionary = {
		"DialogueLineArray" : dialogue_line_data
	}
	
	JsonOperations.save_json(json_data, self.resource_path)
	pass
	
func load_from_json(json_data : Dictionary):
	var array_of_dictionaries : Array = json_data.get("DialogueLineArray")
	
	var line_array : Array[DialogueLine]
	for dict in array_of_dictionaries:
		var line = DialogueLine.new()
		
		line.line = dict.line
		line.idling_animation = dict.idling_animation
		line.talking_animation = dict.talking_animation
		
		line_array.append(line)
	
	dialogue_text = line_array
	
