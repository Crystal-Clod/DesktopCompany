class_name JsonOperations

static  func save_json(_json_data : Dictionary, _path : String):
	_path = _path.trim_suffix(_path.get_extension())
	_path = _path + ".json"
	
	if FileAccess.file_exists(_path):
		print("overwriting...")
	else:
		print("making new file")
		
	var file = FileAccess.open(_path, FileAccess.ModeFlags.WRITE)
	
	if file:
		var json_text = JSON.stringify(_json_data, "\t", false)
		file.store_string(json_text)
		#EditorInterface.get_resource_filesystem().scan()
		print("finished writing data")
	else:
		printerr("data writing failure")
	pass

static func load_json(_path : String) -> Dictionary:
	var data_file = FileAccess.open(_path, FileAccess.READ)
	print(data_file)
	var parsed_result = JSON.parse_string(data_file.get_as_text())
	return parsed_result
