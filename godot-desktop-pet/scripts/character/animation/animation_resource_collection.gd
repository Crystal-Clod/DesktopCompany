extends Resource
class_name AnimationResourceCollection

@export var animation_data_collection:Array[AnimationResource]

func save_to_json(path : String):
	JsonOperations.save_json(get_json_data(), path)

func get_json_data():
	var json_data : Dictionary = {
		"AnimationDataArray" : animation_resources_to_data()
	}
	return json_data
	
func animation_resources_to_data():
	var animation_data : Array[Dictionary]
	
	for animation_resource in animation_data_collection:
		var data_to_add : Dictionary = animation_resource.get_json_data()
		animation_data.append(data_to_add)
	
	return animation_data

func load_from_json(json_data : Dictionary):
	var array_of_resources : Array = json_data.get("AnimationDataArray")
	
	var animation_resource_array : Array[AnimationResource]
	for resource in array_of_resources:
		var animation_resource = AnimationResource.new()
		
		animation_resource.load_from_json(resource)
		
		animation_resource_array.append(animation_resource)
	
	animation_data_collection = animation_resource_array
