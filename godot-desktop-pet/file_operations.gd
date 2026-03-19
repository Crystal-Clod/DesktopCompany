class_name FileOperations

static func print_all_files_from_directory(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

static func get_all_files_of_type_from_directory(path, extension : String) -> Array[String]:
	var dir = DirAccess.open(path)
	var files : Array[String]
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if !dir.current_is_dir():
				if(file_name.ends_with("." + extension)):
					
					files.append(path+file_name)
					print("Found file: " + file_name)
				
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	
	return files
