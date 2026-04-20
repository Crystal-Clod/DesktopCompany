extends Resource
class_name AnimationResource

@export var animation_name: String
@export var frame_count : int
@export var dialogue_box_offset : Vector2
@export var spritesheet : Texture2D

func get_json_data():
	var json_data : Dictionary = {
		"AnimationName" : animation_name,
		"FrameCount" : frame_count,
		"DialogueBoxOffset" : dialogue_box_offset
	}
	return json_data
	
func load_from_json(json_data : Dictionary):
	animation_name = json_data.get("AnimationName")
	frame_count = json_data.get("FrameCount")
	
