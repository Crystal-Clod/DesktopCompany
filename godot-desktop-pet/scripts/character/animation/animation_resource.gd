extends Resource
class_name AnimationResource

@export var animation_name: String
@export var frame_count : int
@export var spritesheet : CompressedTexture2D

func get_json_data():
	var json_data : Dictionary = {
		"AnimationName" : animation_name,
		"FrameCount" : frame_count
	}
	return json_data
