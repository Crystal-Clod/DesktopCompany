@icon("res://icon.svg")
extends Resource
class_name DialogueLine

@export_multiline() var line : String
@export var talking_animation : String
@export var idling_animation : String


func _save_to_json():
	JsonOperations.save_json(get_json_data(), self.resource_path)
	#JsonOperations._save_json(DialogueLine)
	pass

func get_json_data():
	var json_data : Dictionary = {
		"line" : line,
		"talking_animation" : talking_animation,
		"idling_animation" : idling_animation
	}
	return json_data
