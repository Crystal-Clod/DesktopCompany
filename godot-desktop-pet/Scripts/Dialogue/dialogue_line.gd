@tool
extends Resource
class_name DialogueLine

@export_multiline() var line : String
@export var talking_animation : String
@export var idling_animation : String

@export var save_load_path : String
@export_tool_button("Save To Json")
var button = _save_to_json

func _save_to_json():
	JsonOperations.save_json(self)
	#JsonOperations._save_json(DialogueLine)
	pass
