extends Resource
class_name AnimationResourceCollection

@export var animation_data_collection:Array[AnimationResource]

func save_to_json(path : String):
	JsonOperations.save_json(get_json_data(), path)

func get_json_data():
	var json_data : Dictionary = {
		"AnimationDataArray" : dialogue_set_to_data()
	}
	return json_data
	
func dialogue_set_to_data():
	var animation_data : Array[Dictionary]
	
	for animation_resource in animation_data_collection:
		var data_to_add : Dictionary = animation_resource.get_json_data()
		animation_data.append(data_to_add)
	
	return animation_data
