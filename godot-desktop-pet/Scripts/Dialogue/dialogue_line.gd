@tool
extends Resource
class_name DialogueLine

@export_multiline() var line : String
@export var talking_animation : String
@export var idling_animation : String

@export_tool_button("Save To Json")
var button = _save_to_json

func _save_to_json():
	
	var json_data : Dictionary = {
		"line" : line,
		"talking_animation" : talking_animation,
		"idling_animation" : idling_animation
	}
	JsonOperations.save_json(json_data, self.resource_path)
	#JsonOperations._save_json(DialogueLine)
	pass
