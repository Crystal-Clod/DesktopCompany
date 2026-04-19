extends Resource
class_name AnimationResource

@export var animation_name: String
@export var animation_type : String
@export var file_name : String
@export var frame_amount : int
@export var spritesheet : CompressedTexture2D

func get_json_data():
	var json_data : Dictionary = {
		"AnimationName" : animation_name,
		"AnimationType" : animation_type
	}
	return json_data
